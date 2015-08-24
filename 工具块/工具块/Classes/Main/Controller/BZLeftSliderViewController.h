//
//  BZLeftSliderViewController.h
//  今日头条SSBun
//
//  Created by 尚承教育 on 15/8/2.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define kMainPageDistance   100   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale   0.8  //打开左侧窗时，中视图(右视图）缩放比例
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat   0.7    //滑动速度

#define kLeftAlpha 0.9  //左侧蒙版的最大值
#define kLeftCenterX 30 //左侧初始偏移量
#define kLeftScale 0.7 //左侧初始缩放比例

#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@interface BZLeftSliderViewController : UIViewController

/** 
 滑动速度系数 
 */
@property (assign, nonatomic) CGFloat speedf;

@property (strong, nonatomic) UIViewController *leftVC;
@property (strong, nonatomic) UIViewController *mainVC;

@property (strong, nonatomic) UITapGestureRecognizer *backTapGes;

@property (strong, nonatomic) UIPanGestureRecognizer *panGes;

@property (assign, nonatomic) BOOL closed;

- (instancetype)initWithLeftVC:(UIViewController *)leftVC
                     andMainVC:(UIViewController *)mainVC;

- (void)closeLeftView;

- (void)openLeftView;

- (void)setPanEnabled:(BOOL)enabled;

@end
