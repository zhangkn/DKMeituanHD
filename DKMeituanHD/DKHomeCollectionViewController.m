//
//  DKHomeCollectionViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 03/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//
#import "DKDeal.h"
#import "Foundation+Log.m"
#import "DKHomeCollectionViewController.h"
#import "DKConst.h"
#import "DKCategoryViewController.h"
#import "DKHomeTopItem.h"
#import "DKHomeAddressViewController.h"
#import "DKHomeModelTool.h"
#import "DKHomeSortViewController.h"
#import "DKHomeSortModel.h"
#import "DKCategoryModel.h"
#import "DKCityModel.h"
#import "DKCityGroupModel.h"
#import "DKDealCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#define   cellSize   305


@interface DKHomeCollectionViewController ()<DPRequestDelegate>

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


/**
 存放数据源
 */
@property (nonatomic,strong) NSMutableArray *deals;

/**
 当前页码--- 请求成功的页码
 */
@property (nonatomic,assign) int currentPage;

/**
 正在请求的页面
 */
@property (nonatomic,assign) int requestPage;



/**
  最新的请求对象
 */
@property (nonatomic,strong) DPRequest *requestObj;


/**
 没有数据的体术 icon_deals_empty
 */
@property (nonatomic,strong) UIImageView *icon_deals_emptyView;

/**
 当前请求数据的总数
 */
@property (nonatomic,assign) long total_count;




@end

@implementation DKHomeCollectionViewController

static NSString * const reuseIdentifier = @"DKDealCell";


- (UIImageView *)icon_deals_emptyView{
    if (nil == _icon_deals_emptyView) {
        UIImageView *tmpView = [[UIImageView alloc]init];
        [tmpView setImage:[UIImage imageNamed:@"icon_deals_empty"]];
        _icon_deals_emptyView = tmpView;
        tmpView.hidden = YES;
        [self.view addSubview:_icon_deals_emptyView];
        //设置自动布局
        [_icon_deals_emptyView autoCenterInSuperview];
        
    }
    return _icon_deals_emptyView;
}

- (NSMutableArray *)deals{
    if (nil == _deals) {
        NSMutableArray *tmp  = [[NSMutableArray alloc]init];
        _deals = tmp;
    }
    return _deals;
}

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

#pragma mark - ******** 监听控制器的尺寸变化  ，用于    //设置cell间的间距（根据横竖屏进行适配）

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    
    if (self.view.width < size.width) {//横屏 3 列
        NSLog(@"横屏 3 列");
        CGFloat cellCol = 3;
        [self setupcellMarginWithcellCol:cellCol viewWillTransitionToSize:size];
        
        
        
        
    }else{//竖屏  2列
        CGFloat cellCol = 2;
        NSLog(@"竖屏  2列");
        [self setupcellMarginWithcellCol:cellCol viewWillTransitionToSize:size];
    }
    
}


- (void)setupcellMarginWithcellCol:(CGFloat)cellCol   viewWillTransitionToSize:(CGSize)size{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    CGFloat cellMargin = (size.width - (cellSize*cellCol))/(cellCol+1);
    
    //设置分组上下左右的内边距
    CGFloat inset = cellMargin;
    [layout setSectionInset:UIEdgeInsetsMake(inset, inset, inset, inset)];//The margins used to lay out content in a section
    //设置cell间的间距（根据横竖屏进行适配）
    layout.minimumLineSpacing = inset;
}



- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];//2017-01-03 17:11:29.702 DKMeituanHD[2329:230000] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'UICollectionView must be initialized with a non-nil layout parameter'
    
    //设置cell大小
   
    [layout setItemSize:CGSizeMake(cellSize, cellSize)];
    //设置分组上下左右的内边距
    CGFloat inset = 15;
    [layout setSectionInset:UIEdgeInsetsMake(inset, inset, inset, inset)];//The margins used to lay out content in a section
    //设置cell间的间距（根据横竖屏进行适配）

    self = [super initWithCollectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = DkGlobalBg;
    self.collectionView.alwaysBounceVertical = YES;//设置弹簧效果
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DKDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    //1.构件导航栏
    [self setupRightNav];
    [self setupLeftNav];
    //2.监听城市的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityNotification:) name:DKdidSelectCityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickSortButonNotification:) name:DKdidClickSortButonNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickCategoryTableNotification:) name:DKdidClickCategoryTableNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickCityTableTableNotification:) name:DKdidClickCityTableTableNotification object:nil];


    //3\ 添加刷新控件
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];


}

- (void)loadNewData{
    [self loadDataWithPage:1];
}
#pragma mark - ******** 加载更多数据



- (void)loadMoreData{
    
    //设置请求页数
    
    // 计算总页数
    
    
    [self loadDataWithPage:self.currentPage+1];
}




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
#warning 设置选中的类别数据
    
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
#warning 设置选中的类别数据

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

#pragma mark - ******** 与服务器的交互

- (void) loadNewDeals{//
    
    
//    [self loadDataWithPage:1];
    [self.collectionView headerBeginRefreshing];
}


- (void)loadDataWithPage:(int)page{
    DPAPI *api =  [[DPAPI alloc]init];
    //    NSString *url = @"http://api.dianping.com/v1/deal/find_deals";
    NSString *url = @"v1/deal/find_deals";
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"city"] = self.selectedCityName;
    params[@"region"] = self.selectedRegion;
    params[@"category"] = self.selectedCategory;
    params[@"sort"] = self.selectedDKHomeSortModel.value;
    self.requestPage = page;
    params[@"page"] = [NSString stringWithFormat:@"%d",self.requestPage];
    //    params[@"sort"] = self.selectedCityName;
    self.requestObj =  [api requestWithURL:url params:params delegate:self];
    
}

