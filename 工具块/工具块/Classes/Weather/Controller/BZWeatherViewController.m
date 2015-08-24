
//
//  BZWeatherViewController.m
//  工具块
//
//  Created by 尚承教育 on 15/8/14.
//  Copyright (c) 2015年 SSBun. All rights reserved.
//

#import "BZWeatherViewController.h"
#import "BZHttp.h"
#import "BZWeatherModel.h"
#import "BZWeatherViewBtn.h"
#import "BZBaseSearchEnum.h"
#import "BZWeatherCityModel.h"
#import "MBProgressHUD+MJ.h"
#import "UIViewController+Extension.h"

#define kWeatherSavePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"weather.data"]

#define kLocalToolH 40

@interface BZWeatherViewController ()<BZBaseSearchEnumDelegate>

@property (strong, nonatomic) NSMutableArray   *btnArr;
@property (strong, nonatomic) NSMutableArray   *currentResultCityList;
@property (copy, nonatomic)   NSString         *currentCityID;

@property (strong, nonatomic) BZBaseSearchEnum *searchEnum;
@property (strong, nonatomic) BZWeatherViewBtn *weather;
@property (strong, nonatomic) BZWeatherViewBtn *temperature;
@property (strong, nonatomic) BZWeatherViewBtn *wind;
@property (strong, nonatomic) BZWeatherViewBtn *AQI;
@property (strong, nonatomic) BZWeatherViewBtn *humidity;
@property (strong, nonatomic) BZWeatherViewBtn *UIintensity;

@property (strong, nonatomic) UIButton *localBtn;
@property (strong, nonatomic) UIButton *dateBtn;

@end

static  BZWeatherModel *_lastWeatherModel;

@implementation BZWeatherViewController

- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
    [self addSwipBackGestureGecongnizer];
    if (self.view.backgroundColor == [UIColor whiteColor]) {
        self.view.backgroundColor = [UIColor redColor];
    }
    if (_lastWeatherModel) {
        [self updateWeather:_lastWeatherModel];
        return;
    }
    BZWeatherModel *lastWeatherModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kWeatherSavePath];
    [self loadWeatherDataWithCityId:lastWeatherModel.citycode];
}

/**
 @brief 加载天气
 */
- (void)loadWeatherDataWithCityId:(NSString *)cityId
{
    if (cityId.length == 0) {
        return;
    }
    NSString *htttpUrl = @"http://apis.baidu.com/apistore/weatherservice/cityid";
    NSDictionary *dict = @{@"cityid" : cityId};
    [BZHttp httpGetWithUrl:htttpUrl andParams:dict andSuccess:^(id result) {
    BZWeatherModel *weatherModel = [BZWeatherModel objectWithKeyValues:result[@"retData"]];
        _lastWeatherModel = weatherModel;
        [self updateWeather:weatherModel];
        NSLog(@"%@",weatherModel.city);
    } andFailure:^(NSError *error) {
        NSLog(@"error");
    }];
}

/**
 @brief 更新天气
 */
- (void)updateWeather:(BZWeatherModel *)weatherModel
{
    [MBProgressHUD showSuccess:@"刷新天气成功"];
    self.currentCityID = weatherModel.citycode;
    [self.weather setTitle:weatherModel.weather];
    [self.weather setImage:[self weatherImageNameWithWeather:weatherModel]];
    
    [self.temperature setTitle:[NSString stringWithFormat:@"%.2f-%.2f℃",weatherModel.l_tmp,weatherModel.h_tmp]];
    [self.temperature setIconTitle:[NSString stringWithFormat:@"%.1f",weatherModel.temp]];
    
    [self.wind setTitle:[NSString stringWithFormat:@"%@/%@",weatherModel.WD,weatherModel.WS]];
    
    [self.localBtn setTitle:weatherModel.city forState:UIControlStateNormal];
    [self.dateBtn setTitle:[NSString stringWithFormat:@"发布时间:%@/%@",weatherModel.date,weatherModel.time] forState:UIControlStateNormal];
    
    [self.humidity setTitle:[NSString stringWithFormat:@"日初:%@-日落:%@",weatherModel.sunrise,weatherModel.sunset]];
    [NSKeyedArchiver archiveRootObject:weatherModel toFile:kWeatherSavePath];
}

/**
 @brief 设置UI
 */
- (void)setUpUI
{
    self.weather = [self addChildBtnViewWithImage:@"w0" andIconTitle:nil andTitle:@"---" andTarget:nil andAction:nil];
    self.temperature =  [self addChildBtnViewWithImage:@"" andIconTitle:nil andTitle:@"---" andTarget:nil andAction:nil];
    self.wind =  [self addChildBtnViewWithImage:@"windy_0" andIconTitle:nil andTitle:@"---" andTarget:nil andAction:nil];
    self.AQI = [self addChildBtnViewWithImage:@"pm25_5" andIconTitle:nil andTitle:@"---" andTarget:nil andAction:nil];
    self.humidity = [self addChildBtnViewWithImage:@"ray_100" andIconTitle:nil andTitle:@"---" andTarget:nil andAction:nil];
    self.UIintensity =  [self addChildBtnViewWithImage:@"w5" andIconTitle:nil andTitle:@"---" andTarget:nil andAction:nil];
    [self layoutBtnView];
    
    [self setUpToolBar];
}

