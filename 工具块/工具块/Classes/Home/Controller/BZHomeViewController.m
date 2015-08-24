//
//  BZHomeViewController.m
//  工具块
//
//  Created by 尚承教育 on 15/8/10.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZHomeViewController.h"
#import "BZHttp.h"
#import "BZWeatherModel.h"
#import "MJExtension.h"
#import "BZHomeCell.h"
#import "BZHomeCellModel.h"

#import "BZWeatherViewController.h"
#import "BZIdCardViewController.h"
#import "BZBTGirlViewController.h"
#import "BZShareViewController.h"

#define kHomeCellsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"homeCell.data"]

@interface BZHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 主页tableView
 */
@property (strong, nonatomic) UITableView *homeTableView;

/*
 功能模块Cell数组
 */
@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation BZHomeViewController


- (NSMutableArray *)cells
{
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpCells];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor grayColor];
}

// 初始化功能模块数据
- (void)setUpCells
{
    NSArray *tempArr = [NSKeyedUnarchiver unarchiveObjectWithFile:kHomeCellsPath];
    if (tempArr == nil) {
        BZHomeCellModel *weatherCell = [BZHomeCellModel homeCellModelWith:@"天气" andPushVCClassName:NSStringFromClass([BZWeatherViewController class])];
        BZHomeCellModel *idCardCell = [BZHomeCellModel homeCellModelWith:@"身份证" andPushVCClassName:NSStringFromClass([BZIdCardViewController class])];
        BZHomeCellModel *btGirlCell = [BZHomeCellModel homeCellModelWith:@"美女" andPushVCClassName:NSStringFromClass([BZBTGirlViewController class])];
        BZHomeCellModel *shareCell = [BZHomeCellModel homeCellModelWith:@"分享" andPushVCClassName:NSStringFromClass([BZShareViewController class])];
        NSArray *cellsArr = @[weatherCell,idCardCell,btGirlCell,shareCell];
        self.cells = [NSMutableArray arrayWithArray:cellsArr];
        [NSKeyedArchiver archiveRootObject:cellsArr toFile:kHomeCellsPath];
    }
    else
    {
        self.cells = [NSMutableArray arrayWithArray:tempArr];
    }
    
}


- (void)setUpTableView
{
    UITableView *homeTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    homeTableView.backgroundColor = BZColor(231, 231, 231, 1);
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeTableView = homeTableView;
    [self.view addSubview:homeTableView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [homeTableView addGestureRecognizer:longPress];
}

#pragma mark - UITableViewDelegate - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZHomeCell *cell = [BZHomeCell homeCellWithTable:tableView];
    BZHomeCellModel *cellModel = self.cells[indexPath.row];
    [cell SetHomeCellTitle:cellModel.title];
    cell.backgroundColor = BZRandomColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
    selCell.selected = NO;
    BZHomeCellModel *cellModel = self.cells[indexPath.row];
    Class pushVCClass = NSClassFromString(cellModel.pushVCClassName);
    UIViewController *viewController = [[pushVCClass alloc]init];
    viewController.view.backgroundColor = selCell.backgroundColor;
    [self.navigationController pushViewController:viewController animated:YES];
}

/**@brief 长按手势调换cell位置 */
- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.homeTableView];
    NSIndexPath *indexPath = [self.homeTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.homeTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.homeTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.cells exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.homeTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.homeTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
    
    [NSKeyedArchiver archiveRootObject:self.cells toFile:kHomeCellsPath];
    
}

/**@brief 生成Cell快照*/
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
