//
//  BZIdCardHistoryRecodView.m
//  工具块
//
//  Created by 尚承教育 on 15/8/21.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZIdCardHistoryRecodView.h"
#import "BZIdCardTool.h"
#import "BZIdCardModel.h"

@interface BZIdCardHistoryRecodView ()<UITableViewDataSource,UITableViewDelegate>

//记录view
@property (strong, nonatomic) UITableView *recodView;
//清除历史记录按钮
@property (strong, nonatomic) UIButton    *deleteBtn;

@property (strong, nonatomic) NSMutableArray *historyRecodDatas;

@end


@implementation BZIdCardHistoryRecodView

- (NSMutableArray *)historyRecodDatas
{
  return  _historyRecodDatas = [NSMutableArray arrayWithArray:[BZIdCardTool allRecod]];
}

+ (instancetype)idCardHistroyRecodView
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 4;
        
        _recodView = [[UITableView alloc]init];
        _recodView.rowHeight =   30;
        _recodView.delegate = self;
        _recodView.dataSource = self;
        _recodView.layer.cornerRadius = 4;
        [self addSubview:_recodView];
        
        _deleteBtn = [[UIButton alloc]init];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.layer.cornerRadius = 4;
        [_deleteBtn setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteRecod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        
    }
    return self;
}

/**
 @brief 清除历史记录
 */
- (void)deleteRecod
{
    [BZIdCardTool deleteAllRecod];
    [self reloadValue];
}

/**
 @brief 刷新数据
 */
- (void)reloadValue
{
    [self.recodView reloadData];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.recodView.width = self.width;
    self.recodView.height = self.historyRecodDatas.count * 30;
    
    self.deleteBtn.width = 150;
    self.deleteBtn.height  =30;
    self.deleteBtn.x = (self.width - self.deleteBtn.width) / 2;
    self.deleteBtn.y = CGRectGetMaxY(self.recodView.frame) + 10;
    
    self.height = CGRectGetMaxY(self.deleteBtn.frame) + 10;
}

#pragma mark - recodVeiw的UITableViewDelegate 和 UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.historyRecodDatas.count == 0)
    {
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
    }
    return self.historyRecodDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"idCardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    BZIdCardModel *idCardModel = self.historyRecodDatas[indexPath.row];
    cell.textLabel.text = idCardModel.idCardNum;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    BZIdCardModel *idCardModel = self.historyRecodDatas[indexPath.row];
    if ([self.recodDelegate respondsToSelector:@selector(idCardHistoryRecodView:didClickCell:)]) {
        [self.recodDelegate idCardHistoryRecodView:self didClickCell:idCardModel];
    }
}



@end