/**
 @brief 设置工具栏
 */
- (void)setUpToolBar
{
    UIView *toolBar = [[UIView alloc]init];
    toolBar.width = self.view.width;
    toolBar.height = 30;
    [self.view addSubview:toolBar];
    
    UIButton *localBtn = [[UIButton alloc]init];
    localBtn.width = 50;
    localBtn.height = 30;
    localBtn.x = toolBar.width - localBtn.width - 10;
    localBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [localBtn setImage:[UIImage imageNamed:@"location_donate"] forState:UIControlStateNormal];
    [localBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    localBtn.contentMode = UIViewContentModeLeft;
    localBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.localBtn = localBtn;
    [toolBar addSubview:localBtn];
    
    UIButton *dateBtn = [[UIButton alloc]init];
    [dateBtn setImage:[UIImage imageNamed:@"category_normal"] forState:UIControlStateNormal];
    dateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    dateBtn.width = 200;
    dateBtn.height = toolBar.height;
    self.dateBtn = dateBtn;
    [dateBtn addTarget:self action:@selector(clickDateBtn) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:dateBtn];
}

/**
 @brief 点击发布时间更新天气
 */
- (void)clickDateBtn
{
    [self loadWeatherDataWithCityId:self.currentCityID];
}

/**
 @brief 切换城市
 */
- (void)selectCity
{
    BZBaseSearchEnum *searchEnum = [BZBaseSearchEnum searchEnum];
    self.searchEnum = searchEnum;
    searchEnum.delegate = self;
    [searchEnum showSearchView];
}

/**
 @brief 根据天气转图片名
 */
- (NSString *)weatherImageNameWithWeather:(BZWeatherModel *)weatherMdoel
{
    if ([weatherMdoel.weather isEqualToString:@"晴"]) {
        return @"w0";
    }
    if ([weatherMdoel.weather isEqualToString:@"阵雨"]) {
        return @"w6";
    }
    if ([weatherMdoel.weather isEqualToString:@"雷阵雨"]) {
        return @"w4";
    }
    if ([weatherMdoel.weather isEqualToString:@"多云"]) {
        return @"w2";
    }
    return @"w0";
}

/**
 @brief 添加按钮
 */
-(BZWeatherViewBtn *)addChildBtnViewWithImage:(NSString *)imageName andIconTitle:(NSString *)iconTitle andTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action
{
    BZWeatherViewBtn *btn = [BZWeatherViewBtn weatherViewBtn];
    [btn setImage:imageName];
    [btn setTitle:title];
    [btn setIconTitle:iconTitle];
    [btn addTarget:target andAction:action];
    [self.view addSubview:btn];
    [self.btnArr addObject:btn];
    return btn;
}

/**
 @brief 布局按钮
 */
- (void)layoutBtnView
{
    CGFloat btnW = self.view.width / 2;
    CGFloat btnH = (self.view.height - kLocalToolH) / 3;
    int maxCol = 2;
    for (int i = 0; i < self.btnArr.count; i ++) {
        NSLog(@"-------%d",i);
        BZWeatherViewBtn *btn = self.btnArr[i];
        int col = i % maxCol;
        int row = i / maxCol;
        btn.width = btnW;
        btn.height = btnH;
        btn.x = col * btnW;
        btn.y = row * btnH + kLocalToolH;
    }
}

#pragma mark - BZBaseSearchEnum代理

- (void)searchEnum:(BZBaseSearchEnum *)searchEnum didSearchValue:(NSString *)searchValue
{
    NSDictionary *params = @{@"cityname" : searchValue};
    [BZHttp httpGetWithUrl:@"http://apis.baidu.com/apistore/weatherservice/citylist" andParams:params andSuccess:^(id result) {
        NSArray *tempArr = [BZWeatherCityModel objectArrayWithKeyValuesArray:result[@"retData"]];
        self.currentResultCityList = [NSMutableArray array];
        self.currentResultCityList = [NSMutableArray arrayWithArray:tempArr];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [tempArr enumerateObjectsUsingBlock:^(BZWeatherCityModel *obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"%@",obj.name_cn);
            NSString *str = [NSString stringWithFormat:@"%@-%@-%@",obj.province_cn,obj.district_cn,obj.name_cn];
            [mutableArr addObject:str];
        }];
        self.searchEnum.resutlDatas = mutableArr;
    } andFailure:^(NSError *error) {
        NSLog(@"没有搜索到城市");
    }];
    [searchEnum resignFirstResponder];
}

- (void)searchEnum:(BZBaseSearchEnum *)searchEnum didSelectResultValue:(NSString *)resultValue andRowNumber:(int)rowNumber
{
    BZWeatherCityModel *cityModel = self.currentResultCityList[rowNumber];
    [self loadWeatherDataWithCityId:cityModel.area_id];
}

@end