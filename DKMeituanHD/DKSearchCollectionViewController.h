//
//  DKSearchCollectionViewController.h
//  DKMeituanHD
//
//  Created by devzkn on 15/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKDealsCollectionViewController.h"

@interface DKSearchCollectionViewController : DKDealsCollectionViewController


/**
 *当前选中的城市名称
 */
@property (nonatomic,copy) NSString *selectedCityName;


@end
