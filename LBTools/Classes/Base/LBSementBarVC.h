//
//  LBSementBarVC.h
//  pu
//
//  Created by 张伯林 on 2017/11/24.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSegmentBar.h"
@interface LBSementBarVC : UIViewController
@property(nonatomic,weak)LBSegmentBar *segmentBar;

-(void)setUpWithItems:(NSArray <NSString *>*)items childViewControllers:(NSArray <UIViewController *>*)childViewControllers;
@end
