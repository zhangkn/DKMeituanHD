//
//  DKHomeModelTool.m
//  DKMeituanHD
//
//  Created by devzkn on 07/01/2017.
//  Copyright © 2017 hisun. All rights reserved.
//

#import "DKHomeModelTool.h"
#import "MJExtension.h"
#import "DKCategoryModel.h"
@implementation DKHomeModelTool

static NSArray *_categoryModels;

+ (void)initialize{
    [super initialize];
    if (_categoryModels == nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _categoryModels = [self getcategoryModels];
        });
    }
}

+ (NSArray*) getcategoryModels{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
//    NSArray *dictArray = [NSArray arrayWithContentsOfFile:plistPath];
//    NSArray  *tmp = [DKCategoryModel objectArrayWithKeyValuesArray:dictArray];//通过字典数据进行转换
//    NSArray  *tmp = [DKCategoryModel objectArrayWithFile:plistPath];//通过plist文件进行转换
        NSArray  *tmp = [DKCategoryModel objectArrayWithFilename:@"categories.plist"];//通过plist文件名称
    return tmp;
}


+ (NSArray*) categoryModels{
    return _categoryModels;
}


@end
