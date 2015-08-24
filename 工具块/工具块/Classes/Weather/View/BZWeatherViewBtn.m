//
//  BZWeatherViewBtn.m
//  工具块
//
//  Created by 尚承教育 on 15/8/16.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZWeatherViewBtn.h"

@interface BZWeatherViewBtn ()

@property (weak, nonatomic) IBOutlet UIImageView  *imageView;
@property (weak, nonatomic) IBOutlet UILabel      *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel      *iconLabel;
@property (weak, nonatomic) IBOutlet UIButton     *button;

@end


@implementation BZWeatherViewBtn

+ (instancetype)weatherViewBtn
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BZWeatherViewBtn" owner:nil options:nil] lastObject];
}

- (void)addTarget:(id)target andAction:(SEL)action
{
    [self.button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setIconTitle:(NSString *)iconTitle
{
    self.iconLabel.text = iconTitle;
}
- (void)setImage:(NSString *)imageName
{
    self.imageView.image = [UIImage imageNamed:imageName];
}
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
