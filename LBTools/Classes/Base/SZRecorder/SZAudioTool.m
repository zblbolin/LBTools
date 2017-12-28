//
//  SZAudioTool.m

//
//  Created by on 16/8/25.
//  Copyright © 2016年 . All rights reserved.
//

#import "SZAudioTool.h"

@interface SZAudioTool()

@property (nonatomic, copy) Success block;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation SZAudioTool
singtonImplement(SZAudioTool)

- (float)peakPowerForChannel0 {
    [self.audioRecorder updateMeters];
    return [self.audioRecorder peakPowerForChannel:0];
}

-(AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {

        // 0. 设置录音会话
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];

        // 1. 确定录音存放的位置
        NSURL *url = [NSURL URLWithString:self.recordPath];

        // 2. 设置录音参数
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        // 设置编码格式
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
        // 采样率
        [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
        // 通道数
        [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        
        //音频质量,采样质量
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

        // 3. 创建录音对象
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:nil];
        _audioRecorder.meteringEnabled = YES;
    }
    return _audioRecorder;
}
-(void)updateMeters
{
    [self.audioRecorder updateMeters];
}

/**
 *  开始录音
 */
- (void)beginRecordWithRecordPath: (NSString *)recordPath {

    _recordPath = recordPath;
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
}
/**
 *  结束录音
 */
- (void)endRecord {
    [self.audioRecorder stop];
}

/**
 *  暂停录音
 */
- (void)pauseRecord {
    [self.audioRecorder pause];
}

/**
 *  删除录音
 */
- (void)deleteRecord {
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
}

/**
 *  重新录音
 */
- (void)reRecord {

    self.audioRecorder = nil;
    [self beginRecordWithRecordPath:self.recordPath];

}



@end
