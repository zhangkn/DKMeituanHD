//
//  DKHomeCollectionViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 03/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//


#import "DKHomeCollectionViewController.h"
#import "AwesomeMenu.h"
#import "DKHomeTopItem.h"

#import "DKCategoryViewController.h"
#import "DKHomeAddressViewController.h"
#import "DKHomeSortViewController.h"

#import "DKHomeSortModel.h"
#import "DKCategoryModel.h"
#import "DKRecentCollectionViewController.h"
#import "DKCollectCollectionViewController.h"
#import "MTMapViewController.h"
@interface DKHomeCollectionViewController ()<AwesomeMenuDelegate>

/** 地区*/
@property (nonatomic,strong) UIBarButtonItem *addressItem;
/**
 *分类
 */
@property (nonatomic,strong) UIBarButtonItem *categoryItem;

/**
 *排序
 */
@property (nonatomic,strong) UIBarButtonItem *sortItem;
/**
 *当前选中的城市名称
 */
@property (nonatomic,copy) NSString *selectedCityName;

/**
 选中的排序模型
 */
@property (nonatomic,strong) DKHomeSortModel *selectedDKHomeSortModel;

/**
 选中的分类
 */
@property (nonatomic,copy) NSString *selectedCategory;

/**
 选中的区域
 */
@property (nonatomic,copy) NSString *selectedRegion;


/**
  区域的 UIPopoverController
 */
@property (nonatomic,strong) UIPopoverController *addressUIPopoverController;

/**
  排序的UIPopoverController
 */
@property (nonatomic,strong) UIPopoverController *homeSortViewControllerUIPopoverController;



//AwesomeMenu
@property (nonatomic,weak) AwesomeMenu *awesomeMenu;

@end

@implementation DKHomeCollectionViewController

- (UIBarButtonItem *)categoryItem{
    if (nil == _categoryItem) {
        DKHomeTopItem *tmpItemView = [DKHomeTopItem homeTopItem];
        
        [tmpItemView setIcon:@"icon_district" hightIcon:@"icon_district_highlighted"];

        //设置监听器
        [tmpItemView addTarget:self action:@selector(clickCategoryItem)];
        
        
        UIBarButtonItem *tmpView =  [[UIBarButtonItem alloc]initWithCustomView:tmpItemView];
        _categoryItem = tmpView;
    }
    return _categoryItem;
}

- (UIBarButtonItem *)sortItem{
    if (nil == _sortItem) {
        DKHomeTopItem *tmpItemView = [DKHomeTopItem homeTopItem];
        tmpItemView.title = @"排序";
        [tmpItemView setIcon:@"icon_sort" hightIcon:@"icon_sort_highlighted"];
        if (self.selectedDKHomeSortModel == nil) {
            self.selectedDKHomeSortModel = [[DKHomeSortModel alloc]init];
            self.selectedDKHomeSortModel.label = @"默认排序";
            self.selectedDKHomeSortModel.value = @"1";
            
            tmpItemView.subTitle =self.selectedDKHomeSortModel.label;
            
        }
        //设置监听器
        [tmpItemView addTarget:self action:@selector(clickSortItem)];
        
        UIBarButtonItem *tmpView =  [[UIBarButtonItem alloc]initWithCustomView:tmpItemView];
        _sortItem = tmpView;
    }
    return _sortItem;
}


- (UIBarButtonItem *)addressItem{
    if (nil == _addressItem) {
        DKHomeTopItem *addressItemView = [DKHomeTopItem homeTopItem];
        [addressItemView setIcon:@"icon_district" hightIcon:@"icon_district_highlighted"];

        //设置监听器
        [addressItemView addTarget:self action:@selector(clickAddressItem)];
        UIBarButtonItem *tmpView =  [[UIBarButtonItem alloc]initWithCustomView:addressItemView];
        if (self.selectedCityName == nil) {
            self.selectedCityName = @"长沙";
            
        }
        //设置默认的城市信息
        NSString *title =  [NSString stringWithFormat:@"%@ - 全部",self.selectedCityName];

        [self setTopItemTitle:addressItemView title:title subTitle:@""];
        _addressItem = tmpView;
    }
    return _addressItem;
}

- (void) setTopItemTitle :(DKHomeTopItem*) topItem title :(NSString*)title subTitle:(NSString*)subtitle{
    topItem.title =title;
    topItem.subTitle = subtitle;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.构件导航栏
    [self setupRightNav];
    [self setupLeftNav];
    //2.监听条件的改变
    [self setupaddObserver];
    //3. 构件AwesomeMenu.h
    [self setupAwesomeMenu];
   

}
#pragma mark - ********  AwesomeMenuDelegate <NSObject>

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    
    //处理item的点击事件
    
    
    switch (idx) {
        case 0:
            [self clickCollect];
            break;
        case 3:
            [self clickRecent];
            break;
            
        default:
            
            break;
    }
    
//    menu.alpha = 0.5;
//    [menu setContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]];
    [self awesomeMenuWillAnimateClose:menu];
    
}


#pragma mark - ******** 处理搜索框的点击事件

