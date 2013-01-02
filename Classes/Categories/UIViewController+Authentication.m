#import "UIViewController+Authentication.h"

#define kSettingAccountKey @"account"
#define kSettingTokenKey   @"token"

@implementation UIViewController (Authentication)

- (void)checkForAuthenticationWithDelegate:(id<BDKAirbrakeLoginControllerDelegate>)delegate {
    if (!self.isLoggedIn) {
        BDKAirbrakeLoginController *login = [[BDKAirbrakeLoginController alloc] initWithDelegate:delegate];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        DDLogData(@"Logged in with creds: %@ / %@.", self.accountName, self.apiToken);
    }
}

- (NSString *)accountName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSettingAccountKey];
}

- (NSString *)apiToken {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSettingTokenKey];
}

- (BOOL)isLoggedIn {
    return (!(self.accountName == nil || [self.accountName isEmpty] || self.apiToken == nil || [self.apiToken isEmpty]));
}

- (void)controller:(BDKAirbrakeLoginController *)controller didLoginWithData:(NSDictionary *)data {
    [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:kSettingAccountKey] forKey:kSettingAccountKey];
    [[NSUserDefaults standardUserDefaults] setValue:[data objectForKey:kSettingTokenKey] forKey:kSettingTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    __block UIViewController *unretainedSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([unretainedSelf respondsToSelector:@selector(authenticationModalClosedWithData:)])
            [unretainedSelf performSelector:@selector(authenticationModalClosedWithData:) withObject:data];
    }];
}

@end
