//
//  DKHomeDropdownView.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeDropdownView.h"

@interface DKHomeDropdownView ()



@end

@implementation DKHomeDropdownView

+ (instancetype)homeDropdownView{
    return [[[NSBundle mainBundle]loadNibNamed:@"DKHomeDropdownView" owner:nil options:nil]lastObject];
}

@end
