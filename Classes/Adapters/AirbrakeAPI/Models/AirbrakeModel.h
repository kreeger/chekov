#import <Foundation/Foundation.h>

@interface AirbrakeModel : NSObject

+ (id)modelWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
