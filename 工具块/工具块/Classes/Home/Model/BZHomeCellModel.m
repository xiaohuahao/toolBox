//
//  BZHomeCellModel.m
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZHomeCellModel.h"

@implementation BZHomeCellModel

+ (instancetype)homeCellModelWith:(NSString *)title andPushVCClassName:(NSString *)pushVCClassName
{
    BZHomeCellModel *homeCellModel = [[BZHomeCellModel alloc]init];
    homeCellModel.title = title;
    homeCellModel.pushVCClassName = pushVCClassName;
    return homeCellModel;
}

MJCodingImplementation
@end
