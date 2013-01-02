#import "AirbrakeModel.h"

@implementation AirbrakeModel

+ (id)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        [[dictionary allKeys] each:^(NSString *key) {
            [self setValue:[dictionary objectForKey:key] forKeyPath:key];
        }];
    }
    
    return self;
}

@end
