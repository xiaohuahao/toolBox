//
//  BZBaseSearchEnum.h
//  工具块
//
//  Created by 尚承教育 on 15/8/16.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BZBaseSearchEnum;

@protocol BZBaseSearchEnumDelegate <NSObject>
/**
 @brief 搜索的内容
 */
- (void)searchEnum:(BZBaseSearchEnum *)searchEnum didSearchValue:(NSString *)searchValue;
/**
 @brief 搜索的结果
 */
- (void)searchEnum:(BZBaseSearchEnum *)searchEnum didSelectResultValue:(NSString *)resultValue andRowNumber:(int)rowNumber;
@end

@interface BZBaseSearchEnum : UIView

/**搜索View代理*/
@property (weak, nonatomic) id <BZBaseSearchEnumDelegate> delegate;

/**搜索结果(Array)*/
@property (strong, nonatomic) NSMutableArray *resutlDatas;

/**
 @brief 创建搜索View
 */
+ (instancetype)searchEnum;

/**
 @brief 显示搜索View
 */
- (void)showSearchView;

/**
 @brief 移除搜索View
 */
- (void)dismiss;

@end
