//
//  DKHomeDropdownView.h
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DKHomeDropdownView;


@protocol DKHomeDropdownViewDelegate <NSObject>

@optional
- (void)homeDropdownView:(DKHomeDropdownView*)homeDropdownView  didSelectedRowsInMainTable:(NSInteger)row;
- (void)homeDropdownView:(DKHomeDropdownView*)homeDropdownView  didSelectedRowsInSubTable:(NSInteger)row  inMainTable:(NSInteger)mainRow;;



@end

@protocol DKHomeDropdownViewData <NSObject>
@required
- (NSString*) title;
- (NSArray*)subdata;
@optional
- (NSString*)icon;
- (NSString*)selectedIcon;

@end

@protocol DKHomeDropdownViewDataSource <NSObject>
@required
/**
 左边的表格一共有多少行。

 @param homeDropdownView 下拉菜单

 @return 行数
 */
- (NSInteger)numberOfRowsInMainTableDKHomeDropdownView:(DKHomeDropdownView*)homeDropdownView;

- (id<DKHomeDropdownViewData>)  homeDropdownView:(DKHomeDropdownView*)homeDropdownView  subdataForRowsInMainTable:(NSInteger)row;

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

@property (nonatomic,assign) id<DKHomeDropdownViewDataSource> dataSource;
@property (nonatomic,assign) id<DKHomeDropdownViewDelegate> delegate;


+ (instancetype) homeDropdownView;

- (void) reloadData;


@end
