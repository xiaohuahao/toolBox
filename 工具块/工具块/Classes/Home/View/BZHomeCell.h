//
//  BZHomeCell.h
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZHomeCell : UITableViewCell

+ (instancetype)homeCellWithTable:(UITableView *)tableView;
- (void)SetHomeCellTitle:(NSString *)title;

@end
