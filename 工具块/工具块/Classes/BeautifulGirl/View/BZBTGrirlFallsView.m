//
//  BZBTGrirlFallsView.m
//  工具块
//
//  Created by 尚承教育 on 15/8/17.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZBTGrirlFallsView.h"
#import "BZBTGirlImageModel.h"

@implementation BZBTGrirlFallsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)addImage:(UIImage *)image
{
    @synchronized(self){
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.width = self.width;
        imageView.height = self.width * (image.size.height / image.size.width);
        imageView.y = self.currentHeight;
        self.currentHeight = CGRectGetMaxY(imageView.frame);
        [self addSubview:imageView];
    }
}

- (CGFloat)fallsViewHeight
{
    return self.currentHeight;
}

@end
