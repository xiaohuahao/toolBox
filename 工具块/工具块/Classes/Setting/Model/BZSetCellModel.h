//
//  BZSetCellModel.h
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    BZSettingsCellTypeArror, //跳转
    BZSettingsCellTypeSwitch //选择
}BZSettingsCellType;


@interface BZSetCellModel : NSObject

@property (copy, nonatomic) NSString *title;

@property (assign, nonatomic) Class pushVC;


/**当前cell的颜色*/
@property (strong, nonatomic) UIColor *cellColor;

/**cell种类*/
@property (assign, nonatomic) BZSettingsCellType cellType;

+ (instancetype)setCellModelWithTitle:(NSString *)title andPushVC:(Class)pushVC;

@end
