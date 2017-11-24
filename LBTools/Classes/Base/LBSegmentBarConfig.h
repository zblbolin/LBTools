//
//  LBSegmentBarConfig.h
//  pu
//
//  Created by 张伯林 on 2017/11/23.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LBSegmentBarConfig : NSObject
+(instancetype)defaultConfig;

/** 背景颜色*/
@property (nonatomic, strong) UIColor *segmentBarBackColor;

/**
 未选中的颜色
 */
@property (nonatomic, strong) UIColor *itemNormalColor;

/**
 选中的颜色
 */
@property (nonatomic, strong) UIColor *itemSelectColor;

/**
 字体的属性
 */
@property (nonatomic, strong) UIFont *itemFont;

/**
 选择卡颜色
 */
@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, assign) CGFloat indicatorExtraW;

// 内部实现, 在这个里面写, 外界, 只负责调用
// 功能, 改变 itemNormalColor  itemSelectColor indicatorExtraW 的值
//
@property (nonatomic, copy,readonly)LBSegmentBarConfig *(^itemNC)(UIColor *color);
@property (nonatomic, copy, readonly) LBSegmentBarConfig *(^itemSC)(UIColor *color);
@property (nonatomic, copy, readonly) LBSegmentBarConfig *(^indicatorEW)(CGFloat w);
@end
