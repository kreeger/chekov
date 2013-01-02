#import "BDKBaseTableViewController.h"

@class AirbrakeNotice;

@interface BDKNoticeViewController : BDKBaseTableViewController

@property (strong, nonatomic) AirbrakeNotice *notice;
@property (nonatomic) BOOL isLoading;

+ (id)controllerWithNotice:(AirbrakeNotice *)notice;

@end
