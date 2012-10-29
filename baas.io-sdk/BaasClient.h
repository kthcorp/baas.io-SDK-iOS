//
// Created by cetauri on 12. 10. 25..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BaasIOResponse.h"
#import "BaasQuery.h"

@interface BaasClient : NSObject

/********************* Default Setting *********************/
+ (void)setApplicationInfo:(NSString *)orgName applicationName:(NSString *)applicationName;
+ (void)setApplicationInfo:(NSString *)apiURL organizationName:(NSString *)orgName applicationName:(NSString *)applicationName;
+ (id) createInstance;
- (NSString *)getAppInfo;
- (NSString *)getAPIURL;
- (NSString *)getAPIHost;
- (BOOL)setDelegate:(id)delegate;
- (void)setAuth:(NSString *)auth;
- (NSString *)getAccessToken;

/********************* LOGIN / LOGOUT *********************/
// log in with the given username and password
-(BaasIOResponse *)logInUser: (NSString *)userName password:(NSString *)password;

// log out the current user. The Client only supports one user logged in at a time.
// You can have multiple instances of UGClient if you want multiple
// users doing transactions simultaneously. This does not require network communication,
// so it has no return. It doesn't actually "log out" from the server. It simply clears
// the locally stored auth information
-(void)logOut;

/********************* USER MANAGEMENT *********************/
//adds a new user
-(BaasIOResponse *)addUser:(NSString *)username email:(NSString *)email name:(NSString *)name password:(NSString *)password;

-(BaasIOResponse *)addUserViaFacebook:(NSString *)accessToken;

// updates a user's password
-(BaasIOResponse *)updateUserPassword:(NSString *)usernameOrEmail oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;

// get all the groups this user is in
-(BaasIOResponse *)getGroupsForUser: (NSString *)userID;

// get users in this app. Definitely want to consider sending a Query along
// with this call
-(BaasIOResponse *)getUsers: (BaasQuery *)query;

/******************** ENTITY MANAGEMENT ********************/
// adds an entity to the specified collection.
-(BaasIOResponse *)createEntity: (NSString *)entityName entity:(NSDictionary *)newEntity;

// get a list of entities that meet the specified query.
-(BaasIOResponse *)getEntities: (NSString *)entityName query:(BaasQuery *)query;

// updates an entity (it knows the type from the entity data)
-(BaasIOResponse *)updateEntity: (NSString *)entityName entityID:(NSString *)entityID entity:(NSDictionary *)updatedEntity;

// removes an entity of the specified entityName
-(BaasIOResponse *)removeEntity: (NSString *)entityName entityID:(NSString *)entityID;

-(BaasIOResponse *)readEntity: (NSString *)entityName entityID:(NSString *)entityID;

/********************* PUSH NOTIFICATION MANAGEMENT *********************/
- (BaasIOResponse *)registerDevice:(NSString *)token tags:(NSArray *)tags;
- (BaasIOResponse *)unregisterDevice:(NSString *)uuid;

/************* File MANAGEMENT *************/
-(void)download:(NSString *)remotePath
           path:(NSString*)localPath
   successBlock:(void (^)(NSDictionary *response))successBlock
   failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock;

-(void)upload:(NSData *)data
       header:(NSDictionary*)header
 successBlock:(void (^)(NSDictionary *response))successBlock
 failureBlock:(void (^)(NSError *error))failureBlock
progressBlock:(void (^)(float progress))progressBlock;


-(void)upload:(NSString *)path
         data:(NSData *)data
       header:(NSDictionary*)header
 successBlock:(void (^)(NSDictionary *response))successBlock
 failureBlock:(void (^)(NSError *error))failureBlock
progressBlock:(void (^)(float progress))progressBlock;

-(void)reUpload:(NSString *)uuid
           data:(NSData*)data
         header:(NSDictionary*)header
   successBlock:(void (^)(NSDictionary *response))successBlock
   failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock;

-(void)delete:(NSString *)uuid
successBlock:(void (^)(NSDictionary *response))successBlock
failureBlock:(void (^)(NSError *error))failureBlock;

-(void)fileInformation:(void (^)(NSDictionary *response))successBlock
          failureBlock:(void (^)(NSError *error))failureBlock;

-(void)fileInformation:(NSString *)uuid
          successBlock:(void (^)(NSDictionary *response))successBlock
          failureBlock:(void (^)(NSError *error))failureBlock;

-(void)fileList:(NSString *)dir
   successBlock:(void (^)(NSDictionary *response))successBlock
   failureBlock:(void (^)(NSError *error))failureBlock;

/*********************** DEBUGGING ASSISTANCE ************************/
-(void)setLogging: (BOOL)loggingState;


@end