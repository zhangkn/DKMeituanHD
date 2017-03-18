//
//  DKCollectCollectionViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 15/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKCollectCollectionViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DKConst.h"
#import "MTDealTool.h"
#import "MJRefresh.h"
#import "DKDealCell.h"
#import "MTDetailViewController.h"

//#import "UIScrollView+MJRefresh.h"
@interface DKCollectCollectionViewController ()


/**
 存放数据源
 */
@property (nonatomic,strong) NSMutableArray *deals;


@property (nonatomic ,assign)int currentPage;

/**
 当前数据的总数
 */
@property (nonatomic,assign) long total_count;



/**
 没有数据的时候，展示的图标 icon_deals_empty
 */
@property (nonatomic,strong) UIImageView *icon_deals_emptyView;

@end

@implementation DKCollectCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";


- (NSMutableArray *)deals{
    if (nil == _deals) {
        NSMutableArray *tmp  = [[NSMutableArray alloc]init];
        _deals = tmp;
    }
    return _deals;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];//2017-01-03 17:11:29.702 DKMeituanHD[2329:230000] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'UICollectionView must be initialized with a non-nil layout parameter'
    
    //设置cell大小
    
    [layout setItemSize:CGSizeMake(DKDealCellSize, DKDealCellSize)];
    //设置分组上下左右的内边距
    CGFloat inset = 15;
    [layout setSectionInset:UIEdgeInsetsMake(inset, inset, inset, inset)];//The margins used to lay out content in a section
    //设置cell间的间距（根据横竖屏进行适配）
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
    }
    return self;
}




- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title= @"收藏的团购";
    
    self.collectionView.backgroundColor = DkGlobalBg;
    // 1.左边的返回
    //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self Image:@"icon_back" highlightedImage:@"icon_back_highlighted" actionMethod:@selector(back)];
    
    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;//设置弹簧效果
    [self.collectionView registerNib:[UINib nibWithNibName:@"DKDealCell" bundle:nil] forCellWithReuseIdentifier:DKDealCellReuseIdentifier];
    
    
    //2. 加载第一个的收藏数据
//    self.currentPage = 1;
//    [self.deals  addObjectsFromArray: [MTDealTool collectDeals:self.currentPage]];
    [self footerWithTargetLoadMoreData];
    
    
    //3. 监听收藏状态
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupMTCollectStateDidChangeNotification:) name:MTCollectStateDidChangeNotification object:nil];
    
    //4.添加上辣加载
    
    [self.collectionView addFooterWithTarget:self action:@selector(footerWithTarget)];
    
    
}


/**
 上啦加载的回调方法
 */
#pragma mark - ******** 上拉加载的回调方法

- (void)footerWithTargetLoadMoreData{
    int collectDealsCount=  [MTDealTool collectDealsCount];
    
    int totalPageNum = (collectDealsCount + DKCellPagesize - 1) / DKCellPagesize;
    if(self.currentPage<totalPageNum){
        self.currentPage++;
    }else{
        return;
    }
    [self.deals  addObjectsFromArray: [MTDealTool collectDeals:self.currentPage]];
}

- (void)footerWithTarget{
//    [self.collectionView footerBeginRefreshing];
    [self footerWithTargetLoadMoreData];
    [self.collectionView footerEndRefreshing];
    [self.collectionView reloadData];
    
    
}


#pragma mark - ******** 处理收藏的状态改变通知
- (void)setupMTCollectStateDidChangeNotification:(NSNotification *)notification{
    
//    return;
    
    DKDeal *deal = notification.userInfo[MTCollectDealKey];
    BOOL isCollect = [notification.userInfo[MTIsCollectKey] boolValue];
    
    if(isCollect){
//        [self.deals addObject:deal];
        
        [self.deals insertObject:deal atIndex:0];
        
    }else{
        [self.deals removeObject:deal];//需要重写对象的比较方法，否则对象的地址不一样。--- 内容一样即可删除
    }
    
    if (self.deals.count == 0 && [MTDealTool collectDealsCount]!=0) {
        //此时需要重新加载数据
        self.currentPage = 0;
        [self footerWithTargetLoadMoreData];
    }
    
    //数据的更新
    [self.collectionView reloadData];
    
    
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
    CGFloat cellMargin = (size.width - (DKDealCellSize*cellCol))/(cellCol+1);
    
    //设置分组上下左右的内边距
    CGFloat inset = cellMargin;
    [layout setSectionInset:UIEdgeInsetsMake(inset, inset, inset, inset)];//The margins used to lay out content in a section
    //设置cell间的间距（根据横竖屏进行适配）
    layout.minimumLineSpacing = inset;
}



- (UIImageView *)icon_deals_emptyView{
    if (nil == _icon_deals_emptyView) {
        UIImageView *tmpView = [[UIImageView alloc]init];
        [tmpView setImage:[UIImage imageNamed:@"icon_collects_empty"]];
        _icon_deals_emptyView = tmpView;
        tmpView.hidden = YES;
        [self.view addSubview:_icon_deals_emptyView];
        //设置自动布局
        [_icon_deals_emptyView autoCenterInSuperview];
        
    }
    return _icon_deals_emptyView;
}

#pragma mark <UICollectionViewDataSource>

/**
 当刷新数据的时候,布局cell。
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
//    self.total_count = [MTDealTool collectDealsCount];
    //计算一遍内边距 (self.collectionView.width == 1024):3?2
    CGFloat cellCol = (self.collectionView.width == 1024)?3:2;
    [self setupcellMarginWithcellCol:cellCol viewWillTransitionToSize:CGSizeMake(self.collectionView.width, 0)];
    
    //控制上拉加载数据控件的显示状态
    self.total_count = [MTDealTool collectDealsCount];
    self.collectionView.footerHidden = (self.total_count == self.deals.count);
    
    //处理没数据的情况
    if (self.deals.count == 0) {
        [self.icon_deals_emptyView setHidden:NO]; //展示
        
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
    return   [DKDealCell cellWithDeal:deal collectionView:collectionView WithReuseIdentifier:DKDealCellReuseIdentifier forIndexPath:indexPath];
}


#pragma mark - ******** 跳到详情页

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //调整到详情页
    MTDetailViewController *vc = [[MTDetailViewController alloc]init];
    
    vc.deal = self.deals[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}





@end
