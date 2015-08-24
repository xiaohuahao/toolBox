//
//  BZIdCardHistoryRecodView.h
//  工具块
//
//  Created by 尚承教育 on 15/8/21.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BZIdCardHistoryRecodView,BZIdCardModel;

@protocol  BZIdCardHistoryRecodViewDelegate <NSObject>

- (void)idCardHistoryRecodView:(BZIdCardHistoryRecodView *)recodView didClickCell:(BZIdCardModel *)idCardModel;
@end

@interface BZIdCardHistoryRecodView : UIView

@property (weak,nonatomic) id <BZIdCardHistoryRecodViewDelegate> recodDelegate;

+ (instancetype)idCardHistroyRecodView;

/**刷新数据*/
- (void)reloadValue;

@end
