#import "BDKNoticeViewController.h"
#import "UIViewController+Airbrake.h"
#import "UITableViewCell+Awesome.h"

#import "AirbrakeAPIClient.h"

@interface BDKNoticeViewController ()

- (id)initWithNotice:(AirbrakeNotice *)notice;
- (void)loadNotice;

@end

@implementation BDKNoticeViewController

+ (id)controllerWithNotice:(AirbrakeNotice *)notice {
    return [[self alloc] initWithNotice:notice];
}

- (id)initWithNotice:(AirbrakeNotice *)notice {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _notice = notice;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITableViewCell registerForTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods

- (void)refreshViewWithRefreshControl:(SVPullToRefreshView *)pullToRefreshView {
    [super refreshViewWithRefreshControl:pullToRefreshView];
    [self loadNotice];
}

- (void)loadNotice {
    NoticeBlock successBlock = ^(AirbrakeNotice *notice) {
        _notice = notice;
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
    [self.apiClient notice:self.notice.identifier forGroup:self.notice.groupId success:successBlock failure:failBlock];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.isLoading ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.isLoading) return 1;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellId forIndexPath:indexPath];
    cell.textLabel.text = self.notice.errorMessage;
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
