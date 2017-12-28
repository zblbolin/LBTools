//
//  LBDoenLoaderManaher.m
//  LBDownLoadListern
//
//  Created by 张伯林 on 2017/12/6.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import "LBDownLoaderManaher.h"
#import "NSString+LB.h"

#define LB_MAX_DOWNLOADERNUMBER 5
@interface LBDownLoaderManaher()<NSCopying,NSMutableCopying>

@property(nonatomic,strong)LBDownLoader *downLoader;

@property(nonatomic,strong)NSMutableDictionary *downLoadInfo;
@end
@implementation LBDownLoaderManaher

static LBDownLoaderManaher *_shareInstance;
+(instancetype)shareInstance{
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc]init];
    }
    return _shareInstance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}
-(id)copyWithZone:(NSZone *)zone{
    return _shareInstance;
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return _shareInstance;
}
//key: md5(url) value:LBDoenLoaderManaher
-(NSMutableDictionary *)downLoadInfo{
    if (!_downLoadInfo) {
        _downLoadInfo = [NSMutableDictionary dictionary];
    }
    return _downLoadInfo;
}
-(void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlcokType)progressBlock sucess:(SucessBlockType) sucessBlock fail:(FailBlcokType)failBlock stateChange:(StateChangeType) stateChange{
    //1. url
    NSString *urlMD5 = [url.absoluteString md5];
    
    //2. 根据urlMD5,查找相应的下载器
    LBDownLoader *downLoader = self.downLoadInfo[urlMD5];
    if (downLoader == nil) {
        downLoader = [[LBDownLoader alloc]init];
        self.downLoadInfo[urlMD5] = downLoader;
    }
    [downLoader downLoader:url downLoadInfo:downLoadInfo progress:progressBlock sucess:^(NSString *cachePath) {
        //拦截block
        [self.downLoadInfo removeObjectForKey:urlMD5];
        sucessBlock(cachePath);
    } fail:failBlock stateChange:stateChange];
}

-(void)pauseWithURL:(NSURL *)url{
    NSString *urlMD5 = [url.absoluteString md5];
    LBDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader pauseCurrentTask];
}
-(void)resumeWithURL:(NSURL *)url{
    NSString *urlMD5 = [url.absoluteString md5];
    LBDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader resumeCurrentTask];
}
-(void)cancelWithURL:(NSURL *)url{
    NSString *urlMD5 = [url.absoluteString md5];
    LBDownLoader *downLoader = self.downLoadInfo[urlMD5];
    [downLoader cacelAndClean];
    [self.downLoadInfo removeObjectForKey:urlMD5];
}

-(void)pauseAll{
    [self.downLoadInfo.allValues performSelector:@selector(pauseCurrentTask) withObject:nil];
}
-(void)resumeAll{
    [self.downLoadInfo.allValues performSelector:@selector(resumeCurrentTask) withObject:nil];
}
-(void)cancelAll{
    [self.downLoadInfo.allValues performSelector:@selector(cacelAndClean) withObject:nil];
}
@end
