//
//  BZBaseSearchEnum.m
//  工具块
//
//  Created by 尚承教育 on 15/8/16.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZBaseSearchEnum.h"
#define kLREdge        20
#define kTopEdge       200
#define kToolBarH      30
#define kTableViewRowH 30

@interface BZBaseSearchEnum ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

/**蒙版*/
@property (strong, nonatomic) UIButton    *coverBtn;
/**搜索工具条*/
@property (strong, nonatomic) UIView      *toolBar;
/**收索结果显示TableView*/
@property (strong, nonatomic) UITableView *resultView;
/**搜索TextField*/
@property (strong, nonatomic) UITextField *searchTextField;
/**搜索按钮*/
@property (strong, nonatomic) UIButton    *searchBtn;

@end


@implementation BZBaseSearchEnum

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *coverBtn = [[UIButton alloc]init];
        self.coverBtn = coverBtn;
        coverBtn.backgroundColor = [UIColor blackColor];
        coverBtn.alpha = 0.5;
        [coverBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverBtn];
        
        UIView *toolBar = [[UIView alloc]init];
        self.toolBar = toolBar;
        toolBar.alpha = 0.8;
        [self setUpToolBar];
        [self addSubview:toolBar];
        
        UITableView *resultView = [[UITableView alloc]init];
        resultView.alpha = 0.8;
        resultView.layer.cornerRadius = 3;
        resultView.delegate = self;
        resultView.rowHeight = kTableViewRowH;
        resultView.dataSource = self;
        resultView.backgroundColor = [UIColor clearColor];
        self.resultView = resultView;
        [self addSubview:resultView];
    }
    return self;
}

- (void)setResutlDatas:(NSMutableArray *)resutlDatas
{
    _resutlDatas = resutlDatas;
    [self layoutSubviews];
    [self.resultView reloadData];
}

+ (instancetype)searchEnum
{
    return [[BZBaseSearchEnum alloc]init];
}

- (void)showSearchView
{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.center = CGPointMake(kScreenW * 0.5, kScreenH * 0.5);
    self.bounds = CGRectMake(0, 0, kScreenW * 0.5, kScreenH * 0.5);
    self.alpha = 0;
    [window addSubview:self];
    
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.7 animations:^{
            self.bounds = CGRectMake(0, 0, kScreenW * 1.1, kScreenH * 1.1);
            self.alpha = 0.8;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.3 animations:^{
            self.bounds = CGRectMake(0, 0, kScreenW, kScreenH);
            self.alpha = 1;
        }];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 @brief 退出选择
 */
- (void)dismiss
{
    [self endEditing:YES];
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/**
 @brief 初始化搜索条
 */
- (void)setUpToolBar
{
    UITextField *searchTextField = [[UITextField alloc]init];
    searchTextField.textColor = [UIColor grayColor];
    searchTextField.layer.cornerRadius = 5;
    UIView *leftView = [[UIView alloc]init];
    leftView.width = 2;
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.delegate = self;
    self.searchTextField = searchTextField;
    searchTextField.backgroundColor = [UIColor whiteColor];
    [self.toolBar addSubview:searchTextField];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    searchBtn.layer.cornerRadius = 5;
    [searchBtn setTitle:@"收索" forState:UIControlStateNormal];
    self.searchBtn = searchBtn;
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:searchBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 蒙版
    self.coverBtn.frame = self.bounds;
    
    // 搜索条
    self.toolBar.width = self.width - kLREdge * 2;
    self.toolBar.height = kToolBarH;
    self.toolBar.x = kLREdge;
    self.toolBar.y = kTopEdge;
    [self layoutToolBar];
    
    // 搜索结果TableView
    CGFloat tableViewH = self.resutlDatas.count * kTableViewRowH;
    if (tableViewH <= 300) {
        self.resultView.height = tableViewH;
    }
    else
    {
        self.resultView.height = 300;
    }
    self.resultView.width = self.width - kLREdge * 2;
    self.resultView.y = CGRectGetMaxY(self.toolBar.frame) + 10;
    self.resultView.x = kLREdge;
}

/**
 @brief 布局搜索条
 */
- (void)layoutToolBar
{
    self.searchTextField.width = self.toolBar.width - 50;
    self.searchTextField.height = self.toolBar.height;
    
    self.searchBtn.width = 40;
    self.searchBtn.height = self.toolBar.height;
    self.searchBtn.x = CGRectGetMaxX(self.searchTextField.frame) + 10;
}

/**
 @brief 开始搜索
 */
- (void)beginSearch
{
    if ([self.delegate respondsToSelector:@selector(searchEnum:didSearchValue:)]) {
        [self.delegate searchEnum:self didSearchValue:self.searchTextField.text];
    }
}


#pragma mark - 搜索条textField代理协议
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self beginSearch];
    return YES;
}

#pragma mark - 搜索结果TableView的代理及数据源协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"----------%ld",self.resutlDatas.count);
    return self.resutlDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"searchResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = self.resutlDatas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if ([self.delegate respondsToSelector:@selector(searchEnum:didSelectResultValue:andRowNumber:)]) {
        [self.delegate searchEnum:self didSelectResultValue:self.resutlDatas[indexPath.row] andRowNumber:(int)indexPath.row];
    }
     [self dismiss];
}

@end
