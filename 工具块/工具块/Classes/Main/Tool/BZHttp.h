//
//  BZHttp.h
//  工具块
//
//  Created by 尚承教育 on 15/8/10.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZHttp : NSObject


+ (void)httpGetWithUrl:(NSString *)url andParams:(NSDictionary *)params andSuccess:(void(^)(id result))success andFailure:(void(^)(NSError *error))failure;
+ (void)httpPostWithUrl:(NSString *)url andParams:(NSDictionary *)params andSuccess:(void(^)(id result))success andFailure:(void(^)(NSError *error))failure;
@end
