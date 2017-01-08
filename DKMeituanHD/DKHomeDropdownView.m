//
//  DKHomeDropdownView.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeDropdownView.h"
//#import "DKCategoryModel.h"
#import "DKHomeMainTableViewCell.h"
#import "DKHomeSubTableViewCell.h"

@interface DKHomeDropdownView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (strong, nonatomic)  id<DKHomeDropdownViewData> selectedModel;




@end

@implementation DKHomeDropdownView

- (void)reloadData{
    [self.mainTableView reloadData];
}


- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;//控件从xib 进行加载的时候，可以设置autoresizingMask，避免在xib 设置控件的大小没效果。 即控件不随着父空间的size进行自动调整。这样此控件的子控件在xib 设置的自动布局将生效
    
}

/**
 实例的实现

 @return 实例对象
 */
+ (instancetype)homeDropdownView{
    return [[[NSBundle mainBundle]loadNibNamed:@"DKHomeDropdownView" owner:nil options:nil]lastObject];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mainTableView) {
        if ([self.dataSource respondsToSelector:@selector(numberOfRowsInMainTableDKHomeDropdownView:)]) {
            return [self.dataSource numberOfRowsInMainTableDKHomeDropdownView:self];
        }else{
            return 0;
        }
        
    }else if (tableView == self.subTableView){
        return [self.selectedModel subdata].count;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        if ([self.dataSource respondsToSelector:@selector(homeDropdownView:subdataForRowsInMainTable:)]) {
            id<DKHomeDropdownViewData> model = [self.dataSource homeDropdownView:self subdataForRowsInMainTable:indexPath.row];
            DKHomeMainTableViewCell *mainCell = [DKHomeMainTableViewCell tableVieCellWithModel:model tableView:tableView];
            return mainCell;

        }else{
            return nil;
        }
    }else if (tableView == self.subTableView){
        
        DKHomeSubTableViewCell *subCell = [DKHomeSubTableViewCell tableViewCellWithTableView:tableView];
        subCell.textLabel.text = [self.selectedModel subdata] [indexPath.row];
        
        return subCell;
    }else{
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        
        if ([self.dataSource respondsToSelector:@selector(homeDropdownView:subdataForRowsInMainTable:)]) {
            id<DKHomeDropdownViewData> model = [self.dataSource homeDropdownView:self subdataForRowsInMainTable:indexPath.row];
            if ([model subdata].count) {
                self.selectedModel = model;
            }else{// ------没有子类的情况
                self.selectedModel = nil;
            }
            
            
        }else{// ------数据源代理对象没有实现协议的情况
            self.selectedModel = nil;
        }
        // ------更新数据
        [self.subTableView reloadData];
    }
    
}






@end
