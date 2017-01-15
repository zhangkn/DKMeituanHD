//
//  DKCenterLineLabel.m
//  DKMeituanHD
//
//  Created by devzkn on 15/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKCenterLineLabel.h"

@implementation DKCenterLineLabel

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
//     Drawing code
    
    [super drawRect:rect];
    //画线
    UIRectFill(CGRectMake(0, rect.size.height*0.5, rect.size.width, 1));
    
}


@end
