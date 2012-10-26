//
//  FileUtils.h
//  baas.io-sdk-ios
//
//  Created by cetauri on 12. 10. 10..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaasClient.h"

@interface FileUtils : NSObject

-(id)initWithClient:(BaasClient *)client;

-(void)download:(NSString *)url
           path:(NSString*)path
   successBlock:(void (^)(NSDictionary *response))successBlock
        failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock;

-(void)upload:(NSData *)data
        successBlock:(void (^)(NSDictionary *response))successBlock
        failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock;

-(void)reUpload:(NSData *)data
   successBlock:(void (^)(NSDictionary *response))successBlock
   failureBlock:(void (^)(NSError *error))failureBlock
  progressBlock:(void (^)(float progress))progressBlock;

-(void)delete:(NSString *)uuid
   successBlock:(void (^)(NSDictionary *response))successBlock
   failureBlock:(void (^)(NSError *error))failureBlock;

@end
