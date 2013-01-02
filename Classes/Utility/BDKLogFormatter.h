#import <Foundation/Foundation.h>

@interface BDKLogFormatter : NSObject <DDLogFormatter>

@property (nonatomic) int atomicLoggerCount;
@property (strong, nonatomic) NSDateFormatter *threadUnsafeDateFormatter;

+ (id)formatter;

@end
