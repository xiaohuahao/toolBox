//
//  BZIdCardResultView.m
//  工具块
//
//  Created by 尚承教育 on 15/8/17.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZIdCardResultView.h"

@interface BZIdCardResultView ()
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@end


@implementation BZIdCardResultView

- (void)setSex:(NSString *)sex
{
    self.sexLabel.text = sex;
}

- (void)setBirthday:(NSString *)birthday
{
    self.birthdayLabel.text = birthday;
}

- (void)setAddress:(NSString *)address
{
    self.adressLabel.text = address;
}

+ (instancetype)idCardResultView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BZIdCardResultView" owner:nil options:nil] lastObject];
}

@end
