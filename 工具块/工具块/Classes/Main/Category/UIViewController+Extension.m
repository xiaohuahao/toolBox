//
//  UIViewController+Extension.m
//  工具块
//
//  Created by 尚承教育 on 15/8/22.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)addSwipBackGestureGecongnizer
{
    UISwipeGestureRecognizer *swipGestureRecongnizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    swipGestureRecongnizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipGestureRecongnizer];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
