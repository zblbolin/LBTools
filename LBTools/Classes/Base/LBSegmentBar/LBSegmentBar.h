//
//  LBSegmentBar.h
//  pu
//
//  Created by 张伯林 on 2017/11/23.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSegmentBarConfig.h"

@class LBSegmentBar;
@protocol LBSegmentBarDelegate <NSObject>

/**
 代理方法, 告诉外界, 内部的点击数据
 
 @param segmentBar segmentBar
 @param toIndex    选中的索引(从0开始)
 @param fromIndex  上一个索引
 */
- (void)segmentBar: (LBSegmentBar *)segmentBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end
@interface LBSegmentBar : UIView
/**代理*/
@property(nonatomic,weak)id<LBSegmentBarDelegate>delegate;
/**数据源*/
@property(nonatomic,strong)NSArray <NSString *>*items;
/**当前选中的索引,双向设置*/
@property(nonatomic,assign)NSInteger selectIndex;
/**
 快速创建一个选项卡控件

 @param frame 选项卡的frame
 @return 选项卡控件
 */
+(instancetype)segmentBarWithFrame:(CGRect)frame;
-(void)updateWithConfig:(void(^)(LBSegmentBarConfig *config))configBlock;

@end
