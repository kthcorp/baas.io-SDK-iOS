//
//  baas_io_sdkTests.m
//  baas.io-sdkTests
//
//  Created by cetauri on 12. 10. 25..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "baas_io_sdkTests.h"
#import "BaasClient.h"
#import "JSONKit.h"
@implementation baas_io_sdkTests{
}
static NSString *access_token;
- (void)setUp
{
    access_token = @"YWMtxlrjJh6dEeKpGgIATUUAVAAAATqdAFbsIc_q2Ndcv3BVZQ1GgCBeo06bpf4";
    [BaasClient setApplicationInfo:@"test.file" applicationName:@"bropbox"];
}

//- (void)test1_Login
//{
//    BaasClient *client = [BaasClient createInstance];
////    [client setDelegate:self];
//    [client setLogging:YES];
//    BaasIOResponse *response = [client logInUser:@"test" password:@"test"];
//
//    NSLog(@"response : %@", response.response);
//    access_token = [response.response objectForKey:@"access_token"];
//}
//
//
//- (void)test2_CreateEntity
//{
//    BaasClient *client = [BaasClient createInstance];
//    [client setAuth:access_token];
////    [client setDelegate:self];
//    [client setLogging:YES];
//
//    BaasIOResponse *response = [client createEntity:@{@"key" : @"value2", @"type": @"test"}];
//    NSLog(@"response : %@", response.rawResponse);
//}
//
//
//- (void)test3_removeEntity
//{
//    BaasClient *client = [BaasClient createInstance];
//    [client setAuth:access_token];
////    [client setDelegate:self];
//    [client setLogging:YES];
//
//    BaasIOResponse *response = [client removeEntity:@"test" entityID:@"a624268c-1e9a-11e2-a91a-02004d450054"];
//    NSLog(@"response : %@", response.rawResponse);
//}
//
//- (void)test4_readEntity
//{
//    BaasClient *client = [BaasClient createInstance];
//    
//    [client setAuth:access_token];
//    //    [client setDelegate:self];
//    [client setLogging:YES];
//    
//    BaasQuery *query = [[BaasQuery alloc] init];
//    [query addRequirement:@"key = 'value2'"];
//    
//    
//    BaasIOResponse *response = [client getEntities:@"test" query:query];
//    NSLog(@"response : %@", response.rawResponse);
//}
- (void)test5_registerDevice
{
    BaasClient *client = [BaasClient createInstance];
    
    [client setAuth:access_token];
    //    [client setDelegate:self];
    [client setLogging:YES];
    
    BaasIOResponse *response = [client registerDevice:@"test" tags:@[@"a",@"b"]];
    NSLog(@"response : %@", response.rawResponse);
}

- (void)test6_unregisterDevice
{
    BaasClient *client = [BaasClient createInstance];
    
    [client setAuth:access_token];
    //    [client setDelegate:self];
    [client setLogging:YES];
    
    BaasIOResponse *response = [client unregisterDevice:@"test"];
    NSLog(@"response : %@", response.rawResponse);
}

@end
