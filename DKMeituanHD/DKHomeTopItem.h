//
//  DKHomeTopItem.h
//  DKMeituanHD
//
//  Created by devzkn on 05/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKHomeTopItem : UIView


@property (nullable,nonatomic,copy) NSString *title;
@property (nullable,nonatomic,copy) NSString *subTitle;

- (void) setIcon:( nullable NSString*)icon hightIcon:( nullable NSString*)hightIcon;



+ ( nullable instancetype)homeTopItem;

/**
 *addTarget  设置item的监听器
 
 此方法适用于简单的事件监听
 */
- (void)addTarget:( nullable id)target action:(nonnull SEL)action;



@end
