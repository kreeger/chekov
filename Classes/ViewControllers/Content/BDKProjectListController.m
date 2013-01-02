#import "BDKProjectListController.h"
#import "BDKErrorGroupListController.h"
#import "AirbrakeAPIClient.h"

#import "UIViewController+Airbrake.h"
#import "UITableViewCell+Awesome.h"

@interface BDKProjectListController ()

@property (strong, nonatomic) NSMutableArray *projects;
@property (nonatomic) BOOL isLoading;

- (void)loadProjects;

@end

@implementation BDKProjectListController

+ (id)controller {
    return [[self alloc] init];
}

- (id)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _isLoading = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITableViewCell registerForTableView:self.tableView];
    [self assumeNavigationStyle];
    if (self.isLoggedIn) [self.tableView triggerPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isLoggedIn) [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (NSMutableArray *)projects {
    if (_projects != nil) return _projects;
    _projects = [NSMutableArray array];
    return _projects;
}

#pragma mark - Methods

- (void)refreshViewWithRefreshControl:(SVPullToRefreshView *)pullToRefreshView {
    [super refreshViewWithRefreshControl:pullToRefreshView];
    [self loadProjects];
}

- (void)loadProjects {
    ArrayBlock completionBlock = ^(NSArray *projects) {
        [self.projects addObjectsFromArray:projects];
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
    [self.apiClient projects:completionBlock failure:failBlock];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isLoading ? 1 : self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultCellId forIndexPath:indexPath];
    AirbrakeProject *project = [self airbrakeProjectForIndexPath:indexPath];
    if (project) {
        cell.textLabel.text = project.name;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

- (AirbrakeProject *)airbrakeProjectForIndexPath:(NSIndexPath *)indexPath {
    return self.projects.count == 0 ? nil : [self.projects objectAtIndex:indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AirbrakeProject *project = [self airbrakeProjectForIndexPath:indexPath];
    BDKErrorGroupListController *errors = [BDKErrorGroupListController controllerWithProject:project];
    errors.title = project.name;
    [self.navigationController pushViewController:errors animated:YES];
}

@end
