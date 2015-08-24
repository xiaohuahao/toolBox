//
//  BZSetCellModel.m
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZSetCellModel.h"

@implementation BZSetCellModel

+ (instancetype)setCellModelWithTitle:(NSString *)title andPushVC:(Class)pushVC
{
    BZSetCellModel *cellModel = [[BZSetCellModel alloc]init];
    cellModel.title = title;
    cellModel.pushVC = pushVC;
    return cellModel;
}

@end
