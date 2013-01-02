#import "BDKErrorGroupListController.h"
#import "BDKErrorGroupViewController.h"
#import "BDKErrorGroupCell.h"
#import "AirbrakeAPIClient.h"

#import "UIViewController+Airbrake.h"
#import "UITableViewCell+Awesome.h"

@interface BDKErrorGroupListController ()

@property (strong, nonatomic) NSMutableArray *groups;
@property (nonatomic) BOOL isLoading;

- (void)loadGroups;
- (void)authenticationModalClosedWithData:(NSDictionary *)data;
- (AirbrakeGroup *)airbrakeGroupForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BDKErrorGroupListController

+ (id)controller {
    return [[self alloc] init];
}

+ (id)controllerWithProject:(AirbrakeProject *)project {
    return [[self alloc] initWithProject:project];
}

- (id)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
    }
    return self;
}

- (id)initWithProject:(AirbrakeProject *)project {
    if ((self = [self init])) {
        _project = project;
        _isLoading = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [BDKErrorGroupCell registerForTableView:self.tableView];
    [self assumeNavigationStyle];
    if (self.isLoggedIn) [self.tableView triggerPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkForAuthenticationWithDelegate:self];
    
    if (self.isLoggedIn) [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSMutableArray *)groups {
    if (_groups != nil) return _groups;
    _groups = [NSMutableArray array];
    return _groups;
}

#pragma mark - Methods

- (void)refreshViewWithRefreshControl:(SVPullToRefreshView *)pullToRefreshView {
    [super refreshViewWithRefreshControl:pullToRefreshView];
    [self loadGroups];
}

- (void)loadGroups {
    ArrayBlock completionBlock = ^(NSArray *groups) {
        [self.groups addObjectsFromArray:groups];
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
    if (self.project) {
        [self.apiClient recentGroups:completionBlock failure:failBlock];
        [self.apiClient groupsForProject:self.project.identifier success:completionBlock failure:failBlock];
    } else {
        [self.apiClient recentGroups:completionBlock failure:failBlock];
    }
}

- (void)authenticationModalClosedWithData:(NSDictionary *)data {
    [self resetApiClient];
    [self loadGroups];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return 1;
    return self.isLoading ? 1 : self.groups.count;
}

- (BDKErrorGroupCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BDKErrorGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIDErrorGroup forIndexPath:indexPath];
    cell.group = [self airbrakeGroupForIndexPath:indexPath];
    return cell;
}

- (AirbrakeGroup *)airbrakeGroupForIndexPath:(NSIndexPath *)indexPath {
    return self.groups.count == 0 ? nil : [self.groups objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AirbrakeGroup *group = [self airbrakeGroupForIndexPath:indexPath];
    CGSize size = [group.errorMessage sizeWithFont:[UIFont systemFontOfSize:12]
                                 constrainedToSize:CGSizeMake(kCellErrorGroupLabelWidth, 1000.0f)
                                     lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + (group.location ? 54.0f : 42.0f);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AirbrakeGroup *group = [self airbrakeGroupForIndexPath:indexPath];
    BDKErrorGroupViewController *view = [BDKErrorGroupViewController controllerWithErrorGroup:group];
    view.title = group.errorClass;
    [self.navigationController pushViewController:view animated:YES];
}

@end
