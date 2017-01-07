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

/**
 *显示分类列表
 */
@interface DKCategoryViewController ()

@end

@implementation DKCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 设置下拉菜单试图
    DKHomeDropdownView *homeDropdownView = [DKHomeDropdownView homeDropdownView];
    NSArray *categoryModels=  [DKHomeModelTool categoryModels];
//    //设置homeDropdownView的约束size
//    [homeDropdownView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(300);
//        make.height.mas_equalTo(300);
//        
//    }];
//    self.view  =homeDropdownView;
    
    homeDropdownView.models = categoryModels;
    [self.view addSubview:homeDropdownView];
    
    //2.控制器的view 在popover控制器中的size
    self.preferredContentSize = homeDropdownView.size;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
