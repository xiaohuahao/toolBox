//
//  BZHomeCell.m
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZHomeCell.h"

@interface BZHomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@end


@implementation BZHomeCell


+ (instancetype)homeCellWithTable:(UITableView *)tableView
{
    static NSString *ID = @"homeCell";
    
    BZHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"BZHomeCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

- (void)SetHomeCellTitle:(NSString *)title
{
    self.tagLabel.text = title;
}

@end
