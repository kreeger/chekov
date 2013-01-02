#import "AirbrakeGroup.h"

@implementation AirbrakeGroup

- (BOOL)resolvedValue {
    return [self.resolved boolValue];
}

- (BOOL)searchIndexMeValue {
    return [self.searchIndexMe boolValue];
}

- (NSString *)location {
    if (![self.controller isNullish] && ![self.action isNullish]) {
        return [@[self.controller, self.action] componentsJoinedByString:@"#"];
    } else return nil;
}

@end
