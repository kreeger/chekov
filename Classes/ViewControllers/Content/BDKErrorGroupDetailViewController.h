#import "BDKBaseTableViewController.h"

@interface BDKErrorGroupDetailViewController : BDKBaseTableViewController

@property (strong, nonatomic) AirbrakeGroup *errorGroup;

- (id)initWithErrorGroup:(AirbrakeGroup *)errorGroup;

@end
