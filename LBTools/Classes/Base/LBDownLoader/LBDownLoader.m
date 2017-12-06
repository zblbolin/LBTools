//
//  LBDownLoader.m
//  LBDownLoadListern
//
//  Created by 张伯林 on 2017/11/29.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import "LBDownLoader.h"
#import "LBFileTool.h"
#define kCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTempPath NSTemporaryDirectory()

@interface LBDownLoader()<NSURLSessionDataDelegate>
{
    long long _tempSize;
    long long _totalSize;
}
@property(nonatomic,strong)NSURLSession *session;

@property(nonatomic,copy)NSString *downLoadedPath;
@property(nonatomic,copy)NSString *downLoadingPath;

@property(nonatomic,strong)NSOutputStream *outputStream;

@property(nonatomic,weak)NSURLSessionDataTask *dataTask;
@property(nonatomic,assign)NSError *error;
@end

@implementation LBDownLoader



-(void)downLoader:(NSURL *)url downLoadInfo:(DownLoadInfoType)downLoadInfo progress:(ProgressBlcokType)progressBlock sucess:(SucessBlockType) sucessBlock fail:(FailBlcokType)failBlock stateChange:(StateChangeType)stateChange{
    //1. 给所有的block赋值
    self.downLoadInfo = downLoadInfo;
    self.progressChange = progressBlock;
    self.sucessBlock = sucessBlock;
    self.failBlock = failBlock;
    self.stateChange = stateChange;
    //2. 开始下载
    [self downLoader:url];
}
-(void)downLoader:(NSURL *)url{
    //内部实现
    //1.真正的从头开始下载
    //2.如果任务存在了,继续下载
    
    //当前任务,肯定存在
    if ([url isEqual:self.dataTask.originalRequest.URL]) {
        //判断当前的状态, 如果是暂停状态
        //继续下载
        if (self.state == LBDownLoaderStatePause) {
            [self resumeCurrentTask];
            return;
        }
        
    }
    //两种:1.任务不存在 2.任务存在,但是任务的url地址 不同
    [self cacelCurrentTask];
    
    //1.文件的存放
    //下载ing ==> temp + 名称(md5(url))
    NSString *fileName = url.lastPathComponent;
    self.downLoadedPath = [kCachesPath stringByAppendingPathComponent:fileName];
    self.downLoadingPath = [kTempPath stringByAppendingPathComponent:fileName];
    
    //下载完成 ==> cahe + 名称(md5(url))
    
    
    //1.判断,url地址,对应的资源,是否已经下载完毕,(下载完成的目录里面,存在这个文件)
    //1.1 告诉外界,下载完毕,并且传递相关信息(本地路径,文件大小) return
    if ([LBFileTool fileExists:self.downLoadedPath]) {
        //告诉外界,已经下载完成;
        self.state = LBDownLoaderStatePauseSuccess;
        return;
    }
    
    
    //2.检测临时文件是否存在
    //2.1  不存在: 从0字节开始请求资源  return
    if ([LBFileTool fileExists:self.downLoadingPath]) {
        //从0开始请求资源
        [self downLoadWithURL:url offset:0];
        return;
    }
    
    //2.2  存在: 直接以当前存在文件的大小作为开始字节,去网络请求资源
    //HTTP:rang:开始字节-
    
    //本地大小 = 总大小   ==> 移动到下载完成的路径中
    //本地大小 > 总大小   ==> 删除本地临时缓存文件,从0字节开始下载
    //本地大小 < 总大小   ==> 从本地大小开始下载
    
    //获取本地的总大小
    _tempSize = [LBFileTool fileSize:self.downLoadingPath];
    [self downLoadWithURL:url offset:_tempSize];
    //文件的总大小获取
    //发送网络请求
    //同步 / 异步
    
}
//如果调用了几次暂停
//调用几次继续,才可以继续
//继续任务
-(void)resumeCurrentTask{
    if (self.dataTask && self.state == LBDownLoaderStateDownLoading) {
        [self.dataTask resume];
        self.state = LBDownLoaderStateDownLoading;
    }
}
//如果调用了几次继续
//调用几次暂停,才可以暂停
//暂停任务
-(void)pauseCurrentTask{
    //引入状态
    if (self.state == LBDownLoaderStateDownLoading) {
        self.state = LBDownLoaderStatePause;
        [self.dataTask suspend];
    }
}
-(void)cacelCurrentTask{
    self.state = LBDownLoaderStatePause;
    [self.session invalidateAndCancel];
    self.session = nil;
}
-(void)cacelAndClean{
    [self cacelCurrentTask];
    [LBFileTool removeFile:self.downLoadingPath];
    //下载完成的文件 ->手动删除某个声音 ->统一清除缓存
}
#pragma mark -- 私有方法
/**
    根据开始,  请求资源
 */
- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];
    self.dataTask = [self.session dataTaskWithRequest:request];
    [self resumeCurrentTask];
}

#pragma make --协议方法


/**
 第一次接收到响应的时候调用(响应头,并没有具体的资源内容)
 
 通过这个方法里面  系统提供的回调代码块  可以控制 是继续请求 还是取消请求
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSHTTPURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSLog(@"%@",response);
    //获取要下载的文件的类型
    
    //本地缓存大小
    //去资源大小
    //1. 从 Content-Length 取出来
    //2. 如果 Content-Range 有,应该从Content-Range里面获取
    _totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = [response allHeaderFields][@"Content-Range"];
    if (contentRangeStr.length != 0) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    //传递给外界:总大小 & 本地存储的文件路径
    if (self.downLoadInfo) {
        self.downLoadInfo(_totalSize);
    }
    
    //比对本地大小  和  总大小
    if (_tempSize == _totalSize) {
        //1. 移动到下载完成文件夹
        NSLog(@"移动文件到下载完成");
        [LBFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        //2. 取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        
        //修改状态
        self.state = LBDownLoaderStatePauseSuccess;
        return;
    }
    if (_tempSize > _totalSize) {
        //1. 删除临时缓存
        NSLog(@"删除临时缓存");
        [LBFileTool removeFile:self.downLoadingPath];
        //2. 取消请求
        completionHandler(NSURLSessionResponseCancel);
        //3 从0开始下载
        NSLog(@"重新开始下载");
        [self downLoader:response.URL];
        
        return;
    }
    self.state = LBDownLoaderStateDownLoading;
    //继续接受数据
    //确定开始下载数据
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downLoadingPath append:YES];
    [self.outputStream open];
    completionHandler(NSURLSessionResponseAllow);
}
/*当用户确定,继续接受数据的时候调用*/
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data{
    //这是当前已经下载的大小
    _tempSize += data.length;
    
    self.progress = 1.0 * _tempSize / _totalSize;
    
    //往输出流中写入数据
    [self.outputStream write:data.bytes maxLength:data.length];
}
/*请求完成的时候调用(!= 请求成功/失败)*/
-(void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    self.error = error;
    if (error == nil) {
        //不一定是成功
        //数据肯定是请求完毕
        //判断,本地缓存 == 文件总大小
        //如果等于 => 验证文件是否完整(file md5)
// ---这里需要先验证文件的完整性,用(file md5)验证
        [LBFileTool moveFile:self.downLoadingPath toPath:self.downLoadedPath];
        self.state = LBDownLoaderStatePauseSuccess;
        
    }else{
        NSLog(@"有问题----%zd---%@",error.code,error.localizedDescription);
        //取消 ,断网
        //根据不同的服务器错误码来改,如-999为取消下载的错误码
        if (error.code == -999) {
            self.state = LBDownLoaderStatePause;
        }else{
            self.state = LBDownLoaderStatePauseFailed;
        }
        
    }
    [self.outputStream close];
}

#pragma mark --事件/数据传递
-(void)setState:(LBDownLoaderState)state{
    if (_state == state) {
        return;
    }
    _state = state;
    if (self.stateChange) {
        self.stateChange(_state);
    }
    if (_state == LBDownLoaderStatePauseSuccess && self.sucessBlock) {
        self.sucessBlock(self.downLoadedPath);
    }
    if (_state == LBDownLoaderStatePauseFailed && self.failBlock) {
        self.failBlock(self.error);
    }
}
-(void)setProgress:(float)progress{
    _progress = progress;
    if (self.progressChange) {
        self.progressChange(_progress);
    }
}
-(NSURLSession *)session{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
@end
