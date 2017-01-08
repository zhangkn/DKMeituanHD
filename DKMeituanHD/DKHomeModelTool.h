//
//  DKHomeModelTool.h
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKHomeModelTool : NSObject
/**
 *获取分类模型数组
 */
+ (NSArray*) categoryModels;

+ (NSArray*) cityModels;

+ (NSArray*) cityGroupModels;

+ (NSArray*) cityModelsWithSeatchText:(NSString*)searchText;

+ (NSArray*) searchRegionsWithCityName:(NSString*)cityName;

/**
 排序模型数组的获取

 @return 排序模型数组
 */
+ (NSArray*)getSortModels;

@end
