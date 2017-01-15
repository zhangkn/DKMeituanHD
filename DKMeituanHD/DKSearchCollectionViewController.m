//
//  DKSearchCollectionViewController.m
//  DKMeituanHD
//
//  Created by devzkn on 15/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKSearchCollectionViewController.h"
#import "UIBarButtonItem+Extension.h"
@interface DKSearchCollectionViewController ()<UISearchBarDelegate>


/**
 关键词
 */
@property (nonatomic,copy)  NSString *keyword ;


@end

@implementation DKSearchCollectionViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
//    self.collectionView.backgroundColor = [UIColor grayColor];
    // 左边的返回
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self Image:@"icon_back" highlightedImage:@"icon_back_highlighted" actionMethod:@selector(back)];

    //普通控件成为self.navigationItem.titleView  可以设置size，如果是UISearchBar，则只能通过，将它添加到普通控件中进行设置size
    //    UIView *titleView = [[UIView alloc] init];
    //    titleView.width = 300;
    //    titleView.height = 35;
    //    titleView.backgroundColor = [UIColor redColor];
    //    self.navigationItem.titleView = titleView;
    
    // 中间的搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    //    searchBar.frame = titleView.bounds;
    //    [titleView addSubview:searchBar];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - ******** UISearchBarDelegate

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //请求服务器
     self.keyword = searchBar.text;
    [self loadNewDeals];
    [searchBar resignFirstResponder];
}

/**
 交给子类实现
 */
- (NSMutableDictionary*)params{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"city"] = self.selectedCityName;
    params[@"keyword"] = self.keyword;
//    params[@"region"] = self.selectedRegion;
//    params[@"category"] = self.selectedCategory;
//    params[@"sort"] = self.selectedDKHomeSortModel.value;
    return params;
}



@end
