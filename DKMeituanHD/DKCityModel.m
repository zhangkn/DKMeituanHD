//
//  DKCityModel.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKCityModel.h"
#import "DKCityRegion.h"
#import "MJExtension.h"

@implementation DKCityModel


/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class
 */
- (NSDictionary *)objectClassInArray{
    return @{@"regions": [DKCityRegion class]};
}




@end
