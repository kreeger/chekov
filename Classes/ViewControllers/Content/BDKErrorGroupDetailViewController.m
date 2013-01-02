#import "BDKErrorGroupDetailViewController.h"
#import "UIViewController+Authentication.h"
#import "AirbrakeAPIClient.h"
#import "BDKNoticeCell.h"

@interface BDKErrorGroupDetailViewController ()

@property (strong, nonatomic) NSMutableArray *notices;
@property (nonatomic) BOOL isLoading;

- (void)loadNotices;
- (AirbrakeNotice *)airbrakeNoticeForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BDKErrorGroupDetailViewController

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
    [BDKNoticeCell registerForTableView:self.tableView];
    [self.tableView triggerPullToRefresh];
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
    [self.apiClient notice:notice.identifier forGroup:notice.groupId success:^(NSDictionary *result) {
        DDLogData(@"%@", result);
    } failure:^(NSError *error, NSUInteger responseCode) {
        DDLogError(@"Encountered error %i.", responseCode);
        // Fail
    }];
}

@end
