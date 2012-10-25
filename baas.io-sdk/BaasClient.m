//
// Created by cetauri on 12. 10. 25..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BaasClient.h"
#import "UGClient.h"
#import "UGHTTPManager.h"
#import "JSONKit.h"

@implementation BaasClient {
    UGClient *_client;

}
static NSString * _apiURL;
static NSString * _applicationName;
static NSString * _orgName;

+ (void)setApplicationInfo:(NSString *)orgName applicationName:(NSString *)applicationName{
    _apiURL = @"https://stgapi.baas.io";
    _applicationName = applicationName;
    _orgName = orgName;
}

+ (void)setApplicationInfo:(NSString *)apiURL organizationName:(NSString *)orgName applicationName:(NSString *)applicationName{
    _apiURL = apiURL;
    [BaasClient setApplicationInfo:orgName applicationName:applicationName];
}

//static BaasClient *instance = nil;
+ (id) createInstance{
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", _apiURL, _applicationName, _orgName];
    BaasClient *baasIO = [[BaasClient alloc] initWithApplicationID:path withBaseURL:_apiURL];
    return baasIO;
}

-(id)initWithApplicationID:(NSString *)applicationID withBaseURL:(NSString*)baseURL
{
    if (self = [super init])
    {
        _client = [[UGClient alloc] initWithApplicationID:applicationID baseURL:baseURL];
    }
    return self;
}

-(BOOL) setDelegate:(id)delegate{
    return [_client setDelegate:delegate];
}

-(void) setAuth:(NSString *)auth{
    return [_client setAuth:auth];
}

/*************************** LOGIN / LOGOUT ****************************/

-(BaasIOResponse *)logInUser: (NSString *)userName password:(NSString *)password
{
    return (BaasIOResponse*)[_client logInUser:userName password:password];
}

//-(BaasIOResponse *)logInUserWithPin: (NSString *)userName pin:(NSString *)pin
//{
//    return [_client logInUserWithPin:userName pin:pin];
//}

//-(BaasIOResponse *)logInAdmin: (NSString *)adminUserName secret:(NSString *)adminSecret
//{
//    return [_client logInAdmin:adminUserName secret:adminSecret];
//}

-(void)logOut
{
    // clear out auth
    [_client setAuth: nil];
}

/*************************** USER MANAGEMENT ***************************/
-(BaasIOResponse *)addUser:(NSString *)username email:(NSString *)email name:(NSString *)name password:(NSString *)password
{
    return (BaasIOResponse*)[_client addUser:username email:email name:name password:password];
}

-(BaasIOResponse *)addUserViaFacebook:(NSString *)accessToken
{
    NSString *url = [self createURL:@"auth" append2:@"facebook"];
    NSString *urlWithParameters = [url stringByAppendingFormat:@"?fb_access_token=%@", accessToken];

    return (BaasIOResponse*)[self httpTransaction:urlWithParameters op:kUGHTTPGet opData:nil];
}


// updates a user's password
-(BaasIOResponse *)updateUserPassword:(NSString *)usernameOrEmail oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    return (BaasIOResponse*)[_client updateUserPassword:usernameOrEmail oldPassword:oldPassword newPassword:newPassword];
}

-(BaasIOResponse *)getGroupsForUser: (NSString *)userID;
{
    return (BaasIOResponse*)[_client getGroupsForUser:userID];
}

-(BaasIOResponse *)getUsers: (BaasQuery *)query
{
    return (BaasIOResponse*)[_client getUsers:query];
}


/******************** ENTITY MANAGEMENT ********************/

-(BaasIOResponse *)createEntity:(NSDictionary *)newEntity
{
    return (BaasIOResponse*)[_client createEntity:newEntity];
}

-(BaasIOResponse *)getEntities: (NSString *)type query:(BaasQuery *)query
{
    return (BaasIOResponse*)[_client getEntities:type query:query];
}

-(BaasIOResponse *)updateEntity: (NSString *)entityID entity:(NSDictionary *)updatedEntity
{
    return (BaasIOResponse*)[_client updateEntity:entityID entity:updatedEntity];
}

-(BaasIOResponse *)removeEntity: (NSString *)type entityID:(NSString *)entityID
{
    return (BaasIOResponse*)[_client removeEntity:type entityID:entityID];
}


/************* PUSH NOTIFICATION MANAGEMENT *************/
- (BaasIOResponse *)registerDevice:(NSString *)token tags:(NSArray *)tags
{
    if (!token) {

        NSError *tokenError = [NSError errorWithDomain:@"UGClientErrorDomain"
                                                  code:kUGHTTPErrorDomainFailedSelector
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"There is no device token.", NSLocalizedDescriptionKey, nil]];

        BaasIOResponse *response = [BaasIOResponse new];
        [response setTransactionID:-1];
        [response setTransactionState:kUGClientResponseFailure];
        [response setResponse:tokenError];
        [response setRawResponse:nil];

        return response;
    }


    NSString *url = [self createURL:@"pushes" append2:@"devices"];

    NSMutableDictionary *opInfo = [NSMutableDictionary new];

    [opInfo setValue:@"I" forKey:@"platform"];

    if (tags) {
        [opInfo setValue:[tags JSONString] forKey:@"tags"];
    }

    [opInfo setValue:token forKey:@"token"];

    NSLog(@"opinfo : %@", opInfo);


    return [self httpTransaction:url op:kUGHTTPPost opData:[opInfo JSONString]];
}


- (BaasIOResponse *)unregisterDevice:(NSString *)uuid
{

    NSString *url = [self createURL:@"pushes" append2:@"devices" append3:uuid];

    return [self httpTransaction:url op:kUGHTTPDelete opData:nil];
}


-(void)setLogging: (BOOL)loggingState{
    [_client setLogging:loggingState];
}

#pragma mark - Gateway method

-(BaasIOResponse *)httpTransaction:(NSString *)url op:(NSInteger)op opData:(NSString *)opData{
    return objc_msgSend(_client, @selector(httpTransaction:op:opData:), url, op, opData);
}

- (NSString *)createURL:(NSString *)append append2:(NSString *)append2 {
    return [_client performSelector:@selector(createURL:append2:) withObject:append withObject:append2];
}

- (NSString *)createURL:(NSString *)append append2:(NSString *)append2 append3:(NSString *)append3 {
    return objc_msgSend(_client, @selector(createURL:append2:append3:), append, append2, append3);
}

@end