- (void)clickCollect{
    
    //    控制器跳转
    DKCollectCollectionViewController *vc = [[DKCollectCollectionViewController alloc]init];
    DKNavigationViewController *nav = [[DKNavigationViewController alloc]initWithRootViewController:vc];
//    vc.selectedCityName = self.selectedCityName;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)clickRecent{
    
    //    控制器跳转
    DKRecentCollectionViewController *vc = [[DKRecentCollectionViewController alloc]init];
    DKNavigationViewController *nav = [[DKNavigationViewController alloc]initWithRootViewController:vc];
//    vc.selectedCityName = self.selectedCityName;
    [self presentViewController:nav animated:YES completion:nil];
    
}



- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu{
    
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu{
    
}
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu{
    menu.alpha = 1;
    [menu setContentImage:[UIImage imageNamed:@"icon_pathMenu_cross_normal"]];
    
}
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu{
    menu.alpha = 0.5;
    [menu setContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]];
}

#pragma mark - ******** setupAwesomeMenu

- (void)setupAwesomeMenu{
//    AwesomeMenu *
    
    self.awesomeMenu.alpha = 0.5;
    // 设置菜单的活动范围
    self.awesomeMenu.menuWholeAngle = M_PI_2;
    // 设置开始按钮的位置
    self.awesomeMenu.startPoint = CGPointMake(50, 150);
    // 设置代理
    self.awesomeMenu.delegate = self;
    // 不要旋转中间按钮
    self.awesomeMenu.rotateAddButton = NO;
    // 设置菜单永远在左下角 frame
    [self.awesomeMenu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.awesomeMenu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.awesomeMenu autoSetDimensionsToSize:CGSizeMake(200, 200)];
}

- (AwesomeMenu *)awesomeMenu{
    if (nil == _awesomeMenu) {
        
        CGRect frame =CGRectZero;
//        AwesomeMenuItem *itme = [[AwesomeMenuItem alloc ]initWithImage:[UIImage imageNamed:@""] highlightedImage:[UIImage imageNamed:@""]];
        
        AwesomeMenuItem *itme = [[AwesomeMenuItem alloc ]initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_cross_highlighted"]] ;

                                 //收藏
        AwesomeMenuItem *itme0 = [[AwesomeMenuItem alloc ]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]] ;
        
        AwesomeMenuItem *itme1 = [[AwesomeMenuItem alloc ]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]] ;
        
        AwesomeMenuItem *itme2 = [[AwesomeMenuItem alloc ]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]] ;
        
        AwesomeMenuItem *itme3 = [[AwesomeMenuItem alloc ]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]] ;

        
        NSArray *Menus = @[itme0,itme1,itme2,itme3];
        
        AwesomeMenu *tmpView = [[AwesomeMenu alloc]initWithFrame:frame startItem:itme optionMenus:Menus];
        _awesomeMenu = tmpView;
        
        [self.view addSubview:_awesomeMenu];
    }
    return _awesomeMenu;
}

/**
 监听条件的改变
 */
- (void)setupaddObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityNotification:) name:DKdidSelectCityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickSortButonNotification:) name:DKdidClickSortButonNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickCategoryTableNotification:) name:DKdidClickCategoryTableNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickCityTableTableNotification:) name:DKdidClickCityTableTableNotification object:nil];
}




/**
 监听用户选中城市

 @param notification 通知
 */
- (void)didClickCityTableTableNotification:(NSNotification*)notification{
    NSString *title = [notification userInfo][DKdidClickCityTableTableNotificationInfoTitleKey];
    NSString *subtitle = [notification userInfo][DKdidClickCityTableTableNotificationInfoSubTitleKey];
    
    DKHomeTopItem *topItem = (DKHomeTopItem*) self.addressItem.customView;
    topItem.title = [NSString stringWithFormat:@"%@ -%@",self.selectedCityName,title];
    topItem.subTitle = subtitle;
    if([title isEqualToString:@"全部"]){
//        self.selectedRegion = self.selectedCityName;
        self.selectedRegion = nil;
    }
   else  if ([subtitle isEqualToString:@"" ] || subtitle == nil || ([subtitle isEqualToString:@"全部"])) {
        self.selectedRegion = title;
    }else{
        self.selectedRegion = subtitle;
    }
    //    self.selectedDKHomeSortModel = subtitle;
    //进行数据的更新（请求后台）
    [self loadNewDeals];//http://api.dianping.com/v1/deal/find_deals

}

- (void)didClickCategoryTableNotification:(NSNotification*)notification{
    NSString *title = [notification userInfo][DKdidClickCategoryTableNotificationInfoTitleKey];
    NSString *subtitle = [notification userInfo][DKdidClickCategoryTableNotificationInfosubTitleKey];
    DKCategoryModel *model = [notification userInfo][DKdidClickCategoryTableNotificationInfoModelKey];

    
    DKHomeTopItem *topItem = (DKHomeTopItem*) self.categoryItem.customView;
    topItem.title = title;
    topItem.subTitle = subtitle;
    if([title isEqualToString:@"全部分类"]){
        //        self.selectedRegion = self.selectedCityName;
        self.selectedCategory = nil;
    }

  else  if ([subtitle isEqualToString:@"" ] || subtitle == nil || ([subtitle isEqualToString:@"全部"])) {
        self.selectedCategory = title;
    }else{
        self.selectedCategory = subtitle;
    }
    
    
    [topItem setIcon:model.icon hightIcon:model.highlighted_icon];

//    self.selectedDKHomeSortModel = subtitle;
    //进行数据的更新（请求后台）
    [self loadNewDeals];//http://api.dianping.com/v1/deal/find_deals
}


