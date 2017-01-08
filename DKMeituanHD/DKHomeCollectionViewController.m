//
//  DKHomeCollectionViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 03/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

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
@interface DKHomeCollectionViewController ()

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




@property (nonatomic,strong) UIPopoverController *addressUIPopoverController;
@property (nonatomic,strong) UIPopoverController *homeSortViewControllerUIPopoverController;






@end

@implementation DKHomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


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

- (instancetype)init
{
    UICollectionViewLayout *layout = [[UICollectionViewFlowLayout alloc]init];//2017-01-03 17:11:29.702 DKMeituanHD[2329:230000] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'UICollectionView must be initialized with a non-nil layout parameter'

    self = [super initWithCollectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = DkGlobalBg;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //1.构件导航栏
    [self setupRightNav];
    [self setupLeftNav];
    //2.监听城市的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCityNotification:) name:DKdidSelectCityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickSortButonNotification:) name:DKdidClickSortButonNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickCategoryTableNotification:) name:DKdidClickCategoryTableNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickCityTableTableNotification:) name:DKdidClickCityTableTableNotification object:nil];


    
    


}


- (void)didClickCityTableTableNotification:(NSNotification*)notification{
    NSString *title = [notification userInfo][DKdidClickCityTableTableNotificationInfoTitleKey];
    NSString *subtitle = [notification userInfo][DKdidClickCityTableTableNotificationInfoSubTitleKey];
    
    DKHomeTopItem *topItem = (DKHomeTopItem*) self.addressItem.customView;
    topItem.title = [NSString stringWithFormat:@"%@ -%@",self.selectedCityName,title];
    topItem.subTitle = subtitle;
#warning 设置选中的类别数据
    
    //    self.selectedDKHomeSortModel = subtitle;
    //进行数据的更新（请求后台）
}

- (void)didClickCategoryTableNotification:(NSNotification*)notification{
    NSString *title = [notification userInfo][DKdidClickCategoryTableNotificationInfoTitleKey];
    NSString *subtitle = [notification userInfo][DKdidClickCategoryTableNotificationInfosubTitleKey];
    DKCategoryModel *model = [notification userInfo][DKdidClickCategoryTableNotificationInfoModelKey];

    
    DKHomeTopItem *topItem = (DKHomeTopItem*) self.categoryItem.customView;
    topItem.title = title;
    topItem.subTitle = subtitle;
    [topItem setIcon:model.icon hightIcon:model.highlighted_icon];
#warning 设置选中的类别数据

//    self.selectedDKHomeSortModel = subtitle;
    //进行数据的更新（请求后台）
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





- (void)clickCategoryItem{
    NSLog(@"%s",__func__);
    UIPopoverController *vc = [[UIPopoverController alloc]initWithContentViewController:[[DKCategoryViewController alloc]init]];
    [vc presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}



- (void)setupRightNav
{
    UIBarButtonItem *mapItem = [UIBarButtonItem barButtonItemWithTarget:nil Image:@"icon_map" highlightedImage:@"icon_map_highlighted" actionMethod:nil];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem =[UIBarButtonItem barButtonItemWithTarget:nil Image:@"icon_search" highlightedImage:@"icon_search_highlighted" actionMethod:nil];
        searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
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
