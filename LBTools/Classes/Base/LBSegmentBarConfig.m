//
//  LBSegmentBarConfig.m
//  pu
//
//  Created by 张伯林 on 2017/11/23.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import "LBSegmentBarConfig.h"
#
@implementation LBSegmentBarConfig
+(instancetype)defaultConfig{
    LBSegmentBarConfig *config = [[LBSegmentBarConfig alloc]init];
    config.segmentBarBackColor = [UIColor clearColor];
    config.itemFont = [UIFont systemFontOfSize:15];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectColor = [UIColor redColor];
    
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 2;
    config.indicatorExtraW = 10;
    return config;
}

-(LBSegmentBarConfig *(^)(UIColor *))itemNC{
    return ^(UIColor *color){
        self.itemNormalColor = color;
        return self;
    };
}
- (LBSegmentBarConfig *(^)(UIColor *))itemSC
{
    
    return ^(UIColor *color) {
        self.itemSelectColor = color;
        return self;
    };
    
}


- (LBSegmentBarConfig *(^)(CGFloat))indicatorEW
{
    return ^(CGFloat w) {
        self.indicatorExtraW = w;
        return self;
    };
}
@end
