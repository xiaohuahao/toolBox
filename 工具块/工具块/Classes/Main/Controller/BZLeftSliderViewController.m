//
//  BZLeftSliderViewController.m
//  今日头条SSBun
//
//  Created by 尚承教育 on 15/8/2.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZLeftSliderViewController.h"

@interface BZLeftSliderViewController ()<UIGestureRecognizerDelegate>
{
     CGFloat _transLationH; // 横向实时位移
}
@property (strong, nonatomic) UITableView      *leftTableView;
@property (strong, nonatomic) UIView           *coverView;

@property (assign, nonatomic) CGFloat  leftTableViewW;
@end

@implementation BZLeftSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)initWithLeftVC:(UIViewController *)leftVC andMainVC:(UIViewController *)mainVC
{
    if (self = [super init]) {
        
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        [self addChildViewController:leftVC];
        [self addChildViewController:mainVC];
        
        // 滑动手势
        self.panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.panGes];
        [self.panGes setCancelsTouchesInView:YES];
        self.panGes.delegate = self;
        
        self.leftVC.view.hidden = YES;
        // 添加左右控制器的View
        [self.view addSubview:self.leftVC.view];
        [self.view addSubview:self.mainVC.view];
        // 蒙版
        UIView *coverView = [[UIView alloc]init];
        coverView.frame = self.leftVC.view.bounds;
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.5;
        self.coverView = coverView;
        [self.leftVC.view addSubview:coverView];
        
        //获取左侧tableView
        for (UIView *view in self.leftVC.view.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                self.leftTableView = (UITableView *)view;
            }
        }
        
        self.leftTableView.backgroundColor = [UIColor clearColor];
        self.leftTableView.frame = CGRectMake(0, 0, kScreenWidth - kMainPageDistance, kScreenHeight);
        
        self.leftTableView.transform = CGAffineTransformMakeScale(kLeftScale, 1.0f);
        self.leftTableView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        
        self.closed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
}



- (void)handlePan:(UIPanGestureRecognizer *)panGes
{
    CGPoint point  = [panGes translationInView:self.view];
    
    _transLationH = point.x * self.speedf + _transLationH;
    
    BOOL needMoveWithTap = YES;// 是否继续跟随手指移动
    
    if (((self.mainVC.view.x <= 0) && (_transLationH <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance)) && (_transLationH >= 0))) {
        _transLationH = 0;
        needMoveWithTap = NO;
    }
    
    if (needMoveWithTap && (panGes.view.frame.origin.x >= 0) && panGes.view.frame.origin.x <= (kScreenWidth - kMainPageDistance)) {
        
        CGFloat panGesCenterX = panGes.view.centerX + point.x * self.speedf;
        
        if (panGesCenterX <= kScreenWidth * 0.5) {
            panGesCenterX = kScreenWidth * 0.5;
        }
        
        CGFloat panGesCenterY = panGes.view.centerY;
        
        CGFloat scale = 1 - (1 - kMainPageScale) * (panGes.view.x / (kScreenWidth - kMainPageDistance));
        
        panGes.view.center = CGPointMake(panGesCenterX, panGesCenterY);
        panGes.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        
        [panGes setTranslation:CGPointZero inView:self.view];
        
        CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) * (panGes.view.x / (kScreenWidth - kMainPageDistance));
        
        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (panGes.view.x / (kScreenWidth - kMainPageDistance));
        NSLog(@"%f",leftScale);
        
        self.leftTableView.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale, leftScale);
        
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (panGes.view.x / (kScreenWidth - kMainPageDistance));
        self.coverView.alpha = tempAlpha;
    }
    else
    {
        if (self.mainVC.view.x < 0)
        {
            [self closeLeftView];
            _transLationH = 0;
        }
        else if (self.mainVC.view.x > (kScreenWidth - kMainPageDistance))
        {
            [self openLeftView];
            _transLationH = 0;
        }
    }
    
    // 手势结束后的修正,超出一半时向多出的一半偏移
    if (panGes.state == UIGestureRecognizerStateEnded) {
        if (fabs(_transLationH) > vCouldChangeDeckStateDistance) {
            if (self.closed)
            {
                [self openLeftView];
            }
            else
            {
                [self closeLeftView];
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
            }
            else
            {
                [self openLeftView];
            }
        }
        _transLationH = 0;
        
      }
}

- (void)handeTap:(UITapGestureRecognizer *)tap
{
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        tap.view.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
        self.closed = YES;
        
        self.leftTableView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kLeftScale, kLeftScale);
        self.coverView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        
        _transLationH = 0;
        [self removeSingleTap];
    }
}

#pragma mark - 改变视图的状态

/**
 关闭左视图
 */
- (void)closeLeftView
{
    [UIView beginAnimations:nil context:nil];
    
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    self.mainVC.view.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    self.closed = YES;
    
    self.leftTableView.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kLeftScale, kLeftScale);
    self.coverView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}

/**
 打开左视图
 */
- (void)openLeftView
{
    [UIView beginAnimations:nil context:nil];
    
    self.mainVC.view.center = kMainPageCenter;
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, kMainPageScale, kMainPageScale);
    self.closed = NO;
    
    self.leftTableView.center = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    self.coverView.alpha = 0;
    
    [UIView commitAnimations];
    [self disableTapButton];
}

#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *btn in self.mainVC.view.subviews) {
        btn.userInteractionEnabled = NO;
    }
    if (!self.backTapGes) {
        
        self.backTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        
        self.backTapGes.numberOfTapsRequired = 1;
        
        [self.mainVC.view addGestureRecognizer:self.backTapGes];
        
        self.backTapGes.cancelsTouchesInView = YES;
        
    }
}

- (void)removeSingleTap
{
    for (UIButton *btn in self.mainVC.view.subviews)
    {
        [btn setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.backTapGes];
    
    self.backTapGes = nil;
}

- (void)setPanEnabled:(BOOL)enabled
{
    [self.panGes setEnabled:enabled];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == vDeckCanNotPanViewTag)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (CGFloat)speedf
{
    return vSpeedFloat;
}

@end
