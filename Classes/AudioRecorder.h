//
//  AudioRecorder.h
//  RmREV
//
//  Created by Tania on 12/13/12.
//  Copyright (c) 2012 Tania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioRecorderDelegete;
@interface AudioRecorder : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder *audioRecorder;
//    NSTimer *levelTimer;
//    AVAudioPlayer *player;
}
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,retain) id<AudioRecorderDelegete> delegate;
@property (nonatomic,retain) AVAudioRecorder *audioRecorder;
//@property (nonatomic,retain)  AVAudioPlayer *player;
@property (nonatomic,retain) NSString *docsDir;
-(void)startRecording;
-(void)stopRecording;
-(void)initializeRecorder;
-(void)playFile:(NSString *)filePath;
-(void)closeFile;
-(void)playFile;
//-(void)saveFileWithOldName:(NSString*)oldNameStr;
-(NSString *)saveFileWithOldName:(NSString*)oldNameStr;
-(float)getDurationForFile:(NSString *)filePath;
-(void)deleteFile:(NSString *)str;

@end

@protocol AudioRecorderDelegete
-(void)audioPlayerDidFinishRecording:(BOOL)finishRecording;
-(void)audioPlayerDidFinishPlaying:(BOOL)finishRecording;
@end