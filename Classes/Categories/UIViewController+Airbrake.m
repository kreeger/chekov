#import "UIViewController+Airbrake.h"
#import "BDKAppDelegate.h"

#import <EDColor/UIColor+Hex.h>

@implementation UIViewController (Airbrake)

- (void)assumeNavigationStyle {
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:kColorDarkGray];
}

- (AirbrakeAPIClient *)apiClient {
    return ((BDKAppDelegate *)[UIApplication sharedApplication].delegate).apiClient; 
}

- (void)resetApiClient {
    BDKAppDelegate *delegate = (BDKAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.apiClient = nil;
}

@end
