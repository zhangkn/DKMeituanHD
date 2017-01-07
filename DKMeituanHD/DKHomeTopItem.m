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




@end

@implementation DKHomeTopItem


+ (instancetype)homeTopItem{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"DKHomeTopItem" owner:self options:nil] lastObject];
}

- (void)addTarget:(nullable id)target action:(nonnull SEL)action{
    //添加监听对象，以及对应的方法
    [self.btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
}
@end
