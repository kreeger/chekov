#import <UIKit/UIKit.h>

#import "AirbrakeAPIClient.h"

@interface UIViewController (Airbrake)

- (void)assumeNavigationStyle;
- (AirbrakeAPIClient *)apiClient;
- (void)resetApiClient;

@end
