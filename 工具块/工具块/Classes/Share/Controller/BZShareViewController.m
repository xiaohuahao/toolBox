//
//  BZShareViewController.m
//  工具块
//
//  Created by 尚承教育 on 15/8/22.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZShareViewController.h"
#import "Masonry.h"
#import "UIViewController+Extension.h"
#import "UMSocial.h"
#import "BZShareEditViewController.h"

@interface BZShareViewController ()

@end

@implementation BZShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSwipBackGestureGecongnizer];
    [self setUpUI];
}

- (void)setUpUI
{
    // 友盟快速分享
    UIButton *repaidShareBtn = [[UIButton alloc]init];
    repaidShareBtn.backgroundColor = [UIColor redColor];
    [repaidShareBtn setTitle:@"快速分享" forState:UIControlStateNormal];
    repaidShareBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    [repaidShareBtn addTarget:self action:@selector(repaidShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repaidShareBtn];
    
    // 自定义分享
    UIButton *customShareBtn = [[UIButton alloc]init];
    customShareBtn.backgroundColor = [UIColor blueColor];
    [customShareBtn setTitle:@"自定义分享" forState:UIControlStateNormal];
    customShareBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    [customShareBtn addTarget:self action:@selector(customShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customShareBtn];
    
    // 约束
    [repaidShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.bottom.equalTo(customShareBtn.mas_top).offset(-10);
        make.height.equalTo(customShareBtn);
    }];
    
    [customShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(repaidShareBtn.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.equalTo(customShareBtn);
    }];
}

/**
 @brief 进入分享编辑页面
 */
- (void)repaidShare
{
    BZShareEditViewController *shareEditVC = [[BZShareEditViewController alloc]init];
    shareEditVC.customShare = NO;
    [self.navigationController pushViewController:shareEditVC animated:YES];
}
- (void)customShare
{
    BZShareEditViewController *shareEditVC = [[BZShareEditViewController alloc]init];
    shareEditVC.customShare = YES;
    [self.navigationController pushViewController:shareEditVC animated:YES];

}

@end
