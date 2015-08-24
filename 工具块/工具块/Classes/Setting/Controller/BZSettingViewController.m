//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "BZSettingViewController.h"
#import "AppDelegate.h"
#import "BZSetCellModel.h"

@interface BZSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *setCellDatas;

@end

@implementation BZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSetCellDatas];
    
    self.view.backgroundColor = BZColor(231, 231, 231, 1);

    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}

- (void)setUpSetCellDatas
{
    BZSetCellModel *autoColor = [BZSetCellModel setCellModelWithTitle:@"随机色" andPushVC:nil];
    autoColor.cellType = BZSettingsCellTypeSwitch;
    self.setCellDatas = @[autoColor];
}




#pragma mark - UITableVeiw Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.setCellDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = BZColor(106, 201, 248, 1);
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = BZColor(106, 136, 248, 1);
        cell.textLabel.textColor = [UIColor whiteColor];
    }

    BZSetCellModel *cellModel = self.setCellDatas[indexPath.row];
    cell.textLabel.text = cellModel.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
