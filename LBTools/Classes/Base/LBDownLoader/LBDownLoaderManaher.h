//
//  LBDoenLoaderManaher.h
//  LBDownLoadListern
//
//  Created by 张伯林 on 2017/12/6.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBDownLoader.h"
@interface LBDownLoaderManaher : NSObject

//单利
//1. 无论通过怎样的方式,创建出来的只有一个实例(alloc copy mutableCopy)
//2.通过某种方式可以获取同一个对象,但是也可以通过其他方方式创建出新的对象

+(instancetype)shareInstance;

-(void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlcokType)progressBlock sucess:(SucessBlockType) sucessBlock fail:(FailBlcokType)failBlock stateChange:(StateChangeType) stateChange;
-(void)pauseWithURL:(NSURL *)url;
-(void)resumeWithURL:(NSURL *)url;
-(void)cancelWithURL:(NSURL *)url;

-(void)pauseAll;
-(void)resumeAll;
-(void)cancelAll;
@end
