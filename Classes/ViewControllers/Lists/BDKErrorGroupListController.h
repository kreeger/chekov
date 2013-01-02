#import "BDKBaseTableViewController.h"
#import "UIViewController+Authentication.h"

@interface BDKErrorGroupListController : BDKBaseTableViewController <BDKAirbrakeLoginControllerDelegate>

@property (strong, nonatomic) AirbrakeProject *project;

- (id)initWithProject:(AirbrakeProject *)project;

@end
