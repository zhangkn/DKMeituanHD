//
//  DKHomeModelTool.h
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKCategoryModel.h"
#import "DKDeal.h"

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


/**
 根据deal 来获取对应的区域模型


 */
+ (DKCategoryModel *)categoryWithDeal:(DKDeal *)deal;

@end
