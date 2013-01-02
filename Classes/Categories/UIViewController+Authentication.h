#import <UIKit/UIKit.h>
#import "BDKAirbrakeLoginController.h"

@interface UIViewController (Authentication)

- (void)checkForAuthenticationWithDelegate:(id<BDKAirbrakeLoginControllerDelegate>)delegate;
- (NSString *)accountName;
- (NSString *)apiToken;
- (BOOL)isLoggedIn;
- (void)controller:(BDKAirbrakeLoginController *)controller didLoginWithData:(NSDictionary *)data;

@end
