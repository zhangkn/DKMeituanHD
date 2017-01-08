//
//  DKHomeMainTableViewCell.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeMainTableViewCell.h"

@implementation DKHomeMainTableViewCell

+ (instancetype)tableVieCellWithModel:( id<DKHomeDropdownViewData>)model tableView:(UITableView *)tableView{
    DKHomeMainTableViewCell *cell = [self tableViewCellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)setModel:(id<DKHomeDropdownViewData>)model{
    _model = model;
    self.textLabel.text = [model title];
    
    if ([model respondsToSelector:@selector(icon)]) {
        [self.imageView setImage:[UIImage imageNamed:[model icon]]];
    }
    
    if ([model respondsToSelector:@selector(selectedIcon)]) {
        self.imageView.highlightedImage = [UIImage imageNamed:[model selectedIcon]];
    }
    
    
    if ([model subdata].count) {
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
