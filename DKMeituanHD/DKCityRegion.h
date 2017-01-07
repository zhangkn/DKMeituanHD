//
//  DKCityRegion.h
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKCityRegion : NSObject
/**
 * 区域名称
 */
@property (nonatomic,copy) NSString *name;

/**
 *子区域数组
 */
@property (nonatomic,copy) NSArray *subregions;



@end
