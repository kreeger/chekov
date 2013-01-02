#import <Foundation/Foundation.h>
#import "TBXML.h"

#import "AirbrakeGroup.h"
#import "AirbrakeProject.h"
#import "AirbrakeNotice.h"

@interface AirbrakeAPIParser : NSObject

+ (id)parser;

- (NSDictionary *)parseErrorGroups:(NSData *)data;
- (AirbrakeGroup *)parseErrorGroup:(NSData *)data;
- (NSDictionary *)parseProjects:(NSData *)data;
- (AirbrakeProject *)parseProject:(NSData *)data;
- (NSDictionary *)parseNotices:(NSData *)data;
- (AirbrakeNotice *)parseNotice:(NSData *)data;

@end
