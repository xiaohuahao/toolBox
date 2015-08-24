//
//  BZGroupBuyDetailShareView.m
//  美团团购
//
//  Created by 尚承教育 on 15/7/23.
//  Copyright (c) 2015年 魔力包. All rights reserved.
//

#import "BZShareBtnSelectView.h"
#import "BZShareBtn.h"
#import "UMSocial.h"

#define Duration 0.3
#define MaxCols 4
@interface BZShareBtnSelectView ()

@property (strong, nonatomic) UIButton *coverBtn;
@end


@implementation BZShareBtnSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
   [self addShareBtnWithTitle:@"微信好友" imageName:@"UMS_wechat_icon" andShareObject:UMSocialSnsTypeWechatSession];
    
   [self addShareBtnWithTitle:@"微信朋友圈" imageName:@"UMS_wechat_timeline_on" andShareObject:UMSocialSnsTypeWechatTimeline];
    
   [self addShareBtnWithTitle:@"新浪微博" imageName:@"UMS_sina_icon" andShareObject:UMSocialSnsTypeSina];
    
   [self addShareBtnWithTitle:@"人人网" imageName:@"UMS_renren_icon" andShareObject:UMSocialSnsTypeRenr];
    
   [self addShareBtnWithTitle:@"QQ" imageName:@"UMS_qq_icon" andShareObject:UMSocialSnsTypeMobileQQ];
    
   [self addShareBtnWithTitle:@"腾讯微博" imageName:@"UMS_tencent_icon" andShareObject:UMSocialSnsTypeTenc];
    
   [self addShareBtnWithTitle:@"QQ空间" imageName:@"UMS_qzone_icon" andShareObject:UMSocialSnsTypeQzone];
    
    [self addShareBtnWithTitle:@"短信" imageName:@"UMS_sms_icon" andShareObject:UMSocialSnsTypeSms];
    
//    [self addShareBtnWithTitle:@"来往" imageName:@"UMS_laiwang_timeline" andShareObject:UMSocialSnsTypeLaiWangTimeline];
    
//    [self addShareBtnWithTitle:@"来往好友" imageName:@"UMS_laiwang_session" andShareObject:UMSocialSnsTypeLaiWangSession];
    
    [self addShareBtnWithTitle:@"邮件" imageName:@"UMS_email_icon" andShareObject:UMSocialSnsTypeEmail];
    
    [self addShareBtnWithTitle:@"豆瓣" imageName:@"UMS_douban_icon" andShareObject:UMSocialSnsTypeDouban];
    
    [self addShareBtnWithTitle:@"易信好友" imageName:@"UMS_yixin_session" andShareObject:UMSocialSnsTypeYiXinSession];
    
    [self addShareBtnWithTitle:@"易信" imageName:@"UMS_yixin_timeline" andShareObject:UMSocialSnsTypeYiXinTimeline];
    
    [self addShareBtnWithTitle:@"twitter" imageName:@"UMS_twitter_icon" andShareObject:UMSocialSnsTypeTwitter];
    return self;
}

- (BZShareBtn *)addShareBtnWithTitle:(NSString *)title imageName:(NSString *)imageName andShareObject:(UMSocialSnsType)socialSnsType;
{
    BZShareBtn *btn = [[BZShareBtn alloc]init];
    
    btn.socalSnsType = socialSnsType;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

/**
 @brief 点击各各平台的分享按钮
 */
- (void)clickShareBtn:(BZShareBtn *)shareBtn
{
    if ([self.delegate respondsToSelector:@selector(shareViewDidClickShareBtn:selBtn:)]) {
        [self.delegate shareViewDidClickShareBtn:self selBtn:shareBtn];
    }
    [self stopShare];
}

/**
 @brief 打开分享页面开始分享
 */
- (void)startShareWithText:(NSString *)text image:(UIImage *)image
{
    self.shareImage = image;
    self.shareText = text;
    UIButton *coverBtn = [[UIButton alloc]init];
    self.coverBtn = coverBtn;
    coverBtn.backgroundColor = [UIColor blackColor];
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
    coverBtn.frame = window.bounds;
    coverBtn.alpha = 0;
    [coverBtn addTarget:self action:@selector(stopShare) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:coverBtn];
    
    [self layoutSubviews];
    NSLog(@"%f",self.height);
    self.frame = CGRectMake(0, window.height , window.width, self.height);
    [window addSubview:self];
    
    [UIView animateWithDuration:Duration animations:^{
        coverBtn.alpha = 0.5;
        self.transform = CGAffineTransformMakeTranslation(0, -self.height);
    }];
}

/** 取消分享页面*/
- (void)stopShare
{
    [UIView animateWithDuration:Duration animations:^{
       self.coverBtn.alpha = 0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)layoutSubviews
{
    CGFloat Margin = 10;
    CGFloat btnW = (kScreenW - Margin * (MaxCols + 1)) / MaxCols;
    CGFloat btnH = btnW;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        int col = i % MaxCols;
        int row = i / MaxCols;
        btnX = Margin + col * (Margin + btnW);
        btnY = Margin + row * (Margin + btnH);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        if (i == self.subviews.count - 1) {
            self.height = CGRectGetMaxY(btn.frame) + Margin;
        }
    }
    
}

@end
