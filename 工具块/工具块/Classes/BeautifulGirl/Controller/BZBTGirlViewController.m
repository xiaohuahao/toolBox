//
//  BZBTGirlViewController.m
//  工具块
//
//  Created by 尚承教育 on 15/8/17.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZBTGirlViewController.h"
#import "BZBTGirlFallsMainView.h"
#import "BZBTGirlImageModel.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+Extension.h"

@interface BZBTGirlViewController ()
@property (strong, nonatomic) BZBTGirlFallsMainView *fallsView;
@property (assign, nonatomic, getter=isInRefresh) BOOL inRefresh;
@end

@implementation BZBTGirlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self addSwipBackGestureGecongnizer];
    [self loadNewDatas];
}

- (void)setUpUI
{
    BZBTGirlFallsMainView *fallsView = [[BZBTGirlFallsMainView alloc]init];
    fallsView.frame = self.view.bounds;
    self.fallsView = fallsView;
    [self.view addSubview:fallsView];
}

- (void)loadNewDatas
{
    if (self.isInRefresh) return;
    NSDictionary *param = @{@"num" : @5};
    self.inRefresh = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.inRefresh = NO;
    });

    [BZHttp httpGetWithUrl:@"http://apis.baidu.com/txapi/mvtp/meinv" andParams:param andSuccess:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *dictDatas = result;
//        NSMutableArray *imageDatas = [NSMutableArray array];
//        NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
        [dictDatas enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([self isPureInt:key]) {
                BZBTGirlImageModel *imageModel = [BZBTGirlImageModel objectWithKeyValues:obj];
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:imageModel.picUrl] cachePolicy:0 timeoutInterval:5];

                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (data != nil && connectionError == nil) {
                        UIImage *image = [UIImage imageWithData:data];
                        NSLog(@"--------");
                        [self.fallsView addImageArr:@[image]];
                    }
                }];
            }
        }];
    } andFailure:^(NSError *error) {
        self.inRefresh = NO;
        [MBProgressHUD showError:@"加载数据失败！"];
    }];
}

/**
 @brief 晃动手机加载更多
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"-----------");
    [self loadNewDatas];
}

/**
 @brief 判断字符串是都由数字组成
 */
- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}
@end
