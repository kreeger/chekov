#import "AirbrakeModel.h"

@interface AirbrakeNotice : AirbrakeModel

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSNumber *groupId;
@property (strong, nonatomic) NSNumber *projectId;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

@end
