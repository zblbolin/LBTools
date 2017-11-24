//
//  LBSegmentBar.m
//  pu
//
//  Created by 张伯林 on 2017/11/23.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import "LBSegmentBar.h"
#import "UIView+LBSegmentBar.h"

#define kMinMargin 30

@interface LBSegmentBar ()
{
    // 记录最后一次点击的按钮
    UIButton *_lastBtn;
}
/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;
/**用来存储控件配置的数据*/
@property(nonatomic,strong)LBSegmentBarConfig *config;
/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/**用来存放选项卡上的按钮*/
@property(nonatomic,strong)NSMutableArray <UIButton *>*itemBtns;
@end
@implementation LBSegmentBar
+(instancetype)segmentBarWithFrame:(CGRect)frame{
    LBSegmentBar *segmentBar = [[LBSegmentBar alloc]initWithFrame:frame];
    
    //添加内容承载视图
    return segmentBar;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.segmentBarBackColor;
    }
    return self;
}
-(void)updateWithConfig:(void (^)(LBSegmentBarConfig *))configBlock{
    if (configBlock) {
        configBlock(self.config);
    }
    
    //按照更新之后的self.config进行刷新
    self.backgroundColor = self.config.segmentBarBackColor;
    
    
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    //过滤数据
    if (self.itemBtns.count == 0 || selectIndex < 0 || selectIndex > self.itemBtns.count - 1) {
        return;
    }
    _selectIndex = selectIndex;
    UIButton *btn = self.itemBtns[selectIndex];
    [self btnClick:btn];
}
-(void)setItems:(NSArray<NSString *> *)items{
    _items = items;
    
    //删除之前添加的选择组件
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    
    //根据所有的选线数据源创建Button ,添加到内容视图上
    for (NSString *item in items) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemFont;
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
    }
    // 手动刷新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    //计算margin
    CGFloat totalBtnWidth = 0;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
        totalBtnWidth += btn.width;
    }
    
    CGFloat caculateMargin = (self.width - totalBtnWidth) / (self.itemBtns.count + 1);
    if (caculateMargin < kMinMargin) {
        caculateMargin = kMinMargin;
    }
    
    CGFloat lastX = caculateMargin;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
        
        btn.y = 0;
        btn.x = lastX;
        lastX += btn.width + caculateMargin;
    }
    self.contentView.contentSize = CGSizeMake(lastX, 0);
    
    if (self.itemBtns.count == 0) {
        return;
    }
    
    UIButton *btn = self.itemBtns[self.selectIndex];
    self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
    self.indicatorView.centerX = btn.centerX;
    self.indicatorView.height = self.config.indicatorHeight;
    self.indicatorView.y = self.height - self.indicatorView.height;
}
#pragma mark - button的点击事件的相对处理
- (void)btnClick: (UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:btn.tag fromIndex:_lastBtn.tag];
    }
    _selectIndex = btn.tag;
    _lastBtn.selected = NO;
    btn.selected = YES;
    _lastBtn = btn;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
        self.indicatorView.centerX = btn.centerX;
    }];
    
    //scrollView的偏移量
    //1.先滚动到btn的位置
    CGFloat scrollX = btn.centerX - self.contentView.width * 0.5;
    
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.width) {
        scrollX = self.contentView.contentSize.width - self.contentView.width;
    }
    
    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}
#pragma maek --- 懒加载

- (NSMutableArray<UIButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}
- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}
- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorHeight;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorColor;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}
-(LBSegmentBarConfig *)config{
    if (!_config) {
        _config = [LBSegmentBarConfig defaultConfig];
    }
    return _config;
}
@end
