//
//  BZIdCardViewController.m
//  工具块
//
//  Created by 尚承教育 on 15/8/16.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

#import "BZIdCardViewController.h"
#import "BZIdCardResultView.h"
#import "BZIdCardModel.h"
#import "BZIdCardHistoryRecodView.h"
#import "BZIdCardTool.h"
#import "UIViewController+Extension.h"

@interface BZIdCardViewController ()<BZIdCardHistoryRecodViewDelegate>

@property (strong, nonatomic) BZIdCardResultView  *resultView;
@property (strong, nonatomic) UITextField         *searchTextField;
@property (strong, nonatomic) UIButton            *searchBtn;
@property (strong, nonatomic) BZIdCardHistoryRecodView *historyRecodView;

@property (assign, nonatomic, getter=isHaveResult) BOOL haveResult;
@end

@implementation BZIdCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSwipBackGestureGecongnizer];
    
    [self setUpUI];
    [self setUpHistoryRecodView];
}

- (void)setUpUI
{
    CGFloat margin = 20;
    // 搜索框
    UITextField *searchTextField = [[UITextField alloc]init];
    searchTextField.width  = self.view.width - 20 * 2;
    searchTextField.height = 30;
    searchTextField.x = margin;
    searchTextField.y = 100;
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.textColor = [UIColor grayColor];
    searchTextField.placeholder = @"请输入有效的身份证号";
    searchTextField.layer.cornerRadius = 3;
    self.searchTextField = searchTextField;
    [self.view addSubview:searchTextField];
    // 搜索按钮
    UIButton *searchBtn = [[UIButton alloc]init];
    searchBtn.width = 100;
    searchBtn.height = 50;
    searchBtn.x = (self.view.width - searchBtn.width) * 0.5;
    searchBtn.y = CGRectGetMaxY(searchTextField.frame) + margin;
    searchBtn.layer.cornerRadius = 4;
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn = searchBtn;
    [self.view addSubview:searchBtn];
    // 搜索结果View
    BZIdCardResultView *resultView = [BZIdCardResultView idCardResultView];
    resultView.width = self.view.width - margin * 2;
    resultView.height = 275;
    resultView.x = margin;
    resultView.y = CGRectGetMaxY(searchBtn.frame) + 10;
    resultView.alpha = 0;
    resultView.layer.cornerRadius = 4;
    self.resultView = resultView;
    [self.view addSubview:resultView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismis:)];
    [resultView addGestureRecognizer:tapGesture];
}

/**
 @brief 添加手势，点击view消失
 */
- (void)dismis:(UITapGestureRecognizer *)tapGesture
{
    [UIView animateWithDuration:1 animations:^{
        tapGesture.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.haveResult = NO;
        self.historyRecodView.hidden = NO;
        [self.historyRecodView reloadValue];
    }];
}

/**
 @brief 初始化历史记录View
 */
- (void)setUpHistoryRecodView
{
    BZIdCardHistoryRecodView *histroyRecodView = [BZIdCardHistoryRecodView idCardHistroyRecodView];
    histroyRecodView.y = CGRectGetMaxY(self.searchBtn.frame) + 10;
    histroyRecodView.x = 10;
    histroyRecodView.width = self.view.width - 20;
    self.historyRecodView = histroyRecodView;
    histroyRecodView.recodDelegate = self;
    [self.view addSubview:histroyRecodView];
}

/**
 @brief 开始搜索
 */
- (void)beginSearch
{
    [self.searchTextField resignFirstResponder];
    if (self.searchTextField.text.length != 18) {
        [MBProgressHUD showError:@"请输入18位身份证号"];
        return;
    }
    NSDictionary *dict = @{@"id" : self.searchTextField.text};
    [BZHttp httpGetWithUrl:@"http://apis.baidu.com/apistore/idservice/id" andParams:dict andSuccess:^(id result) {
        NSLog(@"%@",result);
        if (![result[@"retData"] isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD showError:@"您输入的身份证号不合法"];
            return;
        }
        BZIdCardModel *idCardModel = [BZIdCardModel objectWithKeyValues:result[@"retData"]];
        idCardModel.idCardNum = self.searchTextField.text;
        [self showIdCardMessage:idCardModel];
    } andFailure:^(NSError *error) {
        [MBProgressHUD showError:@"网络有误或未查找到有效信息！"];
    }];
}

/**
 @brief 显示搜索结果
 */
- (void)showIdCardMessage:(BZIdCardModel *)idCardModel
{
    self.historyRecodView.hidden = YES;
    [BZIdCardTool saveRecod:idCardModel];
    if (self.isHaveResult) {
        [UIView animateWithDuration:0.5 animations:^{
            self.resultView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.resultView setSex:idCardModel.sex];
            [self.resultView setBirthday:idCardModel.birthday];
            [self.resultView setAddress:idCardModel.address];
            
            [UIView animateWithDuration:1 animations:^{
                self.resultView.alpha = 0.8;
            }];

        }];
    }
    else
    {
        [self.resultView setSex:idCardModel.sex];
        [self.resultView setBirthday:idCardModel.birthday];
        [self.resultView setAddress:idCardModel.address];
        
        [UIView animateWithDuration:1 animations:^{
            self.resultView.alpha = 0.8;
            self.haveResult = YES;
        }];
    }
}

#pragma mark - BZIdCardHistoryRecodViewDelegate

- (void)idCardHistoryRecodView:(BZIdCardHistoryRecodView *)recodView didClickCell:(BZIdCardModel *)idCardModel
{
    self.searchTextField.text = idCardModel.idCardNum;
}


@end
