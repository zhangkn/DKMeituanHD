//
//  DKCategoryModel.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKCategoryModel.h"
/**
 *分类模型
 */
@implementation DKCategoryModel


- (NSString *)title{
    return self.name;
}

- (NSString *)icon{
    return self.small_icon;
}

- (NSString *)selectedIcon{
    return self.small_highlighted_icon;
}

- (NSArray *)subdata{
    return self.subcategories;
}

@end
