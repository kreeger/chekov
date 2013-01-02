#import "BDKAppDelegate.h"
#import "BDKErrorGroupListController.h"
#import "BDKProjectListController.h"

#import "AirbrakeAPIClient.h"

#import <EDColor/UIColor+Crayola.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#import "BDKLogFormatter.h"

@implementation BDKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self configureLogging];
    
    self.window.rootViewController = self.viewDeckController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (AirbrakeAPIClient *)apiClient {
    if (_apiClient != nil) return _apiClient;
    _apiClient = [[AirbrakeAPIClient alloc] initWithAccountName:[[NSUserDefaults standardUserDefaults] valueForKey:@"account"]
                                                       apiToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"token"]];
    return _apiClient;
}

- (void)configureLogging {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDTTYLogger sharedInstance].colorsEnabled = YES;
    [DDTTYLogger sharedInstance].logFormatter = [BDKLogFormatter formatter];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithCrayola:@"Cornflower"]
                                     backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithCrayola:@"Screamin' Green"]
                                     backgroundColor:nil forFlag:LOG_FLAG_API];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithCrayola:@"Canary"]
                                     backgroundColor:nil forFlag:LOG_FLAG_UI];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithCrayola:@"Tumbleweed"]
                                     backgroundColor:nil forFlag:LOG_FLAG_DATA];
    
}

- (IIViewDeckController *)viewDeckController {
    if (_viewDeckController != nil) return _viewDeckController;
    
    // Override point for customization after application launch.
    BDKErrorGroupListController *recent = [BDKErrorGroupListController controller];
    recent.title = @"Recent";
    UINavigationController *recentNav = [[UINavigationController alloc] initWithRootViewController:recent];
    
    // BDKProjectListController *projects = [[BDKProjectListController alloc] init];
    // projects.title = @"Projects";
    // UINavigationController *projectsNav = [[UINavigationController alloc] initWithRootViewController:projects];
    
    _viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:recentNav];
    return _viewDeckController;
}

@end
