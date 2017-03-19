//
//  MTMapViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 19/03/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "MTMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "UIBarButtonItem+Extension.h"

//#import "UIBarButtonItem+Extension.h"


#import "DKHomeTopItem.h"
#import "DKConst.h"
#import "DKCategoryViewController.h"
#import "DKCategoryModel.h"
#import "MTDealAnnotation.h"
#import "DKDeal.h"
#import "MJExtension.h"
#import "MTBusiness.h"
@interface MTMapViewController ()<MKMapViewDelegate,DPRequestDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/**
 可用于地理位置信息的转换
 */
@property (nonatomic, strong) CLGeocoder *coder;

/**
 城市名称
 */
@property (nonatomic, copy) NSString *city;


/** 分类item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;

/**
 选中的分类名称
 */
@property (nonatomic, copy) NSString *selectedCategoryName;

/**区分请求对象 */
@property (nonatomic, strong) DPRequest *lastRequest;

@property (nonatomic ,strong) CLLocationManager *mgr;

@end


@implementation MTMapViewController





/**
 懒加载coder 对象

 @return coder
 */
- (CLGeocoder *)coder
{
    if (_coder == nil) {
        self.coder = [[CLGeocoder alloc] init];
    }
    return _coder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
//    CLLocationManager *locManager = [[CLLocationManager alloc]init];
//    [locManager requestAlwaysAuthorization];
//    self.mapView.
    
    
    // 左边的返回
    
     UIBarButtonItem *backItem= [UIBarButtonItem barButtonItemWithTarget:self Image:@"icon_back" highlightedImage:@"icon_back_highlighted" actionMethod:@selector(back)];

    
    // 标题
    self.title = @"地图";
    
    // 设置地图跟踪用户的位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 设置左上角的分类菜单
    DKHomeTopItem *categoryTopItem = [DKHomeTopItem homeTopItem];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    // 监听分类改变    用户从服务器获取数据
//    [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidChange:) name:DKdidClickCategoryTableNotification object:nil];
    
    
    
    
    // 判断是否是iOS8
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        NSLog(@"是iOS8");
        // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        //
        [self.mgr requestAlwaysAuthorization]; // 请求前台和后台定位权限
        //        [self.mgr requestWhenInUseAuthorization];// 请求前台定位权限
    }else
    {
        NSLog(@"是iOS7");
        // 3.开始监听(开始获取位置)
        [self.mgr startUpdatingLocation];
    }

}

#pragma mark - 懒加载
- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

/**
 跳转到分类控制器
 */
- (void)categoryClick
{    // 显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[DKCategoryViewController alloc] init]];
    
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


/**
 根据用户选择的列别，从服务器获取数据

 */
- (void)categoryDidChange:(NSNotification *)notification
{
    // 1.关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 2.获得要发送给服务器的类型名称
    
    NSString *title = [notification userInfo][DKdidClickCategoryTableNotificationInfoTitleKey];
    NSString *subtitle = [notification userInfo][DKdidClickCategoryTableNotificationInfosubTitleKey];
    DKCategoryModel *model = [notification userInfo][DKdidClickCategoryTableNotificationInfoModelKey];
    
//    DKCategoryModel *category = notification.userInfo[MTSelectCategory];
//    NSString *subcategoryName = notification.userInfo[MTSelectSubcategoryName];
    
    
   
    //2.1.设置当前选中的分类
    if([title isEqualToString:@"全部分类"]){
        //        self.selectedRegion = self.selectedCityName;
        self.selectedCategoryName = nil;
    }
    
    else  if ([subtitle isEqualToString:@"" ] || subtitle == nil || ([subtitle isEqualToString:@"全部"])) {
        self.selectedCategoryName = title;
    }else{
        self.selectedCategoryName = subtitle;
    }
    
    
    
    
//    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) { // 点击的数据没有子分类
//        self.selectedCategoryName = category.name;
//    } else {
//        self.selectedCategoryName = subcategoryName;
//    }
//    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
//        self.selectedCategoryName = nil;
//    }
    
    // 3.删除之前的所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 4.重新发送请求给服务器
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
    // 5.更换顶部item的文字
    DKHomeTopItem *topItem = (DKHomeTopItem *)self.categoryItem.customView;//DKHomeTopItem 的获取
    // 设置 DKHomeTopItem的属性
//    DKHomeTopItem *topItem = (DKHomeTopItem*) self.categoryItem.customView;
    topItem.title = title;
    topItem.subTitle = subtitle;
    [topItem setIcon:model.icon hightIcon:model.highlighted_icon];
//    [topItem setIcon: highIcon:];
//    [topItem setIcon:category.icon hightIcon:category.highlighted_icon];
//    [topItem setTitle:category.name];
//    [topItem setSubtitle:subcategoryName];
    
    
}



- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - MKMapViewDelegate
/**
 * 当用户的位置更新了就会调用一次
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 让地图显示到用户所在的位置
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];
    
    // 经纬度 --> 城市名 : 反地理编码
    // 城市名 --> 经纬度 : 地理编码
    [self.coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        
        if (error || placemarks.count == 0) return;
        
        CLPlacemark *pm = [placemarks firstObject];
        //城市优先从CLPlacemark 的locality 获取，如果获取不到再从addressDictionary[@"State"] 获取
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"State"];
        self.city = [city substringToIndex:city.length - 1];//去掉市-- 最后一个字符
        
        // 第一次发送请求给服务器， 获取新的团购数据
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}




- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.city == nil) return;
    
    // 发送请求给服务器
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 城市
    params[@"city"] = self.city;
    // 类别
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    // 经纬度
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}


#pragma mark - ******** 自定义大头针

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MTDealAnnotation *)annotation
{
    // 返回nil,意味着交给系统处理
    if (![annotation isKindOfClass:[MTDealAnnotation class]]) return nil;
    
    // 创建大头针控件
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    
    // 设置模型(位置\标题\子标题)
    annoView.annotation = annotation;
    
    // 设置图片
    annoView.image = [UIImage imageNamed:annotation.icon];
    
    return annoView;
}

#pragma mark - 请求代理
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) return;
    
    NSLog(@"请求失败 - %@", error);
}

#pragma mark - ******** 根据请求返回的团购数据，进行地图的MTDealAnnotation 添加

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    
    //获取服务器模型
    NSArray *deals = [DKDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (DKDeal *deal in deals) {
//        self.mapView annotations
        // 获得团购所属的类型
        DKCategoryModel *category = [DKHomeModelTool categoryWithDeal:deal];//目的是为了获取map_icon
        
        // 展示店铺信息
        for (MTBusiness *business in deal.businesses) {
            MTDealAnnotation *anno = [[MTDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;// 店铺名称
            anno.subtitle = deal.title;//团购标题
            anno.icon = category.map_icon;//团购的列别图标
            NSLog(@"category.map_icon-- %@",category.map_icon);
            if ([self.mapView.annotations containsObject:anno]) break;
            [self.mapView addAnnotation:anno];//修改模型
        }
    }
}

@end
