//
//  MRAvViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/7.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRAvViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>//视频需要额外支持的框架
@interface MRAvViewController (){
    NSString *speeakStr;
}
@property (nonatomic,strong) AVPlayer *mAVPlayer;
//@property (nonatomic,strong) AVPlayerViewController *mAVPlayerVC;
@property (nonatomic,strong) AVAudioRecorder *mRecorder;
@end

@implementation MRAvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_avType == AV_TYPE_SPEAK) {
        [self testOne];
    }else if (_avType == AV_TYPE_VIDEO) {
        [self testTwo];
    }else if (_avType == AV_TYPE_RECORD) {
        [self testThree];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

/*
 点读机:文本转语音
 */
- (void)testOne{
    speeakStr = @"hello my name is maorui";
    //合成器
    AVSpeechSynthesizer *synthesizer = [AVSpeechSynthesizer new];
    //发声器
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:speeakStr];
    utterance.rate = .5f;
    utterance.pitchMultiplier = 1.5f;
    utterance.volume = .6f;
    //选择语言
    NSArray *voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"],[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"]];
    utterance.voice = voices[1];
    //合成器调用发声器
    [synthesizer speakUtterance:utterance];
}

/*
 普通视频播放
 */
- (void)testTwo{
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"IMG_2615.MOV" withExtension:nil];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:videoURL];
    self.mAVPlayer = [AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.mAVPlayer];
    layer.frame = self.view.frame;
    [self.view.layer addSublayer:layer];
    [self.mAVPlayer play];
}

/*
 录音
 */
- (void)testThree{

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_avType != AV_TYPE_RECORD) return;
    NSURL *saveURL = [NSURL URLWithString:@"/Users/maorui/Documents/recorder/rec.caf"];
    self.mRecorder = [[AVAudioRecorder alloc] initWithURL:saveURL
                                                 settings:@{AVEncoderAudioQualityKey:[NSNumber numberWithInt:AVAudioQualityLow],//音频质量 比特率
                                                            AVEncoderBitRateKey:[NSNumber numberWithInt:16],//比特参数
                                                            AVNumberOfChannelsKey:[NSNumber numberWithFloat:2],//声道数
                                                            AVSampleRateKey:[NSNumber numberWithFloat:44100.0]}//比特值
                                                    error:nil];
    if (self.mRecorder && [self.mRecorder prepareToRecord]) {
        NSLog(@"开始录音");
        [self.mRecorder record];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_avType != AV_TYPE_RECORD) return;
    NSLog(@"结束录音");
    [self.mRecorder stop];
}

@end
