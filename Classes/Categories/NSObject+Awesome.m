#import "NSObject+Awesome.h"

@implementation NSObject (Awesome)

- (BOOL)isNull {
    return (NSNull *)self == [NSNull null];
}

- (BOOL)isBlank {
    return [(NSString *)self isEqualToString:@""];
}

- (BOOL)isEmpty {
    return [(NSArray *)self count] == 0;
}

- (BOOL)isNullish {
    return [self isNull] || [self isBlank] || [self isEmpty];
}

@end
