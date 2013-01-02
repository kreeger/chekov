#import "BDKAirbrakeLoginController.h"

enum ROWS {
    ACCOUNT_ROW = 0,
    TOKEN_ROW,
    NUMBER_OF_ROWS,
};

@interface BDKAirbrakeLoginController ()

@property (strong, nonatomic) UIBarButtonItem *loginButton;
@property (strong, nonatomic) UITextField *accountField;
@property (strong, nonatomic) UITextField *apiTokenField;

- (void)loginButtonTapped:(id)sender;

@end

@implementation BDKAirbrakeLoginController

- (id)initWithDelegate:(id<BDKAirbrakeLoginControllerDelegate>)delegate {
    if ((self = [self initWithStyle:UITableViewStyleGrouped])) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self assumeNavigationStyle];
    self.title = @"Login";
    self.navigationItem.rightBarButtonItem = self.loginButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (UIBarButtonItem *)loginButton {
    if (_loginButton != nil) return _loginButton;
    _loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self
                                                   action:@selector(loginButtonTapped:)];
    return _loginButton;
}

- (UITextField *)accountField {
    if (_accountField != nil) return _accountField;
    _accountField = [[UITextField alloc] initWithFrame:CGRectZero];
    _accountField.placeholder = @"Account name";
    _accountField.font = [UIFont systemFontOfSize:16];
    _accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _accountField.autocorrectionType = UITextAutocorrectionTypeNo;
    return _accountField;
}

- (UITextField *)apiTokenField {
    if (_apiTokenField != nil) return _apiTokenField;
    _apiTokenField = [[UITextField alloc] initWithFrame:CGRectZero];
    _apiTokenField.placeholder = @"Airbrake user API token";
    _apiTokenField.font = [UIFont systemFontOfSize:16];
    _apiTokenField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _apiTokenField.autocorrectionType = UITextAutocorrectionTypeNo;
    return _apiTokenField;
}

#pragma mark - Events

- (void)loginButtonTapped:(id)sender {
    if (self.accountField.text == nil || self.apiTokenField.text == nil) return;
    if ([self.accountField.text isEmpty] || [self.apiTokenField.text isEmpty]) return;
    
    [self.delegate controller:self didLoginWithData:(@{@"account": self.accountField.text,
                                                     @"token": self.apiTokenField.text})];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    
    switch (indexPath.row) {
        case ACCOUNT_ROW:
            self.accountField.frame = CGRectOffset(cell.contentView.frame, 12, 12);;
            [cell.contentView addSubview:self.accountField];
            break;
        case TOKEN_ROW:
            self.apiTokenField.frame = CGRectOffset(cell.contentView.frame, 12, 12);;
            [cell.contentView addSubview:self.apiTokenField];
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
