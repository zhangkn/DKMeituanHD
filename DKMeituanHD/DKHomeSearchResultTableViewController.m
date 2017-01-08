//
//  DKHomeSearchResultTableViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeSearchResultTableViewController.h"
#import "DKHomeModelTool.h"
#import "DKConst.h"
/**
 *显示城市的搜索数据
 */
@interface DKHomeSearchResultTableViewController ()
/**
 *当前的搜索数据
 */
@property (nonatomic,strong) NSArray *models;

@end

@implementation DKHomeSearchResultTableViewController

- (void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    //获取搜索结果
    self.models = [DKHomeModelTool cityModelsWithSeatchText:searchText];
    //刷新数据
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"DKHomeSearchResultTableViewControllerUITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.models[indexPath.row] name];
    return cell;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"共%lu 个搜索结果",(unsigned long)self.models.count];
}


/**
 *发布通知给监听者
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // post notification
    //城市名称信息
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[self.models [indexPath.row] name]forKey:DKdidSelectCityNotificationKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DKdidSelectCityNotification object:self userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];// 自己的父控制器会执行dismissViewControllerAnimated ，因为本质上是父控制器被modal 出来的。
//    具体执行过程的判断--- 先判断自己是不是被modal出来的，如果不是，就会调用    self.parentViewController的dismissViewControllerAnimated
}



@end
