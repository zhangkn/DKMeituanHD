//
//  DKDeal.m
//  DKMeituanHD
//
//  Created by devzkn on 14/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKDeal.h"
#import "MJExtension.h"

@implementation DKDeal

- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

+ (NSArray *) dealsWithDictArray:(NSArray *)dicts{
    return [DKDeal objectArrayWithKeyValuesArray:dicts];
}

@end
