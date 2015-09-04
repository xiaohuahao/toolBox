//
//  BZHttp.m
//  工具块
//
//  Created by 尚承教育 on 15/8/10.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZHttp.h"
#import "BZWeatherModel.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

@implementation BZHttp



+ (void)httpGetWithUrl:(NSString *)url andParams:(NSDictionary *)params andSuccess:(void (^)(id result))success andFailure:(void (^)(NSError *error))failure
{
    NSMutableString *paramsUrlStr = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramsUrlStr appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
    }];
    [paramsUrlStr deleteCharactersInRange:NSMakeRange(paramsUrlStr.length - 1, 1)];
    NSString *httpUrl = [NSString stringWithFormat:@"%@?%@",url,paramsUrlStr];
    NSString *newHttpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   [self httpWithHttpUlr:newHttpUrl WithMethod:@"GET" andSuccess:success andFailure:failure];
}

+ (void)httpPostWithUrl:(NSString *)url andParams:(NSDictionary *)params andSuccess:(void(^)(id))success andFailure:(void(^)(NSError *error))failure
{
    NSMutableString *paramsUrlStr = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramsUrlStr appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
    }];
    [paramsUrlStr deleteCharactersInRange:NSMakeRange(paramsUrlStr.length - 1, 1)];
    NSString *httpUrl = [NSString stringWithFormat:@"%@?%@",url,paramsUrlStr];
    NSString *newHttpUrl = [httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self httpWithHttpUlr:newHttpUrl WithMethod:@"POST" andSuccess:success andFailure:failure];

}

+ (void)httpWithHttpUlr:(NSString *)url WithMethod:(NSString *)method andSuccess:(void(^)(id result))success andFailure:(void(^)(NSError *error))failure
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:10];
    [urlRequest setHTTPMethod:method];
    [urlRequest setValue:@"8bf90743c502622b1ec7ca5844718168" forHTTPHeaderField:@"apikey"];
    
    __block  id myData;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil || myData == nil) {
            
            if (failure) {
                failure(connectionError);
            }
        }
        else
        {
            if (success) {
                myData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                success(myData);
            }
        }
    }];
}



@end
