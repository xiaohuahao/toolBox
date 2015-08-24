//
//  BZWeatherViewBtn.h
//  工具块
//
//  Created by 尚承教育 on 15/8/16.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZWeatherViewBtn : UIView

+ (instancetype)weatherViewBtn;
- (void)addTarget:(id)target andAction:(SEL)action;
- (void)setIconTitle:(NSString *)iconTitle;
- (void)setImage:(NSString *)imageName;
- (void)setTitle:(NSString *)title;

@end
