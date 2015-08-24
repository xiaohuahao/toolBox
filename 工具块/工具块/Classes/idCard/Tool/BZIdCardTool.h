//
//  BZIdCardTool.h
//  工具块
//
//  Created by 尚承教育 on 15/8/21.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BZIdCardModel;
@interface BZIdCardTool : NSObject

/**
@brief 储存记录
*/
+ (void)saveRecod:(BZIdCardModel *)idCardModel;
/**
@brief 删除所有记录
*/
+ (void)deleteAllRecod;
/**
@brief 取出所有记录
*/
+ (NSArray *)allRecod;

@end
