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

/**
 *显示分类列表
 */
@interface DKCategoryViewController ()

@end

@implementation DKCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DKHomeDropdownView *homeDropdownView = [DKHomeDropdownView homeDropdownView];
    NSArray *categoryModels=  [DKHomeModelTool categoryModels];
    
    [self.view addSubview:homeDropdownView];
    
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
