#import "UINavigationController+Awesome.h"

@implementation UINavigationController (Awesome)

+ (id)controllerWithRootViewController:(UIViewController *)viewController {
    return [[self alloc] initWithRootViewController:viewController];
}

@end
