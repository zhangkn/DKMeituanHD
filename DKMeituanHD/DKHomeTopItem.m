//
//  DKHomeTopItem.m
//  DKMeituanHD
//
//  Created by devzkn on 05/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeTopItem.h"

@interface DKHomeTopItem ()



@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *titleView;


@property (weak, nonatomic) IBOutlet UILabel *subTitleView;

@end

@implementation DKHomeTopItem

- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

+ (instancetype)homeTopItem{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"DKHomeTopItem" owner:self options:nil] lastObject];
}

- (void)addTarget:(nullable id)target action:(nonnull SEL)action{
    //添加监听对象，以及对应的方法
    [self.btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
}
- (void)setIcon:(NSString *)icon hightIcon:(NSString *)hightIcon{


    [self.btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:hightIcon] forState:UIControlStateHighlighted];

}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleView.text = title;
    
}


- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.subTitleView.text = subTitle;
    
}



@end
