//
//  FileUtils.m
//  baas.io-sdk-ios
//
//  Created by cetauri on 12. 10. 10..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "FileUtils.h"
#import "AFNetworking.h"
#import "UGClient.h"

@implementation FileUtils{
    NSString *_access_token;
    NSString *_apiURL;
}

-(id)initWithClient:(BaasClient *)client
{
    if (self = [super init])
    {
        _access_token = client.getAccessToken;
        _apiURL = client.getAPIURL;
    }
    return self;
}

-(void)download:(NSString *)url
           path:(NSString*)path
   successBlock:(void (^)(NSDictionary *response))successBlock
        failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock
{
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [self addAuthorization:request];

    void (^success)(NSURLRequest *, NSHTTPURLResponse *, id) = [self success:successBlock];
    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = [self failure:failureBlock];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:success
                                                                                        failure:failure];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead){
        float progress = (float)totalBytesRead / totalBytesExpectedToRead;
        progressBlock(progress);
//        NSLog(@"Sent %lld of %lld bytes : %lf", totalBytesRead, totalBytesExpectedToRead, progress);

    }];
    [operation start];
}

-(void)upload:(NSData *)data
        successBlock:(void (^)(NSDictionary *response))successBlock
        failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock
{
    [self upload:data httpMethod:@"POST" successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

-(void)reUpload:(NSData *)data
   successBlock:(void (^)(NSDictionary *response))successBlock
   failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock
{
    [self upload:data httpMethod:@"PUT" successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}
-(void)upload:(NSData *)data
   httpMethod:(NSString *)method
        successBlock:(void (^)(NSDictionary *response))successBlock
        failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *yyyymmdd = [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"HHmmssSSS"];
    NSString *HHmmssSSS = [formatter stringFromDate:[NSDate date]];
    
    NSString *path = [NSString stringWithFormat:@"%@/files/public/%@/%@/%@", _apiURL, yyyymmdd, HHmmssSSS, [FileUtils uuid]];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:path]];
    [self addAuthorization:request];
    [request setHTTPMethod:method];
    [request setHTTPBody:data];

    void (^success)(NSURLRequest *, NSHTTPURLResponse *, id) = [self success:successBlock];
    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = [self failure:failureBlock];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:success
                                                                                        failure:failure];

    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float progress = totalBytesWritten / totalBytesExpectedToWrite;
        progressBlock(progress);
    }];

    [operation start];
}

-(void)delete:(NSString *)uuid
   successBlock:(void (^)(NSDictionary *response))successBlock
   failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *path = [NSString stringWithFormat:@"%@/files/%@", _apiURL, uuid];
    NSURL *nurl = [NSURL URLWithString:path];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:nurl];
    [request setHTTPMethod:@"DELETE"];
    [self addAuthorization:request];

    void (^success)(NSURLRequest *, NSHTTPURLResponse *, id) = [self success:successBlock];
    void (^failure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = [self failure:failureBlock];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:success
                                                                                        failure:failure];
    [operation start];

}

#pragma mark - private method
- (void)addAuthorization:(NSMutableURLRequest *)request{
    if (_access_token != nil && ![_access_token isEqualToString:@""]){
        [request addValue:[NSString stringWithFormat:@"Bearer %@", _access_token] forHTTPHeaderField:@"Authorization"];
    }
}

+ (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)(uuidStringRef);
}

#pragma mark - API response method
- (void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure:(void (^)(NSError *))failureBlock {
    void (^failure)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (JSON == nil){
            failureBlock(error);
            return;
        }
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[JSON objectForKey:@"error_description"] forKey:NSLocalizedDescriptionKey];

        NSString *domain = [JSON objectForKey:@"error"];
        NSError *e = [NSError errorWithDomain:domain code:error.code userInfo:details];

        failureBlock(e);
    };
    return failure;
}

- (void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success:(void (^)(NSDictionary *))successBlock {
    void (^success)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        successBlock(JSON);
    };
    return success;
}
@end
