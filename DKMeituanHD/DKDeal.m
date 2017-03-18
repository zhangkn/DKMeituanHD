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

MJCodingImplementation

#warning 只有将自定义对象实现nscoding 协议，才可以使用archivedDataWithRootObject 进行nsdata 的转换
//NSData *data = [NSKeyedArchiver  archivedDataWithRootObject:obj];//以2进制
//
//--- 团购数据存储


//
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    
//    
//}
//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
//    
//    return nil;
//}

@end
