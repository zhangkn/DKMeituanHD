//
//  DKCategoryViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKCategoryViewController.h"
#import "DKHomeDropdownView.h"
#import "DKHomeModelTool.h"
#import "Masonry.h"
#import "DKConst.h"
#import "DKCategoryModel.h"
/**
 *显示分类列表
 */
@interface DKCategoryViewController ()<DKHomeDropdownViewDataSource>

@property (nonatomic,strong) NSArray *models;


@end

@implementation DKCategoryViewController

- (void)loadView{
    
    //1. 设置下拉菜单试图 为控制器视图
    DKHomeDropdownView *homeDropdownView = [DKHomeDropdownView homeDropdownView];
    homeDropdownView.dataSource = self;
    homeDropdownView.delegate = self;
    NSArray *categoryModels=  [DKHomeModelTool categoryModels];
    //    //设置homeDropdownView的约束size
    //    [homeDropdownView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(300);
    //        make.height.mas_equalTo(300);
    //
    //    }];
    //    self.view  =homeDropdownView;
    
    self.models = categoryModels;
//    [self.view addSubview:homeDropdownView];
    self.view = homeDropdownView;
    
    
    //2.控制器的view 在popover控制器中的size
    self.preferredContentSize = homeDropdownView.size;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


/**
 左边的表格一共有多少行。
 
 @param homeDropdownView 下拉菜单
 
 @return 行数
 */
- (NSInteger)numberOfRowsInMainTableDKHomeDropdownView:(DKHomeDropdownView*)homeDropdownView{
  return   self.models.count;
}

- (id<DKHomeDropdownViewData>)  homeDropdownView:(DKHomeDropdownView*)homeDropdownView  subdataForRowsInMainTable:(NSInteger)row{
    return self.models[row] ;
}

#pragma mark - ******** DKHomeDropdownViewDelegate

- (void)homeDropdownView:(DKHomeDropdownView*)homeDropdownView  didSelectedRowsInMainTable:(NSInteger)row{
    
    
    // post notification
    DKCategoryModel *model = (DKCategoryModel*)self.models[row] ;
    
    if (model.subcategories.count) {
        return;
    }
    
    NSString *title = model.name;
    NSString *subTitle = @"";
    
    NSDictionary *userInfo = @{DKdidClickCategoryTableNotificationInfosubTitleKey: subTitle,DKdidClickCategoryTableNotificationInfoTitleKey:title,DKdidClickCategoryTableNotificationInfoModelKey:model};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DKdidClickCategoryTableNotification object:self userInfo:userInfo];
    

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)homeDropdownView:(DKHomeDropdownView*)homeDropdownView  didSelectedRowsInSubTable:(NSInteger)row inMainTable:(NSInteger)mainRow{
//更新数据
//    发布通知
    // post notification
    DKCategoryModel *model = (DKCategoryModel*)self.models[mainRow] ;
    
    NSString *subTitle = model.subcategories[row];
    NSString *title = model.name;
    
    NSDictionary *userInfo = @{DKdidClickCategoryTableNotificationInfosubTitleKey: subTitle,DKdidClickCategoryTableNotificationInfoTitleKey:title,DKdidClickCategoryTableNotificationInfoModelKey:model};

    [[NSNotificationCenter defaultCenter] postNotificationName:DKdidClickCategoryTableNotification object:self userInfo:userInfo];
    

    [self dismissViewControllerAnimated:YES completion:nil];

    
}




@end
