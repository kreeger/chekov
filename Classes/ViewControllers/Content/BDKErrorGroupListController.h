#import "BDKBaseTableViewController.h"
#import "UIViewController+Authentication.h"

@class AirbrakeProject;

@interface BDKErrorGroupListController : BDKBaseTableViewController <BDKAirbrakeLoginControllerDelegate>

@property (strong, nonatomic) AirbrakeProject *project;

+ (id)controller;
+ (id)controllerWithProject:(AirbrakeProject *)project;
- (id)initWithProject:(AirbrakeProject *)project;

@end
