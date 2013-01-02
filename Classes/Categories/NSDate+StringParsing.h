#import <Foundation/Foundation.h>

@interface NSDate (StringParsing)

+ (NSDate *)dateWithISO8601String:(NSString *)dateString;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat;

@end
