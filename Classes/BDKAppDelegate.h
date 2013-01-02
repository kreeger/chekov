#import <UIKit/UIKit.h>

@class AirbrakeAPIClient;

@interface BDKAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IIViewDeckController *viewDeckController;
@property (strong, nonatomic) AirbrakeAPIClient *apiClient;

- (void)configureLogging;

@end
