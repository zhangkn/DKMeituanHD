//
//  DKCityRegion.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKCityRegion.h"

@implementation DKCityRegion





- (NSString *)title{
    return self.name;
}

//- (NSString *)icon{
//    return self.icon;
//}
//
//- (NSString *)selectedIcon{
//    return self.highlighted_icon;
//}

- (NSArray *)subdata{
    return self.subregions;
}



@end
