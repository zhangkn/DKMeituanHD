//
//  DKDealsCollectionViewController.h
//  DKMeituanHD
//
//  Created by devzkn on 15/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKConst.h"

#import "DKDeal.h"
#import "Foundation+Log.m"
#import "DKCategoryViewController.h"
#import "DKHomeTopItem.h"
#import "DKHomeAddressViewController.h"
#import "DKHomeModelTool.h"
#import "DKHomeSortViewController.h"
#import "DKHomeSortModel.h"
#import "DKCategoryModel.h"
#import "DKCityModel.h"
#import "DKCityGroupModel.h"
#import "DKDealCell.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#define   cellSize   305

@interface DKDealsCollectionViewController : UICollectionViewController <DPRequestDelegate>



- (void) loadNewDeals;

- (NSMutableDictionary*)params;

@end
