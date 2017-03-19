//
//  MTDealAnnotation.m
//  美团HD
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTDealAnnotation.h"

@implementation MTDealAnnotation
- (BOOL)isEqual:(MTDealAnnotation *)other
{
    return [self.title isEqual:other.title];
}
@end
