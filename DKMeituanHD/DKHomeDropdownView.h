//
//  DKHomeDropdownView.h
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DKHomeDropdownView;

@protocol DKHomeDropdownViewDataSource <NSObject>
@required




- (NSInteger)numberOfRowsInMainTableDKHomeDropdownView:(DKHomeDropdownView*)homeDropdownView;


@end

/**
 *首页的下拉菜单，有两个tableview组成
 */
@interface DKHomeDropdownView : UIView


/**
 *真正的MVC思想：
 M 和V 是不存在依赖关系。就行UIKit 中的UItableview一样，什么样的数据M都可以展示。
 V 提供一套数据源协议（代理），向外界索要数据。即向数据源对象增加一套统一的协议方法，来规范数据源对象
 ps:  而非容易想到的，将数据通过属性直接提供给V。这样会导致数据源的单一性
 
 */


@property (nonatomic,strong) NSArray *models;


+ (instancetype) homeDropdownView;


@end
