

#import "DkDealCell.h"
#import "DkDeal.h"
#import "UIImageView+WebCache.h"

@interface DKDealCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
/**
 属性名不能以new开头
 */
@property (weak, nonatomic) IBOutlet UIImageView *dealNewView; 
@end

@implementation DKDealCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 拉伸
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    // 平铺
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_dealcell"]];
    
    
    [self setAutoresizingMask:UIViewAutoresizingNone];
    
    
    
}

/**
 
重写setter
 @param deal 模型
 */
- (void)setDeal:(DKDeal *)deal
{
    _deal = deal;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.titleLabel.text = deal.title;
    self.descLabel.text = deal.desc;
    
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d", deal.purchase_count];
    
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥ %@", deal.current_price];
    NSUInteger dotLoc = [self.currentPriceLabel.text rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        // 超过2位小数
        if (self.currentPriceLabel.text.length - dotLoc > 3) {
            self.currentPriceLabel.text = [self.currentPriceLabel.text substringToIndex:dotLoc + 3];
        }
    }
    
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥ %@", deal.list_price];
    
    // 是否显示新单图片
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat= @"yyyy-MM-dd";
    NSString *nowStr = [fmt stringFromDate:[NSDate date]];
    // 隐藏: 发布日期 < 今天
    self.dealNewView.hidden = ([deal.publish_date compare:nowStr] == NSOrderedAscending);
}

- (void)drawRect:(CGRect)rect
{
    // 平铺
//    [[UIImage imageNamed:@"bg_dealcell"] drawAsPatternInRect:rect];
    // 拉伸
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}

+(instancetype)cellWithCollectionView:(UICollectionView *)view WithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath{
    DKDealCell *cell = [view dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {// ------并不会执行
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DKDealCell" owner:nil options:nil]lastObject];
        
    }
    return cell;
}
+(instancetype)cellWithDeal:(DKDeal *)deal collectionView:(UICollectionView *)view  WithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath{
    DKDealCell *cell = [self cellWithCollectionView:view WithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal = deal;
    return cell;
}

@end
