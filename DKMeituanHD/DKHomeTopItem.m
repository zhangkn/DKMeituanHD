//
//  DKHomeTopItem.m
//  DKMeituanHD
//
//  Created by devzkn on 05/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeTopItem.h"

@implementation DKHomeTopItem


+ (instancetype)homeTopItem{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"DKHomeTopItem" owner:self options:nil] lastObject];
}
@end
