//
//  DKHomeSortViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 08/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeSortViewController.h"
#import "DKConst.h"
#import "DKHomeSortModel.h"
#import "DKHomeSortButton.h"
@interface DKHomeSortViewController ()

@property (nonatomic,strong) NSArray *sortModels;

@end

@implementation DKHomeSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sortModels = [DKHomeModelTool getSortModels];
    CGFloat w = 100;
    CGFloat h = 40;
    CGFloat x = 15;
    CGFloat margin = 15;
    for (int i = 0; i<self.sortModels.count; i++) {
        //构件子控件
        DKHomeSortModel *model = self.sortModels[i];
        
        DKHomeSortButton *btn = [[DKHomeSortButton alloc]init];
        btn.model = model;
        [self.view addSubview:btn];
        btn.width = w;
        btn.height = h;
        btn.x = x;
        btn.y = margin +(h+margin)*i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        
//        [btn setAutoresizingMask:UIViewAutoresizingNone];
    }
    self.preferredContentSize = CGSizeMake(w+x*2, CGRectGetMaxY([self.view.subviews lastObject].frame)+margin);
    
}

- (void)clickBtn:(DKHomeSortButton*)btn{
    // post notification
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:btn.model forKey:DKdidClickSortButonNotificationValueKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DKdidClickSortButonNotification object:self userInfo:userInfo];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
