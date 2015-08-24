//
//  BZHomeCellModel.h
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZHomeCellModel : NSObject

/**目标控制器类名*/
@property (copy, nonatomic) NSString *pushVCClassName;

/**目标控制器名*/
@property (copy, nonatomic) NSString *title;


+ (instancetype)homeCellModelWith:(NSString *)title andPushVCClassName:(NSString *)pushVCClassName;

@end
