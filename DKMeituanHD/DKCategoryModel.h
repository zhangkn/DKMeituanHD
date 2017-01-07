//
//  DKCategoryModel.h
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKCategoryModel : NSObject
/**
 *显示在下拉菜单的小图标
 */
@property (nonatomic,copy) NSString *small_icon;
@property (nonatomic,copy) NSString *small_highlighted_icon;
/**
 * 显示在导航栏顶部的大图标
 */
@property (nonatomic,copy) NSString *icon;

@property (nonatomic,copy) NSString *highlighted_icon;
/**
 *显示在地图上的图标
 */
@property (nonatomic,copy) NSString *map_icon;

/**
 * 子类别
 */
@property (nonatomic,copy) NSArray *subcategories;

/**
 *分类名称
 */
@property (nonatomic,copy) NSString *name;




@end
