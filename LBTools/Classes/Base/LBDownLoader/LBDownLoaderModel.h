//
//  LBDownLoaderModel.h
//  LBDownLoadListern
//
//  Created by 张伯林 on 2017/12/6.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBDownLoader.h"
@interface LBDownLoaderModel : NSObject
@property(nonatomic,copy)NSString *urlMD5;
@property(nonatomic,strong)LBDownLoader *downLoader;
@property(nonatomic,assign)BOOL isDownLoading;
@end
