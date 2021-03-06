
#import <UIKit/UIKit.h>

#import "DKDeal.h"
@class DKDeal, DKDealCell;

@protocol DKDealCellDelegate <NSObject>



@optional

- (void)dealCellCheckingStateDidChange:(DKDealCell *)cell;

@end


@interface DKDealCell : UICollectionViewCell

@property (nonatomic, weak) id<DKDealCellDelegate> delegate;



//自定义视图的现实的数据来源于模型，即使用模型装配自定义视图的显示内容
@property (nonatomic,strong) DKDeal *deal;//视图对应的模型，是视图提供给外界的接口
+ (instancetype) cellWithCollectionView:(UICollectionView *) view WithReuseIdentifier:(NSString*)reuseIdentifier forIndexPath:(NSIndexPath*)indexPath;

/**
 通过数据模型设置视图内容，可以让视图控制器不需要了解视图的细节
 */
+ (instancetype) cellWithDeal:(DKDeal *) deal collectionView:(UICollectionView *)view WithReuseIdentifier:(NSString*)reuseIdentifier forIndexPath:(NSIndexPath*)indexPath;



@end
