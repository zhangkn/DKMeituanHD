//
//  DKHomeSortButton.m
//  DKMeituanHD
//
//  Created by devzkn on 08/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeSortButton.h"

@implementation DKHomeSortButton


- (void)setModel:(DKHomeSortModel *)model{
    _model = model;
    
    [self setTitle:model.label forState:UIControlStateNormal];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        
    }
    return self;
}

@end
