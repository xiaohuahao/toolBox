//
//  AppDelegate.m
//  工具块
//
//  Created by 尚承教育 on 15/8/10.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "AppDelegate.h"
#import "BZNavigationController.h"
#import "BZHomeViewController.h"
#import "BZSettingViewController.h"
#import "BZLeftSliderViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "APService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    // 设置主页制器(右侧控制器)
    BZHomeViewController *mainVC = [[BZHomeViewController alloc]init];
    // 设置左侧控制器
    BZSettingViewController *settingViewController = [[BZSettingViewController alloc]init];
    // 设置主控制器
    BZLeftSliderViewController *leftSliderViewController = [[BZLeftSliderViewController alloc]initWithLeftVC:settingViewController andMainVC:mainVC];
    self.LeftSlideVC = leftSliderViewController;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:leftSliderViewController];
    nav.navigationBarHidden = YES;
    self.mainNavController = nav;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    
    // 设置友盟的AppKey
    [UMSocialData setAppKey:@"55d83a2067e58ea5890053c7"];
    
    //配置QQ及Qzone分享SSO
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    // 配置微信及朋友圈分享SSO
    [UMSocialWechatHandler setWXAppId:@"wxe2a367623e96ad91" appSecret:@"ee481425ddbbc0b5548fe7c808b541db" url:@"http://www.umeng.com/social"];
    // 配置新浪分享SSO
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    // 接收远程推送
    [APService
     registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                         UIUserNotificationTypeSound |
                                         UIUserNotificationTypeAlert)
     categories:nil];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
