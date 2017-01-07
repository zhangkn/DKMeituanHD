//
//  DKHomeMainTableViewCell.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeMainTableViewCell.h"

@implementation DKHomeMainTableViewCell

+ (instancetype)tableVieCellWithModel:(DKCategoryModel *)model tableView:(UITableView *)tableView{
    DKHomeMainTableViewCell *cell = [self tableViewCellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)setModel:(DKCategoryModel *)model{
    _model = model;
    self.textLabel.text = model.name;
    [self.imageView setImage:[UIImage imageNamed:model.small_icon]];
    
    if (model.subcategories.count) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }    
    
}

+ (instancetype)tableViewCellWithTableView:(UITableView *)tableView{
    static NSString *identifuer = @"DKHomeSubTableViewCell";
    DKHomeMainTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:identifuer];
    
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifuer];
    }
    
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self ) {
        UIImageView *bg = [[UIImageView alloc] init];
        bg.image = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        selectedBg.image = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView = selectedBg;
    }
    return self;
}

@end
