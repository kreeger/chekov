#import "BDKBaseTableViewController.h"

@class AirbrakeGroup;

@interface BDKErrorGroupViewController : BDKBaseTableViewController

@property (strong, nonatomic) AirbrakeGroup *errorGroup;

+ (id)controllerWithErrorGroup:(AirbrakeGroup *)errorGroup;
- (id)initWithErrorGroup:(AirbrakeGroup *)errorGroup;

@end
