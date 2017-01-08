//
//  DKHomeAddressViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeAddressViewController.h"
#import "Masonry.h"
#import "DKHomeDropdownView.h"
#import "DKHomeModelTool.h"
#import "DKConst.h"
#import "DKHomeCityViewController.h"
#import "DKNavigationViewController.h"

#import "DKCityRegion.h"

@interface DKHomeAddressViewController ()<DKHomeDropdownViewDataSource,DKHomeDropdownViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *changeCityView;

@property (weak, nonatomic)  DKHomeDropdownView *homeDropdownView;

//@property (nonatomic,strong) NSArray *models;


@end

@implementation DKHomeAddressViewController

- (void)setSelectedRegions:(NSArray *)selectedRegions{
    _selectedRegions = selectedRegions;
    
    //刷新数据
    [self.homeDropdownView reloadData];
}


- (DKHomeDropdownView *)homeDropdownView{
    if (nil == _homeDropdownView) {
        DKHomeDropdownView *homeDropdownView= [DKHomeDropdownView homeDropdownView];
//        self.models = [DKHomeModelTool cityModels];
        homeDropdownView.dataSource = self;
        homeDropdownView.delegate = self;
        _homeDropdownView = homeDropdownView;
        [self.view addSubview:homeDropdownView];
    }
    return _homeDropdownView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [homeDropdownView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.changeCityView.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(self.view.width, 400));
//        make.left.equalTo(self.view.mas_left);
//    }];
    self.preferredContentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.homeDropdownView.frame)) ;
    
    
}

/**
 *modal 到城市选择控制器
 */
- (IBAction)clickChangeCityView:(id)sender {
    NSLog(@"%s",__func__);
    [self dismissViewControllerAnimated:YES completion:nil];

    
    
    DKHomeCityViewController *city =[[DKHomeCityViewController alloc] initWithNibName:@"DKHomeCityViewController" bundle:nil];
//    DKHomeCityViewController *city = [[DKHomeCityViewController alloc]init];    // 控制器会默认去找对应的xib来创建View。
    
    DKNavigationViewController *nav = [[DKNavigationViewController alloc]initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;//设置modal的样式为sheet，居中显示，类似UiActionSheet的形式
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{

    }];// ------rootViewController  在同一时刻只能presentViewController 一个，所以必须先    [self dismissViewControllerAnimated:YES completion:nil];，否则将报错DKNavigationViewController: 0x7fdcc401d000> which is already presenting

    
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.homeDropdownView.y = CGRectGetMaxY(self.changeCityView.frame);
}
    


#pragma mark - ******** DKHomeDropdownViewDataSource


/**
 左边的表格一共有多少行。
 
 @param homeDropdownView 下拉菜单
 
 @return 行数
 */
- (NSInteger)numberOfRowsInMainTableDKHomeDropdownView:(DKHomeDropdownView*)homeDropdownView{
   return  self.selectedRegions.count;
}

- (id<DKHomeDropdownViewData>)  homeDropdownView:(DKHomeDropdownView*)homeDropdownView  subdataForRowsInMainTable:(NSInteger)row{
    return self.selectedRegions[row];
}



#pragma mark - ******** DKHomeDropdownViewDelegate

- (void)homeDropdownView:(DKHomeDropdownView*)homeDropdownView  didSelectedRowsInMainTable:(NSInteger)row{
    
    
    // post notification
    DKCityRegion *model = (DKCityRegion*)self.selectedRegions[row] ;
    
    if (model.subregions.count) {
        return;
    }
    
    NSString *title = model.name;
    NSString *subTitle = @"";
    NSDictionary *userInfo = @{DKdidClickCityTableTableNotificationInfoSubTitleKey: subTitle,DKdidClickCityTableTableNotificationInfoTitleKey:title};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DKdidClickCityTableTableNotification object:self userInfo:userInfo];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)homeDropdownView:(DKHomeDropdownView*)homeDropdownView  didSelectedRowsInSubTable:(NSInteger)row inMainTable:(NSInteger)mainRow{
    //更新数据
    //    发布通知
    // post notification
    DKCityRegion *model = (DKCityRegion*)self.selectedRegions[mainRow] ;
    
    NSString *subTitle = model.subregions[row];
    NSString *title = model.name;
    
    NSDictionary *userInfo = @{DKdidClickCityTableTableNotificationInfoSubTitleKey: subTitle,DKdidClickCityTableTableNotificationInfoTitleKey:title};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DKdidClickCityTableTableNotification object:self userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


@end
