//
//  LBDownLoader.h
//  LBDownLoadListern
//
//  Created by 张伯林 on 2017/11/29.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM (NSUInteger,LBDownLoaderState){
    LBDownLoaderStatePause,
    LBDownLoaderStateDownLoading,
    LBDownLoaderStatePauseSuccess,
    LBDownLoaderStatePauseFailed
};

typedef void (^DownLoadInfoType)(long long totalSize);
typedef void (^ProgressBlcokType)(float progress);
typedef void (^SucessBlockType)(NSString *cachePath);
typedef void (^FailBlcokType)(NSError *error);
typedef void (^StateChangeType)(LBDownLoaderState state);

//一个下载器,对应一个下载任务
@interface LBDownLoader : NSObject
//当前下载器的状态
@property(nonatomic,assign,readonly)LBDownLoaderState state;
@property(nonatomic,copy)StateChangeType stateChange;
//事件和数据
@property(nonatomic,copy)DownLoadInfoType downLoadInfo;


@property(nonatomic,assign,readonly)float progress;
@property(nonatomic,copy)ProgressBlcokType progressChange;
@property(nonatomic,copy)SucessBlockType sucessBlock;
@property(nonatomic,copy)FailBlcokType failBlock;

-(void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlcokType)progressBlock sucess:(SucessBlockType) sucessBlock fail:(FailBlcokType)failBlock stateChange:(StateChangeType) stateChange;
-(void)downLoader:(NSURL *)url;
-(void)resumeCurrentTask;
-(void)pauseCurrentTask;
-(void)cacelCurrentTask;
-(void)cacelAndClean;
@end
