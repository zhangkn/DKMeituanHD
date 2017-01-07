//
//  DKHomeDropdownView.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeDropdownView.h"
#import "DKCategoryModel.h"
#import "DKHomeMainTableViewCell.h"
#import "DKHomeSubTableViewCell.h"

@interface DKHomeDropdownView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (strong, nonatomic)  DKCategoryModel *selectedModel;




@end

@implementation DKHomeDropdownView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;//控件从xib 进行加载的时候，可以设置autoresizingMask，避免在xib 设置控件的大小没效果。 即控件不随着父空间的size进行自动调整。这样此控件的子控件在xib 设置的自动布局将生效
    
}

+ (instancetype)homeDropdownView{
    return [[[NSBundle mainBundle]loadNibNamed:@"DKHomeDropdownView" owner:nil options:nil]lastObject];
}


- (void)setModels:(NSArray *)models{
    _models = models;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mainTableView) {
        return self.models.count;
    }else if (tableView == self.subTableView){
        return [[(DKCategoryModel*)self.selectedModel subcategories]count];
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        DKCategoryModel *model = self.models[indexPath.row];
        DKHomeMainTableViewCell *mainCell = [DKHomeMainTableViewCell tableVieCellWithModel:model tableView:tableView];
        return mainCell;
    }else if (tableView == self.subTableView){
        DKHomeSubTableViewCell *subCell = [DKHomeSubTableViewCell tableViewCellWithTableView:tableView];
        subCell.textLabel.text = self.selectedModel.subcategories[indexPath.row];
        
        return subCell;
    }else{
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        DKCategoryModel *model = self.models[indexPath.row];
        if (model.subcategories.count) {
            self.selectedModel = model;
        }else{
            self.selectedModel = nil;
        }
        [self.subTableView reloadData];
    }
    
}






@end
