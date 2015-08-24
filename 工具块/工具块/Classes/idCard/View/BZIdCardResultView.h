//
//  BZIdCardResultView.h
//  工具块
//
//  Created by 尚承教育 on 15/8/17.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZIdCardResultView : UIView

+ (instancetype)idCardResultView;

- (void)setSex:(NSString *)sex;
- (void)setBirthday:(NSString *)birthday;
- (void)setAddress:(NSString *)address;

@end
