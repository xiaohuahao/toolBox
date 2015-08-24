//
//  BZGroupBuyDetailShareBtn.m
//  美团团购
//
//  Created by 尚承教育 on 15/7/24.
//  Copyright (c) 2015年 魔力包. All rights reserved.
//

#import "BZShareBtn.h"

@implementation BZShareBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat labelW = contentRect.size.width;
    CGFloat labelH = 20;
    CGFloat labelX = 0;
    CGFloat labelY = contentRect.size.height - 20;
    return CGRectMake(labelX, labelY, labelW, labelH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = contentRect.size.height - 20;
    CGFloat imageW = imageH;
    CGFloat imageX = (contentRect.size.width - imageW) / 2;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
