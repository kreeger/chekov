#import "AirbrakeAPIClient.h"
#import "AirbrakeAPIParser.h"

#define kAccountName @"universaluclick"

@interface AirbrakeAPIClient ()

@property (strong, nonatomic) NSDictionary *params;

- (NSString *)buildRequestStringForSegments:(NSArray *)segments;
- (NSDictionary *)buildParams;
- (NSDictionary *)buildParamsForParams:(NSDictionary *)params;

@end

@implementation AirbrakeAPIClient

#pragma mark - Lifecycle

- (id)initWithAccountName:(NSString *)accountName apiToken:(NSString *)apiToken {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.airbrake.io", accountName]];
    if (self = [super initWithBaseURL:url]) {
        _accountName = accountName;
        _apiToken = apiToken;
        [self setDefaultHeader:@"Accept" value:@"application/xml"];
        [self setDefaultHeader:@"Accept-Language" value:@"en-us"];
    }
    return self;
}

#pragma mark - Properties

- (NSDictionary *)params {
    if (_params != nil) return _params;
    return @{@"auth_token": self.apiToken};
}

#pragma mark - Helpers

- (NSString *)buildRequestStringForSegments:(NSArray *)segments {
    NSString *segmentString = [segments componentsJoinedByString:@"/"];
    DDLogAPI(@"Calling URL at %@/%@.", self.baseURL, segmentString);
    return segmentString;
}

- (NSDictionary *)buildParams {
    return [self buildParamsForParams:@{}];
}

- (NSDictionary *)buildParamsForParams:(NSDictionary *)params {
    NSMutableDictionary *dict = [self.params mutableCopy];
    [dict addEntriesFromDictionary:params];
    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark - Reading

- (void)recentGroups:(ArrayBlock)success failure:(FailBlock)failure {
    NSString *path = [self buildRequestStringForSegments:@[@"groups.xml"]];
    NSDictionary *params = [self buildParams];
    [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AirbrakeAPIParser *parser = [AirbrakeAPIParser parser];
        NSDictionary *result = [parser parseErrorGroups:responseObject];
        success(result[@"groups"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, operation.response.statusCode);
    }];
}

- (void)recentGroupsForPage:(NSNumber *)page completion:(ArrayBlock)success failure:(FailBlock)failure {
    NSString *path = [self buildRequestStringForSegments:@[@"groups.xml"]];
    NSDictionary *params = [self buildParamsForParams:@{@"page": page}];
    [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AirbrakeAPIParser *parser = [AirbrakeAPIParser parser];
        NSDictionary *result = [parser parseErrorGroups:responseObject];
        success(result[@"groups"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, operation.response.statusCode);
    }];
}

- (void)projects:(ArrayBlock)success failure:(FailBlock)failure {
    NSString *path = [self buildRequestStringForSegments:@[@"projects.xml"]];
    NSDictionary *params = [self buildParams];
    [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AirbrakeAPIParser *parser = [AirbrakeAPIParser parser];
        NSDictionary *result = [parser parseProjects:responseObject];
        success(result[@"projects"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, operation.response.statusCode);
    }];
}

- (void)groupsForProject:(NSNumber *)project success:(ArrayBlock)success failure:(FailBlock)failure {
    NSString *path = [self buildRequestStringForSegments:@[@"projects", project.description, @"groups.xml"]];
    NSDictionary *params = [self buildParams];
    [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AirbrakeAPIParser *parser = [AirbrakeAPIParser parser];
        NSDictionary *result = [parser parseErrorGroups:responseObject];
        success(result[@"groups"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, operation.response.statusCode);
    }];
}

- (void)noticesForGroup:(NSNumber *)group success:(ArrayBlock)success failure:(FailBlock)failure {
    NSString *path = [self buildRequestStringForSegments:@[@"groups", group.description, @"notices.xml"]];
    NSDictionary *params = [self buildParams];
    [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AirbrakeAPIParser *parser = [AirbrakeAPIParser parser];
        NSDictionary *result = [parser parseNotices:responseObject];
        success(result[@"notices"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, operation.response.statusCode);
    }];
}

- (void)notice:(NSNumber *)notice forGroup:(NSNumber *)group success:(NoticeBlock)success failure:(FailBlock)failure {
    NSString *path = [self buildRequestStringForSegments:@[@"groups", group.description, @"notices", [NSString stringWithFormat:@"%@.xml", notice]]];
    NSDictionary *params = [self buildParams];
    [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AirbrakeAPIParser *parser = [AirbrakeAPIParser parser];
        AirbrakeNotice *result = [parser parseNotice:responseObject];
        success(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, operation.response.statusCode);
    }];
}

@end
