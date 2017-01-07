//
//  DKHomeSearchResultTableViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeSearchResultTableViewController.h"
#import "DKHomeModelTool.h"
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

@end
