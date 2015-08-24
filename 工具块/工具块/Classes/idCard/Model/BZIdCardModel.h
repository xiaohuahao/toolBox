//
//  BZIdCardModel.h
//  工具块
//
//  Created by 尚承教育 on 15/8/17.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZIdCardModel : NSObject

/**性别*/
@property (copy, nonatomic) NSString *sex;

/**出生日期*/
@property (copy, nonatomic) NSString *birthday;

/**地址*/
@property (copy, nonatomic) NSString *address;

/**身份证号*/
@property (copy, nonatomic) NSString *idCardNum;

@end
