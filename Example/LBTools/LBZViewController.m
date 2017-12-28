//
//  LBZViewController.m
//  LBTools
//
//  Created by 812920365@qq.com on 11/24/2017.
//  Copyright (c) 2017 812920365@qq.com. All rights reserved.
//

#import "LBZViewController.h"

#import "LBSementBarVC.h"
@interface LBZViewController ()
@property (nonatomic, weak) LBSementBarVC *segmentBarVC;
@end

@implementation LBZViewController

- (LBSementBarVC *)segmentBarVC {
    if (!_segmentBarVC) {
        LBSementBarVC *vc = [[LBSementBarVC alloc] init];
        [self addChildViewController:vc];
        _segmentBarVC = vc;
    }
    return _segmentBarVC;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentBarVC.segmentBar.frame = CGRectMake(0, 0, 300, 35);
    self.segmentBarVC.segmentBar.backgroundColor = [UIColor greenColor];
    self.navigationItem.titleView = self.segmentBarVC.segmentBar;
    
    self.segmentBarVC.view.frame = self.view.bounds;
    [self.view addSubview:self.segmentBarVC.view];
    
    
    NSArray *items = @[@"专辑", @"声音", @"下载中"];
    
    // 添加几个自控制器
    // 在contentView, 展示子控制器的视图内容
    
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor yellowColor];
    
    
    [self.segmentBarVC setUpWithItems:items childViewControllers:@[vc1, vc2, vc3]];
    
    
    //        XMGSegmentBarConfig *config = [XMGSegmentBarConfig defaultConfig];
    //        config.itemFont = ;
    //
    //        self.segmentBarVC.segmentBar.config = config;
    
    //添加选项卡的基本设置
    [self.segmentBarVC.segmentBar updateWithConfig:^(LBSegmentBarConfig *config) {
        
        //            config.segmentBarBackColor = [UIColor cyanColor];
        //            config.itemNormalColor = [UIColor brownColor];
        //            config.itemSelectColor = [UIColor yellowColor];
        //            config.itemSC([UIColor brownColor]).itemNC([UIColor yellowColor]);
        
        config.itemNC([UIColor redColor]).itemSC([UIColor orangeColor]).indicatorEW(10);
        //            config.itemFont = [UIFont fontWithName:@"Zapfino" size:10];
        //
        //            config.indicatorHeight = 5;
        //            config.indicatorColor = [UIColor blueColor];
        //            config.indicatorExtraW = 0;
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
