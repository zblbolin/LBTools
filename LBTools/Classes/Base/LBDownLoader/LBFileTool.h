//
//  LBFileTool.h
//  LBDownLoadListern
//
//  Created by 张伯林 on 2017/11/30.
//  Copyright © 2017年 张伯林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBFileTool : NSObject
+(BOOL)fileExists:(NSString *)filePath;

+(long long)fileSize:(NSString *)filePath;

+(void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;

+(void)removeFile:(NSString *)filePath;
@end
