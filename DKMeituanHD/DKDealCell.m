

#import "DkDealCell.h"
#import "DkDeal.h"
#import "UIImageView+WebCache.h"

@interface DKDealCell()<DKDealCellDelegate>
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



/**
 属性名不能以new开头
 */
//@property (weak, nonatomic) IBOutlet UIImageView *dealNewView;
@property (weak, nonatomic) IBOutlet UIButton *cover;
//- (IBAction)coverClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *checkView;
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
    
    // 根据模型属性来控制cover的显示和隐藏
    self.cover.hidden = !deal.isEditting;
    
    // 根据模型属性来控制打钩的显示和隐藏
    self.checkView.hidden = !deal.isChecking;
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



/**
 蒙版的点击事件处理

 */
- (IBAction)coverClick:(UIButton *)sender {
    // 设置模型
    self.deal.checking = !self.deal.isChecking;//改变当前模型的勾选状态
    // 直接修改状态
    self.checkView.hidden = !self.checkView.isHidden;
    
    if ([self.delegate respondsToSelector:@selector(dealCellCheckingStateDidChange:)]) {
        [self.delegate dealCellCheckingStateDidChange:self];
    }
}


@end
