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
/**
 *c城市选择控制器
 */
@interface DKHomeCityViewController ()<UISearchBarDelegate>
@property (nonatomic,strong) NSArray *cityGroupModels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation DKHomeCityViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self Image:@"btn_navigation_close_hl" highlightedImage:@"btn_navigation_close" actionMethod:@selector(clickleftBarButtonItem)];
    
   self.cityGroupModels = [DKHomeModelTool cityGroupModels];
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    
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
}

/**
 * return NO to not resign first responder
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
/**
 *                 // called when text ends editing

 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
/**
 * // called when text changes (including clear)
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
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


@end
