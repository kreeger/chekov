#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AFNetworking/AFNetworking.h>

#import "AirbrakeGroup.h"
#import "AirbrakeProject.h"
#import "AirbrakeNotice.h"

typedef void (^FailBlock)(NSError *error, NSUInteger responseCode);
typedef void (^ArrayBlock)(NSArray *results);
typedef void (^DictionaryBlock)(NSDictionary *result);

@interface AirbrakeAPIClient : AFHTTPClient

@property (strong, nonatomic) NSString *accountName;
@property (strong, nonatomic) NSString *apiToken;

- (id)initWithAccountName:(NSString *)accountName apiToken:(NSString *)apiToken;

- (void)recentGroups:(ArrayBlock)success failure:(FailBlock)failure;

- (void)recentGroupsForPage:(NSNumber *)page completion:(ArrayBlock)success failure:(FailBlock)failure;

- (void)projects:(ArrayBlock)success failure:(FailBlock)failure;

- (void)groupsForProject:(NSNumber *)project success:(ArrayBlock)success failure:(FailBlock)failure;

- (void)noticesForGroup:(NSNumber *)group success:(ArrayBlock)success failure:(FailBlock)failure;

- (void)notice:(NSNumber *)notice forGroup:(NSNumber *)group success:(DictionaryBlock)success failure:(FailBlock)failure;

@end