#pragma mark - ******** - DPRequestDelegate

- (void)request:(DPRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%s---%@",__func__,response);
    /**
     *didReceiveResponse
     { status code: 200, headers {
     Pragma = no-cache,
     Content-Type = application/json;charset=utf-8,
     Server = Tengine,
     Vary = Accept-Encoding, Accept-Encoding,
     Transfer-Encoding = Identity,
     Date = Mon, 09 Jan 2017 00:58:44 GMT,
     Keep-Alive = timeout=5,
     Cache-Control = no-cache,
     Connection = keep-alive
     } }
     */

}
- (void)request:(DPRequest *)request didReceiveRawData:(NSData *)data{
    
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    if (self.requestObj != request) {
        return;
    }
    
    [self.collectionView footerEndRefreshing];
    [self.collectionView headerEndRefreshing];
    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:self.view];
}

#pragma mark - ******** 解析服务器返回的数据

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    if (request != self.requestObj) {//忽略旧的请求
        return;
    }
//    NSLog(@"%s---%@",__func__,result);
    self.currentPage = self.requestPage;
    
    if (self.currentPage == 1) {
        self.deals = nil;
    }else{
        //结束加载框
        [self.collectionView footerEndRefreshing];
        
    }
    
    /**
     *{
     description = 巴比伦滚轴溜冰场 代金券 仅售5元，价值10元代金券，节假日通用，免费wifi，男女通用，免费提供储物柜！,
     categories = [
     运动健身,
     溜冰
     ],
     deal_url = http://t.dianping.com/deal/22748068?utm_source=open,
     publish_date = 2016-12-12,
     purchase_count = 1339,
     image_url = http://p1.meituan.net/dpdeal/609c41f542d77f14024a6a6e76dc686574228.jpg%40640w_400h_1e_1c_1l%7Cwatermark%3D1%26%26r%3D1%26p%3D9%26x%3D2%26y%3D2%26relative%3D1%26o%3D20,
     deal_id = 344-22748068,
     title = 巴比伦滚轴溜冰场,
     purchase_deadline = 2017-01-31,
     s_image_url = http://p1.meituan.net/dpdeal/609c41f542d77f14024a6a6e76dc686574228.jpg%40160w_100h_1e_1c_1l%7Cwatermark%3D1%26%26r%3D1%26p%3D9%26x%3D2%26y%3D2%26relative%3D1%26o%3D20,
     city = 长沙,
     regions = [
     雨花区
     ],
     current_price = 5,
     businesses = [
     {
     h5_url = http://m.dianping.com/shop/5406854?utm_source=open,
     city = 长沙,
     longitude = 112.99289,
     id = 5406854,
     latitude = 28.164648,
     name = 东塘巴比伦溜冰城,
     url = http://www.dianping.com/shop/5406854?utm_source=open
     }
     ],
     distance = -1,
     deal_h5_url = http://m.dianping.com/tuan/deal/22748068?utm_source=open,
     commission_ratio = 0,
     list_price = 10
     }
     */
    NSArray  *dealsDict = result[@"deals"];
//    NSString  *count = result[@"count"];// ------deals 的大小 当前返回的数据数量
    self.total_count = [result[@"total_count"] longValue];// ------总数量
//    NSString  *status = result[@"status"];
    NSArray *dealModels= [DKDeal dealsWithDictArray:dealsDict];
    [self.deals addObjectsFromArray:dealModels];
    
    [self.collectionView reloadData];
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    
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
#warning reload data
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
    UIBarButtonItem *mapItem = [UIBarButtonItem barButtonItemWithTarget:nil Image:@"icon_map" highlightedImage:@"icon_map_highlighted" actionMethod:nil];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem =[UIBarButtonItem barButtonItemWithTarget:self Image:@"icon_search" highlightedImage:@"icon_search_highlighted" actionMethod:@selector(clickSearch)];
        searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}


#pragma mark - ******** 处理搜索框的点击事件

- (void)clickSearch{
    
//    控制器跳转
    DKSearchCollectionViewController *vc = [[DKSearchCollectionViewController alloc]init];
    DKNavigationViewController *nav = [[DKNavigationViewController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark <UICollectionViewDataSource>

/**
 当刷新数据的时候,布局cell。
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    //计算一遍内边距 (self.collectionView.width == 1024):3?2
    CGFloat cellCol = (self.collectionView.width == 1024)?3:2;
    [self setupcellMarginWithcellCol:cellCol viewWillTransitionToSize:CGSizeMake(self.collectionView.width, 0)];
    
    //控制下拉加载数据控件的显示状态
    self.collectionView.footerHidden = (self.total_count == self.deals.count);
    
    //处理没数据的情况
    if (self.deals.count == 0) {
        [self.icon_deals_emptyView setHidden:NO];
    }else{
        [self.icon_deals_emptyView setHidden:YES];
    }

     
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.deals.count;
}


/**
 定义cell的具体细节
 @return cell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        DKDeal *deal = self.deals[indexPath.row];
    return   [DKDealCell cellWithDeal:deal collectionView:collectionView WithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/





@end