/**
 *监听点击排序的通知
 */
- (void)didClickSortButonNotification:(NSNotification*)notification{
    DKHomeSortModel *model = [notification userInfo][DKdidClickSortButonNotificationValueKey];
    DKHomeTopItem *topItem = (DKHomeTopItem*) self.sortItem.customView;
    topItem.subTitle = model.label;
#warning 设置选中的类别数据
    self.selectedDKHomeSortModel = model;
    //进行数据的更新（请求后台）
    [self loadNewDeals];//http://api.dianping.com/v1/deal/find_deals
}






/**
 *监听城市的改变
 */
#pragma mark -  *监听城市的改变

- (void)didSelectCityNotification:(NSNotification*)notification{
    NSString *cityname = notification.userInfo[DKdidSelectCityNotificationKey];
    self.selectedCityName = cityname;
    //更新城市下拉单数据
    DKHomeTopItem *cityItem =(DKHomeTopItem*) [self.addressItem customView];
    cityItem.title = [NSString stringWithFormat:@"%@ - 全部",cityname];

//    [self showCitydata];
    cityItem.subTitle = @"";
    //获取服务器新数据
    [self.addressUIPopoverController dismissPopoverAnimated:YES];
    //刷新表格数据（下拉菜单）
    [self loadNewDeals];
    
}

#pragma mark - 注销监听者
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *设置左边的items
 */
- (void)setupLeftNav{
    UIImage *logoImage = [[UIImage imageNamed:@"icon_meituan_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//不被渲染
        UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithImage:logoImage style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    
   
//    searchItem.customView.width = 60;

    self.navigationItem.leftBarButtonItems = @[logoItem, self.categoryItem,self.addressItem,self.sortItem];

    
    
}

#pragma mark - ******** 点击顶部的bar

/**
 点击排序bar
 */
- (void)clickSortItem{
    
    
    DKHomeSortViewController *homeSortViewController = [[DKHomeSortViewController alloc]init];
    
    self.homeSortViewControllerUIPopoverController = [[UIPopoverController alloc]initWithContentViewController:homeSortViewController];
    [self.homeSortViewControllerUIPopoverController presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)clickAddressItem{
    
    DKHomeAddressViewController *homeAddressViewController = [[DKHomeAddressViewController alloc]init];
    //获取当前定位（选中）城市的区域
//    homeAddressViewController.selectedRegions = [DKHomeModelTool searchRegionsWithCityName:self.selectedCityName];
    
    self.addressUIPopoverController = [[UIPopoverController alloc]initWithContentViewController:homeAddressViewController];
    if (self.selectedCityName == nil) {
      
    }else{
        homeAddressViewController.selectedRegions = [DKHomeModelTool searchRegionsWithCityName:self.selectedCityName];
    }
    [self.addressUIPopoverController presentPopoverFromBarButtonItem:self.addressItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}





/**
 构建左边的导航栏按钮

 */
- (void)clickCategoryItem{
    NSLog(@"%s",__func__);
    UIPopoverController *vc = [[UIPopoverController alloc]initWithContentViewController:[[DKCategoryViewController alloc]init]];
    [vc presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

/**
 构建右边的导航栏按钮
 */
- (void)setupRightNav
{
    UIBarButtonItem *mapItem = [UIBarButtonItem barButtonItemWithTarget:self Image:@"icon_map" highlightedImage:@"icon_map_highlighted" actionMethod:@selector(map)];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem =[UIBarButtonItem barButtonItemWithTarget:self Image:@"icon_search" highlightedImage:@"icon_search_highlighted" actionMethod:@selector(clickSearch)];
        searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - ******** 处理map的点击事件

- (void)map{
    
    //    控制器跳转
    MTMapViewController *vc = [[MTMapViewController alloc]init];
    DKNavigationViewController *nav = [[DKNavigationViewController alloc]initWithRootViewController:vc];
//    vc.selectedCityName = self.selectedCityName;
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - ******** 处理搜索框的点击事件

- (void)clickSearch{
    
//    控制器跳转
    DKSearchCollectionViewController *vc = [[DKSearchCollectionViewController alloc]init];
    DKNavigationViewController *nav = [[DKNavigationViewController alloc]initWithRootViewController:vc];
    vc.selectedCityName = self.selectedCityName;
    [self presentViewController:nav animated:YES completion:nil];
    
}



/**
 交给子类实现
 */
- (NSMutableDictionary*)params{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"city"] = self.selectedCityName;
    params[@"region"] = self.selectedRegion;
    params[@"category"] = self.selectedCategory;
    params[@"sort"] = self.selectedDKHomeSortModel.value;
    return params;
}






@end
