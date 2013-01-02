#import "BDKErrorGroupViewController.h"
#import "BDKNoticeViewController.h"
#import "BDKNoticeCell.h"

#import "UIViewController+Authentication.h"
#import "UIViewController+Airbrake.h"
#import "UITableViewCell+Awesome.h"

#import <EDColor/UIColor+Hex.h>

@interface BDKErrorGroupViewController ()

@property (strong, nonatomic) NSMutableArray *notices;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic) BOOL isLoading;

- (void)loadNotices;
- (AirbrakeNotice *)airbrakeNoticeForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BDKErrorGroupViewController

+ (id)controllerWithErrorGroup:(AirbrakeGroup *)errorGroup {
    return [[self alloc] initWithErrorGroup:errorGroup];
}

- (id)initWithErrorGroup:(AirbrakeGroup *)errorGroup {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _errorGroup = errorGroup;
        _isLoading = YES;
        self.title = @"Error Group";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerView];
    
    CGRect header = CGRectNull;
    CGRect remainder = CGRectNull;
    CGRectDivide(self.view.bounds, &header, &remainder, CGRectGetHeight(self.headerView.frame), CGRectMinYEdge);
    self.tableView.frame = remainder;
    
    [BDKNoticeCell registerForTableView:self.tableView];
    [self.tableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSMutableArray *)notices {
    if (_notices != nil) return _notices;
    _notices = [NSMutableArray array];
    return _notices;
}

- (UIView *)headerView {
    if (_headerView != nil) return _headerView;
    CGRect frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 100.0f);
    _headerView = [[UIView alloc] initWithFrame:frame];
    _headerView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    UILabel *label = [[UILabel alloc] initWithFrame:self.headerView.frame];
    label.text = self.errorGroup.errorClass;
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.backgroundColor = [UIColor clearColor];
    
    [label sizeToFit];
    label.frame = CGRectOffset(CGRectIntegral(label.frame), 10.0f, 10.0f);
    
    UILabel *sublabel = [[UILabel alloc] initWithFrame:self.headerView.frame];
    sublabel.text = self.errorGroup.errorMessage;
    sublabel.font = [UIFont systemFontOfSize:12.0f];
    sublabel.numberOfLines = 0;
    sublabel.lineBreakMode = NSLineBreakByWordWrapping;
    sublabel.backgroundColor = [UIColor clearColor];
    CGSize size = [sublabel.text sizeWithFont:sublabel.font
                            constrainedToSize:CGSizeMake(_headerView.frame.size.width - 20.0f, _headerView.frame.size.height)
                                lineBreakMode:sublabel.lineBreakMode];
    sublabel.frame = CGRectIntegral((CGRect){ { CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) + 5.0f }, size });
    
    [_headerView addSubview:label];
    [_headerView addSubview:sublabel];
    _headerView.frame = (CGRect){ _headerView.frame.origin, { _headerView.frame.size.width, CGRectGetMaxY(sublabel.frame) + 10.0f } };
    return _headerView;
}

#pragma mark - Methods

- (void)refreshViewWithRefreshControl:(SVPullToRefreshView *)pullToRefreshView {
    [super refreshViewWithRefreshControl:pullToRefreshView];
    [self loadNotices];
}

- (void)loadNotices {
    ArrayBlock completionBlock = ^(NSArray *notices) {
        [self.notices addObjectsFromArray:notices];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.isLoading = NO;
        [self.tableView reloadData];
        [self timestampRefreshControl];
    };
    
    FailBlock failBlock = ^(NSError *error, NSUInteger responseCode) {
        self.isLoading = NO;
        DDLogData(@"Error! Code: %i. Message: %@.", responseCode, error.localizedDescription);
    };
    self.isLoading = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.apiClient noticesForGroup:self.errorGroup.identifier success:completionBlock failure:failBlock];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.isLoading ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.isLoading) return 1;
    return (section == 0) ? 10 : self.notices.count;
}

- (BDKNoticeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BDKNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIDNotice forIndexPath:indexPath];
    cell.notice = [self airbrakeNoticeForIndexPath:indexPath];
    return cell;
}

- (AirbrakeNotice *)airbrakeNoticeForIndexPath:(NSIndexPath *)indexPath {
    return self.isLoading ? nil : [self.notices objectAtIndex:indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AirbrakeNotice *notice = [self airbrakeNoticeForIndexPath:indexPath];
    BDKNoticeViewController *vc = [BDKNoticeViewController controllerWithNotice:notice];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
