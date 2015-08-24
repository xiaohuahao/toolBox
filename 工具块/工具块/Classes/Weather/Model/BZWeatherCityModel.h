//
//  BZWeatherCityModel.h
//  工具块
//
//  Created by 尚承教育 on 15/8/16.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZWeatherCityModel : NSObject

/**省*/
@property (copy, nonatomic) NSString *province_cn;

/**市*/
@property (copy, nonatomic) NSString *district_cn;

/**县*/
@property (copy, nonatomic) NSString *name_cn;

/**收索拼音*/
@property (copy, nonatomic) NSString *name_en;

/**地点编号*/
@property (copy, nonatomic) NSString *area_id;

@end
