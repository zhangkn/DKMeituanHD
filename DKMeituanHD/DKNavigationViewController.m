//
//  DKNavigationViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 04/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKNavigationViewController.h"
#import "DKConst.h"
@interface DKNavigationViewController ()

@end





@implementation DKNavigationViewController


+ (void)initialize
{
    if (self == [DKNavigationViewController class]) {
        //设置样式
        UINavigationBar *bar = [UINavigationBar appearance];
        [bar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
        
        
        
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
