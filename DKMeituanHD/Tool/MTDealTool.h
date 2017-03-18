//
//  MTDealTool.h
//  美团HD
//
//  Created by apple on 14/11/27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DKDeal;

@interface MTDealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;


/**
 收藏总数

 @return int
 */
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(DKDeal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(DKDeal *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(DKDeal *)deal;



@end
