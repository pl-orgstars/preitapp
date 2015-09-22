//
//  AudioRecorder.m
//  RmREV
//
//  Created by Tania on 12/13/12.
//  Copyright (c) 2012 Tania. All rights reserved.
//

#import "AudioRecorder.h"

@implementation AudioRecorder

@synthesize audioRecorder;
@synthesize docsDir;

-(id)init
{
    if ((self = [super init]))
    {
        [self initializeRecorder];
    }
    return self;
}

-(void)initializeRecorder2{
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [audioSession setActive:YES error:nil];
//    [audioSession requestRecordPermission:^(BOOL granted) {
//        
//    }];
}

-(void)initializeRecorder
{
    NSArray *dirPaths;
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    docsDir = soundFilePath;
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSLog(@"initializeRecorder:soundFilePath:%@",soundFilePath);
    
    
    // For .caf
//    NSDictionary *recordSettings = [NSDictionary
//                                    dictionaryWithObjectsAndKeys:
//            [NSNumber numberWithInt:AVAudioQualityMin],AVEncoderAudioQualityKey,
//            [NSNumber numberWithInt:16],AVEncoderBitRateKey,
//            [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,
//            [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
//                                    nil];
    NSDictionary *recordSettings = @{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                     AVEncoderAudioQualityKey: @(AVAudioQualityLow),
                                     AVNumberOfChannelsKey: @1,
                                     AVSampleRateKey: @22050.0f};
    

    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        if (is_iOS7) {
            [self initializeRecorder2];
        }
        [audioRecorder prepareToRecord];
        [audioRecorder setDelegate:self];
        
        
    }
}




-(void)startRecording
{
//    if (is_iOS7) {
//        [[AVAudioSession sharedInstance] setCategory :AVAudioSessionCategoryRecord error:nil];
//        [recorder record];
//    }
    
    audioRecorder.meteringEnabled = YES;
    if (is_iOS7) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        [audioSession requestRecordPermission:^(BOOL granted) {
            [audioRecorder record];
        }];
    }else{
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        [audioRecorder record];
    }
    
    

}
-(void)stopRecording
{
    if (audioRecorder.recording)
    {
        NSLog(@"current time == %f", audioRecorder.currentTime);
        [audioRecorder stop];

    }
}

-(NSString*)getRecordFolder
{
    return docsDir;
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"audioRecorderDidFinishRecording:flag:%d",flag);
    [self.delegate audioPlayerDidFinishRecording:flag];
    
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.delegate audioPlayerDidFinishPlaying:flag];
}


-(void)duration
{

}


-(NSString *)saveFileWithOldName:(NSString*)oldNameStr
{
    NSArray *dirPaths;
    NSString *docsDirs;
    NSString *tempStr2;
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDirs = [dirPaths objectAtIndex:0];
    
    NSLog(@"saveBtnClicked:dirPaths:%@",dirPaths);
    NSLog(@"saveBtnClicked:docsDir:%@",docsDirs);
    NSString *soundFilePath = [docsDirs
                               stringByAppendingPathComponent:oldNameStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:soundFilePath])
    {
        int i = 1;
        
        NSString *tempStr = [oldNameStr stringByReplacingOccurrencesOfString:@".caf" withString:@""];
        
        NSLog(@"saveFileWithOldName:tempStr:%@",tempStr);
        tempStr2 = [tempStr stringByAppendingFormat:@"-%d.caf",i];
        NSLog(@"saveFileWithOldName:tempStr2:%@",tempStr2);
        NSString *tempSoundPath = [docsDirs
                                   stringByAppendingPathComponent:tempStr2];
        NSLog(@"saveFileWithOldName:tempSoundPath:%@",tempSoundPath);
        
        
        while ([fileManager fileExistsAtPath:tempSoundPath])
        {
            i++;
            tempStr2 = [tempStr stringByAppendingFormat:@"-%d.caf",i];
            NSLog(@"saveFileWithOldName:tempStr2:%@",tempStr2);
            tempSoundPath = [docsDirs
                             stringByAppendingPathComponent:tempStr2];
            NSLog(@"saveFileWithOldName:tempSoundPath:%@",tempSoundPath);
        }
        
        // rename File
        [fileManager moveItemAtPath:[docsDirs                    stringByAppendingPathComponent:oldNameStr] toPath:[docsDirs                                                                                          stringByAppendingPathComponent:tempStr2] error:NULL];
    }
    
    return tempStr2;
}


-(void)deleteFile:(NSString *)str
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirPaths;
    NSString *docsDirs;
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDirs = [dirPaths objectAtIndex:0];
    
    NSString *temp = [docsDirs stringByAppendingPathComponent:str];
    if ([fileManager fileExistsAtPath:temp])
    {
        [fileManager removeItemAtPath:temp error:nil];
    }
    
    
}
-(void)playFile:(NSString *)filePath
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirPaths;
    NSString *docsDirs;
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDirs = [dirPaths objectAtIndex:0];
    
    NSString *temp = [docsDirs stringByAppendingPathComponent:filePath];
    
    
    // NSLog(@"playFile:filePath:%@",filePath);
    NSError *error;
    //player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSURL *fileURL = [NSURL fileURLWithPath:temp];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    _player.delegate =self;
    //    [player setDelegate:self];
    NSLog(@"RecordedListViewController:player:111:%@",_player);
    if (_player == nil)
    {
        NSLog(@"Error:%@",[error description]);
    }
    
    [_player prepareToPlay];
    _player.volume = 1.0f;
    [_player setNumberOfLoops:0];
    [_player play];
    
    NSLog(@"duration:%f",[_player duration]);
    NSLog(@"RecordedListViewController:player:%@",_player);
    
    
    
    
}


-(void)playFile
{

    NSError *error;

    NSURL *fileURL = [NSURL fileURLWithPath:docsDir];
    NSLog(@"");
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        _player.delegate =self;
    NSLog(@"RecordedListViewController:player:111:%@",_player);
    if (_player == nil)
    {
        NSLog(@"Error:%@",[error description]);
    }
    
    [_player prepareToPlay];
    _player.volume = 1.0f;
    [_player setNumberOfLoops:0];
    [_player play];
    NSLog(@"duration:%f",[_player duration]);
    NSLog(@"RecordedListViewController:player:%@",_player);
    
        
}

-(void)closeFile
{
    if (_player)
    {
        [_player stop];
        _player = nil;
    }
}

-(float)getDurationForFile:(NSString *)filePath
{

    NSError *error;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    

    NSLog(@"RecordedListViewController:player:111:%@",_player);
    if (_player == nil)
    {
        NSLog(@"Error:%@",[error description]);
    }


     [_player prepareToPlay];
    _player.volume = 1.0f;
    [_player setNumberOfLoops:0];

    NSLog(@"duration:%f",[_player duration]);
    NSLog(@"RecordedListViewController:player:%@",_player);
    
    
    return [_player duration];
    
}

@end
