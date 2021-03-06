
#import "UIBarButtonItem+Extension.h"

#import "UIView+Extension.h"

#import "UIView+AutoLayout.h"
#import "Foundation+Log.m"
#import "DKHomeModelTool.h"
#import "DPRequest.h"
#import "DPAPI.h"

#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif


#define DKColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DkGlobalBg DKColor(230, 230, 230)

#define    DKDealCellSize   305

#define   DKCellPagesize  9


extern NSString *const DKdidSelectCityNotification;
extern NSString *const DKdidSelectCityNotificationKey ;


extern NSString *const DKdidClickSortButonNotification;
extern NSString *const DKdidClickSortButonNotificationValueKey ;

/**
 *分类相关的通知
 */
extern NSString *const DKdidClickCategoryTableNotificationInfosubTitleKey;
extern NSString *const DKdidClickCategoryTableNotificationInfoTitleKey;
extern NSString *const DKdidClickCategoryTableNotificationInfoModelKey;
extern NSString *const DKdidClickCategoryTableNotification;
/**
 *城市相关的通知
 */
extern NSString *const DKdidClickCityTableTableNotification;
extern NSString *const DKdidClickCityTableTableNotificationInfoTitleKey;
extern NSString *const DKdidClickCityTableTableNotificationInfoSubTitleKey;
extern NSString *const DKdidClickCityTableTableNotificationInfoModelKey;


/**
 团购收藏的状态监听相关的key
 */
extern NSString *const MTCollectStateDidChangeNotification;
extern NSString *const MTIsCollectKey;
extern NSString *const MTCollectDealKey;


/** 
 团购cell 的ID
 */
extern  NSString *const DKDealCellReuseIdentifier;
/**按钮常用字符串 */
extern  NSString *const DKDone;
extern  NSString *const DKEdit;

extern NSString *const DkSelectAllTitle ;

extern NSString *const DkUNSelectAllTitle;

extern NSString *const DkDeleteAllTitle ;




