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





@end

@implementation DKHomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (UIBarButtonItem *)categoryItem{
    if (nil == _categoryItem) {
        DKHomeTopItem *tmpItemView = [DKHomeTopItem homeTopItem];
        //设置监听器
        [tmpItemView addTarget:self action:@selector(clickCategoryItem)];
        
        UIBarButtonItem *tmpView =  [[UIBarButtonItem alloc]initWithCustomView:tmpItemView];
        _categoryItem = tmpView;
    }
    return _categoryItem;
}


- (UIBarButtonItem *)addressItem{
    if (nil == _addressItem) {
        DKHomeTopItem *addressItemView = [DKHomeTopItem homeTopItem];
        //设置监听器
        [addressItemView addTarget:self action:@selector(clickAddressItem)];
        UIBarButtonItem *tmpView =  [[UIBarButtonItem alloc]initWithCustomView:addressItemView];
        _addressItem = tmpView;
    }
    return _addressItem;
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
    
    [self setupRightNav];
    [self setupLeftNav];

}

/**
 *设置左边的items
 */
- (void)setupLeftNav{
    UIImage *logoImage = [[UIImage imageNamed:@"icon_meituan_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//不被渲染
        UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithImage:logoImage style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    
   
//    searchItem.customView.width = 60;

    self.navigationItem.leftBarButtonItems = @[logoItem, self.categoryItem,self.addressItem];

    
    
}


- (void)clickAddressItem{
    
    NSLog(@"%s",__func__);
    UIPopoverController *vc = [[UIPopoverController alloc]initWithContentViewController:[[DKHomeAddressViewController alloc]init]];
    [vc presentPopoverFromBarButtonItem:self.addressItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    
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
