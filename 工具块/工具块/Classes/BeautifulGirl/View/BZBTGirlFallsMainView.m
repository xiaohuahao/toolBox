//
//  BZBTGirlFallsMainView.m
//  工具块
//
//  Created by 尚承教育 on 15/8/17.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "UIImageView+WebCache.h"

#import "BZBTGirlFallsMainView.h"
#import "BZBTGrirlFallsView.h"
#import "BZBTGirlImageModel.h"

#define kFallsViewCount 3

@interface BZBTGirlFallsMainView ()
@property (strong, nonatomic) BZBTGrirlFallsView *oneFallsView;
@property (strong, nonatomic) BZBTGrirlFallsView *twoFallsView;
@property (strong, nonatomic) BZBTGrirlFallsView *threeFalllsView;

@property (strong, nonatomic) NSArray *fallsViewArr;

@property (strong, nonatomic) NSMutableArray *imageDatas;
@end


@implementation BZBTGirlFallsMainView

/**
 @brief 懒加载数据
 */
- (NSMutableArray *)imageDatas
{
    if (!_imageDatas) {
        _imageDatas = [NSMutableArray array];
    }
    return _imageDatas;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _oneFallsView = [[BZBTGrirlFallsView alloc]init];
        _oneFallsView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_oneFallsView];
        
        _twoFallsView = [[BZBTGrirlFallsView alloc]init];
        [self addSubview:_twoFallsView];
        
        _threeFalllsView = [[BZBTGrirlFallsView alloc]init];
        _threeFalllsView.backgroundColor = [UIColor greenColor];
        [self addSubview:_threeFalllsView];
        
        self.fallsViewArr = @[_oneFallsView,_twoFallsView,_threeFalllsView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat fallsViewW = self.width / kFallsViewCount;
    NSLog(@"*********%ld",self.fallsViewArr.count);
    for (int i = 0; i < self.fallsViewArr.count; i ++) {
        UIView *childView = self.fallsViewArr[i];
            childView.width = fallsViewW;
            childView.y = 0;
            childView.x = fallsViewW * i;
            childView.height = self.height;
    }
}

- (void)addImageArr:(NSArray *)imageArr
{
    BZBTGrirlFallsView *shortFallsView = [[BZBTGrirlFallsView alloc]init];
    BZBTGrirlFallsView *longFallsView = [[BZBTGrirlFallsView alloc]init];
    for (UIImage *image in imageArr) {
        shortFallsView = self.oneFallsView.currentHeight < self.twoFallsView.currentHeight ? self.oneFallsView : self.twoFallsView;
        shortFallsView = shortFallsView.currentHeight < self.threeFalllsView.currentHeight ? shortFallsView : self.threeFalllsView;
        [shortFallsView addImage:image];
        
        longFallsView = self.oneFallsView.currentHeight > self.twoFallsView.currentHeight ? self.oneFallsView : self.twoFallsView;
        longFallsView = longFallsView.currentHeight > self.threeFalllsView.currentHeight ? longFallsView : self.threeFalllsView;
        self.contentSize = CGSizeMake(1, longFallsView.currentHeight);
    }
}


@end
