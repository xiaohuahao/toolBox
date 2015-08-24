//
//  BZWeatherModel.h
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZWeatherModel : NSObject

/**城市*/
@property (copy, nonatomic) NSString *city;

/**城市拼音*/
@property (copy, nonatomic) NSString *pinyin;

/**城市编码*/
@property (copy, nonatomic) NSString *citycode;

/**日期*/
@property (copy, nonatomic) NSString *date;

/**时间*/
@property (copy, nonatomic) NSString *time;

/**邮编*/
@property (copy, nonatomic) NSString *postCode;

/**经度*/
@property (assign, nonatomic) CGFloat longitude;

/**维度*/
@property (assign, nonatomic) CGFloat latitude;

/**高度*/
@property (copy, nonatomic) NSString *altitude;

/**天气*/
@property (copy, nonatomic) NSString *weather;

/**气温*/
@property (assign, nonatomic) CGFloat temp;

/**最低气温*/
@property (assign, nonatomic) CGFloat l_tmp;

/**最高气温*/
@property (assign, nonatomic) CGFloat h_tmp;

/**风向*/
@property (copy, nonatomic) NSString *WD;

/**风速*/
@property (copy, nonatomic) NSString *WS;

/**日初时间*/
@property (copy, nonatomic) NSString *sunrise;

/**日落时间*/
@property (copy, nonatomic) NSString *sunset;

@end
