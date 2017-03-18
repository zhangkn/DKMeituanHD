//
//  DKDealTool.m
//  美团HD
//
//  Created by apple on 14/11/27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTDealTool.h"
#import "FMDB.h"
#import "DKDeal.h"

#import "DKConst.h"
@implementation MTDealTool

static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+ (NSArray *)collectDeals:(int)page
{
    int pos = (page - 1) * DKCellPagesize;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, DKCellPagesize];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        DKDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}



/**
 最好isCollected先判断数据库中是否存在，只有不存在的时候才进行插入，存在进行更新即可

 @param deal
 */
+ (void)addCollectDeal:(DKDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}

/**
   当存储的是nsdata 对象的时候，进行数据更新最好使用executeUpdateWithFormat

 @param deal
 */
+ (void)removeCollectDeal:(DKDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}



/**
 判断是否收藏


 @return bool
 */
+ (BOOL)isCollected:(DKDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
//#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}

+ (int)collectDealsCount
{    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}

@end
