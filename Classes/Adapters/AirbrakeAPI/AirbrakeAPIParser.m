#import "AirbrakeAPIParser.h"
#import "NSDate+StringParsing.h"

typedef AirbrakeModel *(^ElementParseBlock)(TBXMLElement *element);

@interface AirbrakeAPIParser ()

- (NSDictionary *)handleArrayData:(NSData *)data
              forChildElementName:(NSString *)childElementName
                       pluralName:(NSString *)pluralName
                        parseWith:(ElementParseBlock)parseBlock;
- (TBXMLElement *)getRootElementFromData:(NSData *)data;

- (NSDictionary *)parseErrorGroupElement:(TBXMLElement *)group;
- (NSDictionary *)parseProjectElement:(TBXMLElement *)project;
- (NSDictionary *)parseNoticeElement:(TBXMLElement *)notice;

@end

@implementation AirbrakeAPIParser

+ (id)parser {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    return self;
}

#pragma mark - List processing

- (NSDictionary *)parseErrorGroups:(NSData *)data {
    return [self handleArrayData:data forChildElementName:@"group" pluralName:@"groups"
                       parseWith:^AirbrakeModel *(TBXMLElement *element) {
                           NSDictionary *dict = [self parseErrorGroupElement:element];
                           return [AirbrakeGroup modelWithDictionary:dict];
                       }];
}

- (AirbrakeGroup *)parseErrorGroup:(NSData *)data {
    TBXMLElement *element = [self getRootElementFromData:data];
    NSDictionary *dict = [self parseErrorGroupElement:element];
    return [AirbrakeGroup modelWithDictionary:dict];
}

- (NSDictionary *)parseProjects:(NSData *)data {
    return [self handleArrayData:data forChildElementName:@"project" pluralName:@"projects"
                       parseWith:^AirbrakeModel *(TBXMLElement *element) {
                           NSDictionary *dict = [self parseProjectElement:element];
                           return [AirbrakeProject modelWithDictionary:dict];
                       }];
}

- (AirbrakeProject *)parseProject:(NSData *)data {
    TBXMLElement *element = [self getRootElementFromData:data];
    NSDictionary *dict = [self parseProjectElement:element];
    return [AirbrakeProject modelWithDictionary:dict];
}

- (NSDictionary *)parseNotices:(NSData *)data {
    return [self handleArrayData:data forChildElementName:@"notice" pluralName:@"notices"
                       parseWith:^AirbrakeModel *(TBXMLElement *element) {
                           NSDictionary *dict = [self parseNoticeElement:element];
                           return [AirbrakeNotice modelWithDictionary:dict];
                       }];
}

- (AirbrakeNotice *)parseNotice:(NSData *)data {
    TBXMLElement *element = [self getRootElementFromData:data];
    NSDictionary *dict = [self parseErrorGroupElement:element];
    return [AirbrakeNotice modelWithDictionary:dict];
}

- (NSDictionary *)handleArrayData:(NSData *)data
              forChildElementName:(NSString *)childElementName
                       pluralName:(NSString *)pluralName
                        parseWith:(ElementParseBlock)parseBlock {
    TBXMLElement *thing = [TBXML childElementNamed:childElementName
                                     parentElement:[self getRootElementFromData:data]];
    NSMutableArray *things = [NSMutableArray array];
    
    do {
        AirbrakeModel *model = parseBlock(thing);
        [things addObject:model];
    } while ((thing = thing->nextSibling));
    
    return @{pluralName: things};
}

- (TBXMLElement *)getRootElementFromData:(NSData *)data {
    NSError *error = nil;
    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:&error];
    return tbxml.rootXMLElement;
}

#pragma mark - Object processing

- (NSDictionary *)parseErrorGroupElement:(TBXMLElement *)group {
    return (@{
            @"identifier": [self parseElementNamed:@"id" inElement:group],
            @"projectId": [self parseElementNamed:@"project-id" inElement:group],
            @"errorClass": [self parseElementNamed:@"error-class" inElement:group],
            @"errorMessage": [self parseElementNamed:@"error-message" inElement:group],
            @"action": [self parseElementNamed:@"action" inElement:group],
            @"controller": [self parseElementNamed:@"controller" inElement:group],
            @"file": [self parseElementNamed:@"file" inElement:group],
            @"lineNumber": [self parseElementNamed:@"line-number" inElement:group],
            @"resolved": [self parseElementNamed:@"resolved" inElement:group],
            @"railsEnv": [self parseElementNamed:@"rails-env" inElement:group],
            @"mostRecentNoticeAt": [self parseElementNamed:@"most-recent-notice-at" inElement:group],
            @"noticesCount": [self parseElementNamed:@"notices-count" inElement:group],
            @"noticeHash": [self parseElementNamed:@"notice-hash" inElement:group],
            @"lighthouseTicketId": [self parseElementNamed:@"lighthouse-ticket-id" inElement:group],
            @"searchIndexMe": [self parseElementNamed:@"search-index-me" inElement:group],
            @"createdAt": [self parseElementNamed:@"created-at" inElement:group],
            @"updatedAt": [self parseElementNamed:@"updated-at" inElement:group],
            });
}

- (NSDictionary *)parseProjectElement:(TBXMLElement *)project {
    return (@{
            @"identifier": [self parseElementNamed:@"id" inElement:project],
            @"name": [self parseElementNamed:@"name" inElement:project],
            @"apiKey": [self parseElementNamed:@"api-key" inElement:project],
            });
}

- (NSDictionary *)parseNoticeElement:(TBXMLElement *)notice {
    return (@{
            @"identifier": [self parseElementNamed:@"id" inElement:notice],
            @"projectId": [self parseElementNamed:@"project-id" inElement:notice],
            @"groupId": [self parseElementNamed:@"group-id" inElement:notice],
            @"errorMessage": [self parseElementNamed:@"error-message" inElement:notice],
            @"uuid": [self parseElementNamed:@"uuid" inElement:notice],
            @"createdAt": [self parseElementNamed:@"created-at" inElement:notice],
            //@"updatedAt": [self parseElementNamed:@"updated-at" inElement:notice],
            });
}

#pragma mark - Element processing

- (id)parseElementNamed:(NSString *)name inElement:(TBXMLElement *)xmlElement {
    TBXMLElement *element = [TBXML childElementNamed:name parentElement:xmlElement];
    BOOL isNil = [[TBXML valueOfAttributeNamed:@"nil" forElement:element] isEqualToString:@"true"];
    if (isNil) return [NSNull null];
    
    NSString *type = [TBXML valueOfAttributeNamed:@"type" forElement:element];
    if ([type isEqualToString:@"integer"]) {
        NSString *elementString = [TBXML textForElement:element];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        return [formatter numberFromString:elementString];
    } else if ([type isEqualToString:@"datetime"]) {
        return [NSDate dateWithISO8601String:[TBXML textForElement:element]];
    } else if ([type isEqualToString:@"boolean"]) {
        return [NSNumber numberWithBool:([[TBXML textForElement:element] isEqualToString:@"true"])];
    }
    
    return [TBXML textForElement:element];
}

@end
