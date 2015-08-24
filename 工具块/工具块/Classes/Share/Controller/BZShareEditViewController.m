//
//  BZShareEditViewController.m
//  工具块
//
//  Created by 尚承教育 on 15/8/23.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZShareEditViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"
#import "Masonry.h"
#import "UIViewController+Extension.h"
#import "BZShareBtnSelectView.h"
#import "BZShareBtn.h"

@interface BZShareEditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UMSocialUIDelegate,BZShareBtnSelectViewDelegate>
@property (strong, nonatomic) UITextView *shareTextView;
@property (strong, nonatomic) UIImageView *shareImageView;
@end

@implementation BZShareEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self addSwipBackGestureGecongnizer];
    [self setUpGesture];
}

- (void)setUpUI
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    // 初始化控件
    UIView *shareBgView = [[UIView alloc]init];
    shareBgView.backgroundColor =[UIColor grayColor];
    [self.view addSubview:shareBgView];
    
    UITextView *shareTextView = [[UITextView alloc]init];
    shareTextView.backgroundColor = [UIColor whiteColor];
    self.shareTextView = shareTextView;
    [shareBgView addSubview:shareTextView];
    
    UIImageView *shareImageView = [[UIImageView alloc]init];
    shareImageView.backgroundColor = [UIColor lightGrayColor];
    self.shareImageView = shareImageView;
    [shareBgView addSubview:shareImageView];
    
    UIButton *addImageBtn = [[UIButton alloc]init];
    [addImageBtn setTitle:@"添加分享图片" forState:UIControlStateNormal];
    addImageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    addImageBtn.layer.cornerRadius = 4;
    addImageBtn.backgroundColor = [UIColor lightGrayColor];
    [addImageBtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [shareBgView addSubview:addImageBtn];
    
    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.layer.cornerRadius = 4;
    shareBtn.backgroundColor = [UIColor redColor];
    [shareBtn setTitle:@"开始分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    // 设置约束
    [shareBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(10, 10, 70, 10));
    }];
    
    [shareTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(shareBgView).insets(UIEdgeInsetsMake(0, 0, 120, 0));
    }];
    
    [shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareBgView.mas_left).offset(5);
        make.top.equalTo(shareTextView.mas_bottom).offset(10);
        make.bottom.equalTo(shareBgView.mas_bottom).offset(-10);
        make.width.equalTo(shareImageView.mas_height);
    }];
    
    [addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareImageView.mas_right).offset(5);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@35);
        make.centerY.equalTo(shareImageView.mas_centerY);
    }];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareBgView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
}

- (void)setUpGesture
{
    UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(cancelEdit)];
    swipGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.shareTextView addGestureRecognizer:swipGesture];
}

- (void)cancelEdit
{
    [self.shareTextView resignFirstResponder];
}

/**
 @brief 添加需要分享的图片
 */
- (void)addImage
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

/**
 @brief 开始分享
 */
- (void)share
{
    if (self.isCustomShare) {
        BZShareBtnSelectView *shareBtnSelectView = [[BZShareBtnSelectView alloc]init];
        shareBtnSelectView.delegate = self;
        [shareBtnSelectView startShareWithText:self.shareTextView.text image:self.shareImageView.image];
    }
    else
    {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55d83a2067e58ea5890053c7" shareText:self.shareTextView.text shareImage:self.shareImageView.image shareToSnsNames:@[UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToDouban,UMShareToRenren,UMShareToEmail,UMShareToSms] delegate:self];

    }
}

/**
 @brief 在自定义分享中，点击平台分享按钮后的回调代理
 */
- (void)shareViewDidClickShareBtn:(BZShareBtnSelectView *)shareView selBtn:(BZShareBtn *)shareBtn
{
    [[UMSocialControllerService defaultControllerService] setShareText:shareView.shareText shareImage:shareView.shareImage socialUIDelegate:self];
    if (shareView.shareText == nil) {
        [MBProgressHUD showError:@"请填入分享内容"];
        return;
    }
    if ((shareBtn.socalSnsType == UMSocialSnsTypeQzone)) {
        if ((shareView.shareImage == nil) || (shareView.shareText == nil)) {
            [MBProgressHUD showError:@"分享到Qzone必须有图片和文字,请重新输入!"];
            return;
        }
    }
    UMSocialSnsPlatform *snsPlatForm = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformString:shareBtn.socalSnsType]];
    snsPlatForm.snsClickHandler(self,[UMSocialControllerService defaultControllerService], YES);
}

//分享后的回调方法
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    // 如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享到%@成功",[[response.data allKeys] objectAtIndex:0]);
//        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"已分享到%@",[[response.data allKeys] objectAtIndex:0]]];
    }
}


// 是否直接分享（不弹出编辑页面）
- (BOOL)isDirectShareInIconActionSheet
{
//    if (self.isCustomShare) {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
    return YES;
}

#pragma mark - UIImagePickerController 的代理回调方法
/**
 @brief 拿到需要分享的图片
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.shareImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
