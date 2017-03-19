//
//  DKHomeModelTool.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeModelTool.h"
#import "MJExtension.h"
#import "DKCategoryModel.h"

#import "DKCityGroupModel.h"


#import "DKCityModel.h"
#import "DKHomeSortModel.h"


@implementation DKHomeModelTool

static NSArray *_categoryModels;

static NSArray *_cityModels;

static NSArray *_cityGroupModels;

static NSArray *_sortModels;



#if 1
+ (void)initialize{
    [super initialize];
    if (_categoryModels == nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _categoryModels = [self getcategoryModels];
            _cityModels = [self getCityModels];
            _cityGroupModels = [self getCityGroupModels];
            _sortModels = [DKHomeSortModel objectArrayWithFilename:@"sorts.plist"];
        });
    }
}
#endif

+ (NSArray*)getSortModels{
    return _sortModels;
}


/**
 *或者使用懒加载
 */

+ (NSArray *)categoryModels{
    if (_categoryModels == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _categoryModels = [self getcategoryModels];
        });
        
    }
    return _categoryModels;
}

+ (NSArray *)cityModels{
    if (_cityModels == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _cityModels = [self getCityModels];
            
        });
    }
    return _cityModels;
}

+ (NSArray *)cityGroupModels{
    if (_cityGroupModels == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _cityGroupModels = [self getCityGroupModels];
            
        });
    }
    return _cityGroupModels;
}




+(NSArray *)getCityGroupModels{
    return [DKCityGroupModel objectArrayWithFilename:@"cityGroups.plist"];
}

+ (NSArray*) getcategoryModels{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
//    NSArray *dictArray = [NSArray arrayWithContentsOfFile:plistPath];
//    NSArray  *tmp = [DKCategoryModel objectArrayWithKeyValuesArray:dictArray];//通过字典数据进行转换
//    NSArray  *tmp = [DKCategoryModel objectArrayWithFile:plistPath];//通过plist文件进行转换
        NSArray  *tmp = [DKCategoryModel objectArrayWithFilename:@"categories.plist"];//通过plist文件名称
    return tmp;
}

+ (NSArray*) getCityModels {
    //    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
    //    NSArray *dictArray = [NSArray arrayWithContentsOfFile:plistPath];
    //    NSArray  *tmp = [DKCategoryModel objectArrayWithKeyValuesArray:dictArray];//通过字典数据进行转换
    //    NSArray  *tmp = [DKCategoryModel objectArrayWithFile:plistPath];//通过plist文件进行转换
    NSArray  *tmp = [DKCityModel objectArrayWithFilename:@"cities.plist"];//通过plist文件名称
    return tmp;
}



//+ (NSArray*) categoryModels{
//    return _categoryModels;
//}
//
//+ (NSArray*) cityModels{
//    return _cityModels;
//
//}
//
//+ (NSArray*) cityGroupModels{
//    return _cityGroupModels;
//    
//}

+ (NSArray *)cityModelsWithSeatchText:(NSString *)searchText{
//    方式一
    //从 _cityModels  进行搜索，只要DKCityModel 中/**    *声母简写    */    @property (nonatomic,copy) NSString *pinYinHead;    /**     *拼音     */    @property (nonatomic,copy) NSString *pinYin;    /**     *城市名字     */    @property (nonatomic,copy) NSString *name; 任意一个字符串包含searchText 即可
//    [self searchcityModelsWithSeatchText:searchText];
    /** 方式二： 谓词的使用
     *
     
     
     2.5.2         对象操作
     针对数组的情况
     @distinctUnionOfObjects：返回指定属性去重后的值的数组
     @unionOfObjects：返回指定属性的值的数组，不去重
     属性的值不能为空，否则产生异常。
     
     */
    
    /**
     *
     //1）取出日期分组  去重
     NSArray *arDistinct = [maTemp valueForKeyPath:@"@distinctUnionOfObjects.strDateCreated"];
     //2）构建排序规则NSComparator
     NSComparator cmptr = ^(id obj1, id obj2){
     NSString *strData1 = obj1;
     NSString *strData2 = obj2;
     
     NSComparisonResult ret = [strData1 compare:strData2];
     return ret;
     //        if (ret == NSOrderedAscending)
     //
     //        if (aEcouponData1.nAmount > aEcouponData2.nAmount) {
     //            return (NSComparisonResult)NSOrderedDescending;
     //        }
     //
     //        if (aEcouponData1.nAmount < aEcouponData2.nAmount) {
     //            return (NSComparisonResult)NSOrderedAscending;
     //        }
     //        return (NSComparisonResult)NSOrderedSame;
     };
     
     //     3）按数字从小到大进行排序
     NSArray  *arSorted = [arDistinct sortedArrayUsingComparator:cmptr];//排序
     arSorted = arSorted.reverseObjectEnumerator.allObjects;//顺序取反
     
     
     
     NSPredicate *predicate = nil;
     //     4）按照日期进行分组
     for (NSString *strDateCreated in arSorted)
     {
     predicate = [NSPredicate predicateWithFormat:@"strDateCreated == %@", strDateCreated];
     NSArray *arFiltered = [maTemp filteredArrayUsingPredicate:predicate];//以一定的条件（特定日期）过滤maTemp数组，即进行大数据搜索。
     
     OrderQueryGroupData *data = [OrderQueryGroupData alloc];
     data.strDateCreated = strDateCreated;
     data.maOrderData = [NSMutableArray arrayWithArray:arFiltered];
     data.maOrderDataF = [IPOrderDataFrame frameListWith:data.maOrderData];
     [self.maOrderQuery addObject:data];
     }


     */
    //方式二： 谓词技术的使用
    searchText  = searchText.uppercaseString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" pinYinHead.uppercaseString  contains %@ or  name.uppercaseString  contains %@  or pinYin.uppercaseString  contains %@ ",searchText,searchText,searchText];
    return [_cityModels filteredArrayUsingPredicate:predicate];
    
}

+ (NSArray *)searchcityModelsWithSeatchText:(NSString *)searchText{
    
    NSMutableArray *array = [NSMutableArray array];
    searchText = [searchText uppercaseString];
    for (DKCityModel *obj in _cityModels) {
        if ([obj.name.uppercaseString containsString:searchText] || [obj.pinYin.uppercaseString containsString:searchText] || [obj.pinYinHead.uppercaseString containsString:searchText]) {
            [array addObject:obj];
        }
    }
    return array;
}

+ (NSArray *)searchRegionsWithCityName:(NSString *)cityName{
    if (cityName == nil) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" name == %@",cityName];
    NSArray *predicateArray = [[self cityModels] filteredArrayUsingPredicate:predicate];
    if (predicateArray.count) {
        DKCityModel* model =  (DKCityModel*)predicateArray[0];
        return model.regions;
    }else{
        return nil;
    }
    
}



+ (DKCategoryModel *)categoryWithDeal:(DKDeal *)deal
{
    NSArray *cs = [self categoryModels];
    NSString *cname = [deal.categories firstObject];//deal 所属的种类名称
    
    for (DKCategoryModel *c in cs) {
        if ([cname isEqualToString:c.name]) return c;
        if ([c.subcategories containsObject:cname]) return c;
    }
    return nil;
}




@end
