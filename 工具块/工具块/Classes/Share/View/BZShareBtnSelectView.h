//
//  BZGroupBuyDetailShareView.h
//  美团团购
//
//  Created by 尚承教育 on 15/7/23.
//  Copyright (c) 2015年 魔力包. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BZShareBtnSelectView,BZShareBtn;
@protocol BZShareBtnSelectViewDelegate  <NSObject>

- (void)shareViewDidClickShareBtn:(BZShareBtnSelectView *)shareView selBtn:(BZShareBtn *)shareBtn;

@end

@interface BZShareBtnSelectView : UIImageView

/**
 @brief 打开分享页面开始分享
 */
- (void)startShareWithText:(NSString *)text image:(UIImage *)image;

@property (copy, nonatomic) NSString *shareText;
@property (strong, nonatomic) UIImage *shareImage;

@property (weak, nonatomic) id<BZShareBtnSelectViewDelegate> delegate;
@end
