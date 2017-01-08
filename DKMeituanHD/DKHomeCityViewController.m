//
//  DKHomeCityViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeCityViewController.h"
#import "DKConst.h"
#import "DKHomeModelTool.h"
#import "DKCityGroupModel.h"
#import "Masonry.h"

#import "DKHomeSearchResultTableViewController.h"
/**
 *c城市选择控制器
 */
@interface DKHomeCityViewController ()<UISearchBarDelegate>
@property (nonatomic,strong) NSArray *cityGroupModels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic)  DKHomeSearchResultTableViewController *homeSearchResultTableViewController;


/**
 *遮盖
 */
@property (nonatomic,strong) UIView *cover;

@end

@implementation DKHomeCityViewController
/**
 *懒加载显示搜索结果的控制器
 */
- (DKHomeSearchResultTableViewController *)homeSearchResultTableViewController{
    if (nil == _homeSearchResultTableViewController) {
        DKHomeSearchResultTableViewController *tmpView = [[DKHomeSearchResultTableViewController alloc]init];
        _homeSearchResultTableViewController = tmpView;
//        1.设置视图的父子关系
        //在遮盖视图上面添加新的tableview控件，用于暂时搜索结果
        [self.view addSubview:_homeSearchResultTableViewController.view];
        [_homeSearchResultTableViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];//除了顶部没有约束，其他方位都和父控件一样
        
        [_homeSearchResultTableViewController.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15];//设置顶部的约束
        //2.设置控制器的父子关系
        [self addChildViewController:_homeSearchResultTableViewController];//控制器的视图为父子关系的时候，控制器也最好成为父子关系
    }
    return _homeSearchResultTableViewController;
}

- (UIView *)cover{
    if (nil == _cover) {
        UIView *tmpView = [[UIView alloc]init];
        [tmpView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCover)]];
        [tmpView setAlpha:0.2];
        [tmpView setBackgroundColor:[UIColor grayColor]];
        _cover = tmpView;
    }
    return _cover;
}

- (void)clickCover{
//    [self.cover removeFromSuperview];
//    [self searchBarTextDidEndEditing:nil];
    //只需要退出键盘，系统会自动调用searchBarTextDidEndEditing
    
    [self.view endEditing:YES];
//    [self.view resignFirstResponder]
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self Image:@"btn_navigation_close_hl" highlightedImage:@"btn_navigation_close" actionMethod:@selector(clickleftBarButtonItem)];
    
   self.cityGroupModels = [DKHomeModelTool cityGroupModels];
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    //设置searchbar的取消按钮颜色
    [self.searchBar setTintColor:[UIColor greenColor]];
    
}

- (void)clickleftBarButtonItem {
    [self dismissViewControllerAnimated:YES completion:^{
        //传递选择的城市数据给 DKHomeAddressViewController     NSLog(@"%@",self.presentingViewController);
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cityGroupModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[(DKCityGroupModel*)self.cityGroupModels[section] cities] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"DkUITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.cityGroupModels[indexPath.section] cities][indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.cityGroupModels[section] title];
}


/**
 *发布通知给监听者
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //1. post notification
    //城市名称信息
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[self.cityGroupModels [indexPath.section] cities][indexPath.row]forKey:DKdidSelectCityNotificationKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DKdidSelectCityNotification object:self userInfo:userInfo];
    
    //2. 销毁自己
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    for (DKCityGroupModel *obj in self.cityGroupModels) {
//        [array addObject:obj.title];
//    }
//    return array;
    return [self.cityGroupModels valueForKeyPath:@"title"];
    
}


#pragma mark - UISearchBarDelegate
/**
 * return NO to not become first responder
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

/**
 * // called when text starts editing
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self showCover];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)showCover{
    [self.view addSubview:self.cover];
    [self.cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.bottom.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self.tableView.mas_left);
        make.right.equalTo(self.tableView.mas_right);
        
    }];
    
}

/**
 *                 // called when text ends editing
 
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.cover removeFromSuperview];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    [searchBar setShowsCancelButton:NO animated:YES];
    
//    [self.homeSearchResultTableViewController.view removeFromSuperview];
    self.homeSearchResultTableViewController.view.hidden = YES;
    searchBar.text = nil;

}

/**
 * return NO to not resign first responder
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    
    return YES;
}

/**
 * // called when text changes (including clear)
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar.text.length) {
        self.homeSearchResultTableViewController.view.hidden = NO;
    
    
    
    
    //2.显示数据
        self.homeSearchResultTableViewController.searchText = searchText;
    }else{
//        [self.homeSearchResultTableViewController.view removeFromSuperview];
        self.homeSearchResultTableViewController.view.hidden = YES;

    }
}

/**
 * called before text changes
 */
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
   
    
    return  YES;
}


/**
 *  // called when keyboard search button pressed
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}
/**
 * called when cancel button pressed

 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}


@end
