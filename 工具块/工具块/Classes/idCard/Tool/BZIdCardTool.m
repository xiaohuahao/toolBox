//
//  BZIdCardTool.m
//  工具块
//
//  Created by 尚承教育 on 15/8/21.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZIdCardTool.h"
#import "BZIdCardModel.h"

#define kSavePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"idCard.data"]

static NSMutableArray *_historyRcodDatas = nil;

@implementation BZIdCardTool

+ (void)setUpHistroyRcodDatas
{
    _historyRcodDatas = [NSKeyedUnarchiver unarchiveObjectWithFile:kSavePath];
    if (!_historyRcodDatas) {
        _historyRcodDatas = [NSMutableArray array];
    }
}

+ (void)saveRecod:(BZIdCardModel *)idCardModel
{
    [self setUpHistroyRcodDatas];
    for (BZIdCardModel *Model in _historyRcodDatas) {
        if ([idCardModel.idCardNum isEqualToString:Model.idCardNum]) {
            return;
        }
    }
    [_historyRcodDatas addObject:idCardModel];
    [NSKeyedArchiver archiveRootObject:_historyRcodDatas toFile:kSavePath];
}

+ (void)deleteAllRecod
{
    [self setUpHistroyRcodDatas];
    [_historyRcodDatas removeAllObjects];
    [NSKeyedArchiver archiveRootObject:_historyRcodDatas toFile:kSavePath];
}

+ (NSArray *)allRecod
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kSavePath];
}

@end
