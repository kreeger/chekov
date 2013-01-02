#import <UIKit/UIKit.h>

@protocol BDKAirbrakeLoginControllerDelegate;

@interface BDKAirbrakeLoginController : UITableViewController

@property (weak, nonatomic) id<BDKAirbrakeLoginControllerDelegate> delegate;

- (id)initWithDelegate:(id<BDKAirbrakeLoginControllerDelegate>)delegate;

@end

@protocol BDKAirbrakeLoginControllerDelegate <NSObject>

- (void)controller:(BDKAirbrakeLoginController *)controller didLoginWithData:(NSDictionary *)data;

@end