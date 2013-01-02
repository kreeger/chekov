#import "BDKBaseTableViewController.h"

@interface BDKBaseTableViewController ()

@property (nonatomic) UITableViewStyle style;

- (void)buildRefreshControl;

@end

@implementation BDKBaseTableViewController

+ (id)controllerWithStyle:(UITableViewStyle)style {
    return [[self alloc] initWithStyle:style];
}

- (id)init {
    if ((self = [super init])) {
        _style = UITableViewStylePlain;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super init])) {
        _style = style;
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (UITableView *)tableView {
    if (_tableView != nil) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return _tableView;
}

- (void)buildRefreshControl {
    __weak BDKBaseTableViewController *unretainedSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [unretainedSelf refreshViewWithRefreshControl:unretainedSelf.tableView.pullToRefreshView];
    }];
    [self.tableView.pullToRefreshView setSubtitle:@"Please wait..." forState:SVPullToRefreshStateLoading];
    // refresher.tintColor = [UIColor colorWithHexString:kColorSilver];
}

- (void)refreshViewWithRefreshControl:(SVPullToRefreshView *)pullToRefreshView {
    // [pullToRefreshView setSubtitle:@"Loading..." forState:SVPullToRefreshStateLoading];
}

- (void)timestampRefreshControl {
    NSString *dateString = [[NSDate date] stringFromDateWithFormat:@"'Last updated: 'MM/dd/yyyy h:mm a"];
    [self.tableView.pullToRefreshView setSubtitle:dateString forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView stopAnimating];
}

@end
