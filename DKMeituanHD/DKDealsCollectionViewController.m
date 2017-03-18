//
//  DKDealsCollectionViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 15/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKDealsCollectionViewController.h"
#import "MJRefresh.h"
#import "DKDeal.h"
#import "Foundation+Log.m"
#import "DKHomeModelTool.h"
#import "DKDealCell.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"

#import "MTDetailViewController.h"

#import "DKConst.h"


@interface DKDealsCollectionViewController ()

/**
 存放数据源
 */
@property (nonatomic,strong) NSMutableArray *deals;

/**
 没有数据的时候，展示的图标 icon_deals_empty
 */
@property (nonatomic,strong) UIImageView *icon_deals_emptyView;

/**
 当前请求数据的总数
 */
@property (nonatomic,assign) long total_count;


/**
 最新的请求对象
 */
@property (nonatomic,strong) DPRequest *requestObj;

/**
 当前页码--- 请求成功的页码
 */
@property (nonatomic,assign) int currentPage;

/**
 正在请求的页面
 */
@property (nonatomic,assign) int requestPage;



@end



@implementation DKDealsCollectionViewController

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



- (void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.backgroundColor = DkGlobalBg;
    self.collectionView.alwaysBounceVertical = YES;//设置弹簧效果

    [self.collectionView registerNib:[UINib nibWithNibName:@"DKDealCell" bundle:nil] forCellWithReuseIdentifier:DKDealCellReuseIdentifier];
    
    
//    / 添加刷新控件
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];


}


#pragma mark - ******** 刷新控件的方法

- (void)loadMoreData{
    
    //设置请求页数
    
    // 计算总页数
    
    
    [self loadDataWithPage:self.currentPage+1];
}

- (void)loadNewData{
    [self loadDataWithPage:1];
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
       self.requestPage = page;
    NSMutableDictionary *params = [self params];
    params[@"page"] = [NSString stringWithFormat:@"%d",self.requestPage];
    //    params[@"sort"] = self.selectedCityName;
    self.requestObj =  [api requestWithURL:url params:params delegate:self];
    
}
#pragma mark - ******** 请求参数的封装

/**
 交给子类实现
 */
- (NSMutableDictionary*)params{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    params[@"city"] = self.selectedCityName;
//    params[@"region"] = self.selectedRegion;
//    params[@"category"] = self.selectedCategory;
//    params[@"sort"] = self.selectedDKHomeSortModel.value;
    return params;
}

#pragma mark - ******** - DPRequestDelegate

- (void)request:(DPRequest *)request didReceiveResponse:(NSURLResponse *)response{
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





- (NSMutableArray *)deals{
    if (nil == _deals) {
        NSMutableArray *tmp  = [[NSMutableArray alloc]init];
        _deals = tmp;
    }
    return _deals;
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
        [tmpView setImage:[UIImage imageNamed:@"icon_deals_empty"]];
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
    return   [DKDealCell cellWithDeal:deal collectionView:collectionView WithReuseIdentifier:DKDealCellReuseIdentifier forIndexPath:indexPath];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //调整到详情页
    MTDetailViewController *vc = [[MTDetailViewController alloc]init];
    
    vc.deal = self.deals[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}


@end
