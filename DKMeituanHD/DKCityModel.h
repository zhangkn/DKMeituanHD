//
//  DKCityModel.h
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKCityModel : NSObject



/**
 *区域数组
 */
@property (nonatomic,copy) NSArray *regions;

/**
 *声母简写
 */
@property (nonatomic,copy) NSString *pinYinHead;



/**
 *拼音
 */
@property (nonatomic,copy) NSString *pinYin;


/**
 *城市名字
 */
@property (nonatomic,copy) NSString *name;



@end
