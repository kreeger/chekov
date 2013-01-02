#import "AirbrakeModel.h"

@interface AirbrakeGroup : AirbrakeModel

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *errorClass;
@property (strong, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSNumber *projectId;
@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSString *controller;
@property (strong, nonatomic) NSString *file;
@property (strong, nonatomic) NSNumber *lineNumber;
@property (strong, nonatomic) NSNumber *resolved;
@property (readonly) BOOL resolvedValue;
@property (strong, nonatomic) NSString *railsEnv;
@property (strong, nonatomic) NSDate *mostRecentNoticeAt;
@property (strong, nonatomic) NSNumber *noticesCount;
@property (strong, nonatomic) NSString *noticeHash;
@property (strong, nonatomic) NSNumber *lighthouseTicketId;
@property (strong, nonatomic) NSNumber *searchIndexMe;
@property (readonly) BOOL searchIndexMeValue;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

@property (strong, nonatomic) NSDictionary *environment;
@property (strong, nonatomic) NSDictionary *session;
@property (strong, nonatomic) NSDictionary *request;
@property (strong, nonatomic) NSArray *backtraceLines;

@property (readonly) NSString *location;

@end