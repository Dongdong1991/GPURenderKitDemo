//
//  DDAVAssetRenderManage.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/5.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "DDAVAssetRenderManage.h"


@interface DDAVAssetRenderManage ()

/// 主轨道
@property (nonatomic, strong) AVMutableComposition *mainComposition;
/// 视频处理器
@property (nonatomic, strong) AVMutableVideoComposition *videoComposition;
/// 音乐处理器
@property (nonatomic, strong) AVMutableAudioMix *audioMix;
/// assetReader
@property (nonatomic, strong) AVAssetReader *assetReader;
/// video输出
@property (nonatomic, strong) AVAssetReaderTrackOutput *videoTrackOutput;
/// audio输出
@property (nonatomic, strong) AVAssetReaderTrackOutput *audioTrackOutput;

@property (nonatomic, strong) NSMutableArray *audioMixInputParameterss;

@property (nonatomic, strong) NSURL *videoFileUrl;

@property (nonatomic, strong) AVAsset *videoAsset;

@property (nonatomic, assign) CGSize videoSize;

@property (nonatomic, assign) CMTime duration;

@property (nonatomic, copy) DDAVAssetRenderFinishHandle finishHandle;

@property (nonatomic, assign) BOOL isCancelProcessingBool;


@end


@implementation DDAVAssetRenderManage



- (instancetype)initWithVideoFileUrl:(NSURL *)videoFileUrl
{
    self = [super init];
    if (self) {
        
        _videoFileUrl = videoFileUrl;
        _isCancelProcessingBool = NO;
        _videoVolume = 1.0;
        [self videoAsset];
    }
    return self;
}

- (AVAsset *)videoAsset{
    if (!_videoAsset) {
        
        _videoAsset = [AVAsset assetWithURL:self.videoFileUrl];
        NSArray *videoTracks = [_videoAsset tracksWithMediaType:AVMediaTypeVideo];
        
        if (videoTracks.count==0) {
            NSAssert(NO, @"没有视频帧---");
        }
        self.duration = _videoAsset.duration;
        AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
        self.videoSize = videoTrack.naturalSize;
    }
    return _videoAsset;
}



- (AVMutableComposition *)mainComposition{
    if (!_mainComposition) {
        
        _mainComposition = [[AVMutableComposition alloc]init];
    }
    return _mainComposition;
}


- (AVMutableVideoComposition *)videoComposition
{
    if (!_videoComposition) {
        _videoComposition = [AVMutableVideoComposition videoComposition];
        _videoComposition.renderSize = self.videoSize;
        if (CMTIME_IS_INVALID(self.frameDuration)) {
            /// 如果帧率不传则默认 30帧
            self.frameDuration = CMTimeMake(1, 30);
        }
        _videoComposition.frameDuration = self.frameDuration;
        _videoComposition.renderScale = 1.0;
    }
    return _videoComposition;
}

- (AVMutableAudioMix *)audioMix
{
    if (!_audioMix) {
        _audioMix = [AVMutableAudioMix audioMix];
    }
    return _audioMix;
}

- (NSMutableArray *)audioMixInputParameterss
{
    if (!_audioMixInputParameterss) {
        _audioMixInputParameterss = [NSMutableArray array];
    }
    return _audioMixInputParameterss;
}


- (void)addVideoSource{
    
    // 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack *videoTrack = [self.mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // 视频采集通道
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    // 把采集轨道数据加入到可变轨道之中
    // 视频时间范围
    CMTimeRange videoTimeRange = videoAssetTrack.timeRange;
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    // 获取视频的音频轨道
    NSArray *assetAudioTracks = [self.videoAsset tracksWithMediaType:AVMediaTypeAudio];
    
    if (assetAudioTracks.count > 0 && self.isAddVideoVoiceBool) {
        AVMutableCompositionTrack *audioCompositionTrack = [self.mainComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        AVAssetTrack *audioTrack = [assetAudioTracks firstObject];
        [audioCompositionTrack insertTimeRange:videoTimeRange ofTrack:audioTrack atTime:kCMTimeZero error:nil];
        
        AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioCompositionTrack];
        [audioMixInputParameters setVolumeRampFromStartVolume:self.videoVolume toEndVolume:self.videoVolume timeRange:videoTimeRange];
        [self.audioMixInputParameterss addObject:audioMixInputParameters];
    }
    
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    instruction.layerInstructions = @[layerInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    NSMutableArray *instrucionArray = [NSMutableArray array];
    [instrucionArray addObject:instruction];
    self.videoComposition.instructions = instrucionArray;
}


- (void)initializeAssetReader
{
    NSError *error = nil;
    self.assetReader = [[AVAssetReader alloc] initWithAsset:self.mainComposition error:&error];
    self.assetReader.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(self.mainComposition.duration.value, self.mainComposition.duration.timescale));
    
    self.audioMix.inputParameters = self.audioMixInputParameterss;
    
    NSDictionary *outputSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    AVAssetReaderVideoCompositionOutput *readerVideoOutput = [AVAssetReaderVideoCompositionOutput assetReaderVideoCompositionOutputWithVideoTracks:[self.mainComposition tracksWithMediaType:AVMediaTypeVideo] videoSettings:outputSettings];
    
    
    readerVideoOutput.videoComposition = self.videoComposition;
    readerVideoOutput.alwaysCopiesSampleData = NO;
    if ([self.assetReader canAddOutput:readerVideoOutput]) {
        [self.assetReader addOutput:readerVideoOutput];
    } else{
        NSLog(@"加入视频输入失败");
    }
    
    NSArray *audioTracks = [self.mainComposition tracksWithMediaType:AVMediaTypeAudio];
    BOOL shouldRecordAudioTrack = ([audioTracks count] > 0);
    AVAssetReaderAudioMixOutput *readerAudioOutput = nil;
    
    if (shouldRecordAudioTrack)
    {
        readerAudioOutput = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:audioTracks audioSettings:nil];
        readerAudioOutput.audioMix = self.audioMix;
        readerAudioOutput.alwaysCopiesSampleData = NO;
        if ([self.assetReader canAddOutput:readerAudioOutput]) {
            [self.assetReader addOutput:readerAudioOutput];
        } else{
            NSLog(@"加入音频失败");
        }
    }
    
    self.videoTrackOutput = (AVAssetReaderTrackOutput *)readerVideoOutput;
    self.audioTrackOutput = (AVAssetReaderTrackOutput *)readerAudioOutput;
    
}



#pragma mark ------------------------------------------------------ publicFunc ------------------------------------------------------


- (void)mixMusicFilePath:(NSURL *)musicFilePath startTime:(CMTime)startTime musicVolume:(float)musicVolume{
    
    
    AVURLAsset *audioAsset = [AVURLAsset assetWithURL:musicFilePath];
    NSArray *arrayAudioTrack = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
    
    CMTimeRange cropTimeRange = CMTimeRangeMake(startTime, audioAsset.duration);
    
    float cropTimeSecond = CMTimeGetSeconds(cropTimeRange.duration);
    float presentTimeSecond = CMTimeGetSeconds(self.duration);
    if (cropTimeSecond < presentTimeSecond) {
        if (arrayAudioTrack.count > 0) {
            AVAssetTrack *audioTrak = [arrayAudioTrack firstObject];
            AVMutableCompositionTrack *audioCompositionTrack = [self.mainComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            
            
            int count = presentTimeSecond / cropTimeSecond;
            for (int i = 0; i< count; i++) {
                CMTimeRange timeRange = CMTimeRangeMake(CMTimeAdd(cropTimeRange.start, CMTimeMakeWithSeconds(CMTimeGetSeconds(cropTimeRange.duration) * i, 90000)) , cropTimeRange.duration);
                [audioCompositionTrack insertTimeRange:cropTimeRange
                                               ofTrack:audioTrak
                                                atTime:CMTimeSubtract(timeRange.start, cropTimeRange.start)
                                                 error:nil];
            }
            CMTimeRange lastTimeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(cropTimeSecond * (count), 90000), CMTimeMakeWithSeconds(presentTimeSecond -  cropTimeSecond * (count), 90000));
            [audioCompositionTrack insertTimeRange:CMTimeRangeMake(cropTimeRange.start, lastTimeRange.duration)
                                           ofTrack:audioTrak
                                            atTime:lastTimeRange.start
                                             error:nil];
            
            
            AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioCompositionTrack];
            [audioMixInputParameters setVolumeRampFromStartVolume:musicVolume toEndVolume:musicVolume timeRange:CMTimeRangeMake(kCMTimeZero, self.duration)];
            [self.audioMixInputParameterss addObject:audioMixInputParameters];
            
        }
    } else
    {
        if (arrayAudioTrack.count > 0) {
            AVAssetTrack *audioTrak = [arrayAudioTrack firstObject];
            AVMutableCompositionTrack *audioCompositionTrack = [self.mainComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [audioCompositionTrack insertTimeRange:cropTimeRange
                                           ofTrack:audioTrak
                                            atTime:kCMTimeZero
                                             error:nil];
            AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioCompositionTrack];
            [audioMixInputParameters setVolumeRampFromStartVolume:musicVolume toEndVolume:musicVolume timeRange:cropTimeRange];
            [self.audioMixInputParameterss addObject:audioMixInputParameters];
        }
    }
}



- (void)startProcessing{
    
    [self addVideoSource];
    [self initializeAssetReader];
    BOOL value =  [self.assetReader startReading];
    if (value) {
        NSLog(@"开始reading");
    }else{
        NSLog(@"有问题%@",self.assetReader.error);
        return;
    }
    runSynchronouslyOnVideoProcessingQueue(^{
        [self processingBuffer];
    });
}


- (void)processingBuffer{
    
    if (self.isCancelProcessingBool) {
        
        if (self.assetReader.status == AVAssetReaderStatusReading) {
            [self.assetReader cancelReading];
        }
        return;
    }
    bool isCirculationBool = YES;
    
    if (self.assetReader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef videoSampleBuffer = [self.videoTrackOutput copyNextSampleBuffer];
        
        if (videoSampleBuffer) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(outputProcessMovieFrameSampleBuffer:)]) {
                [self.delegate outputProcessMovieFrameSampleBuffer:videoSampleBuffer];
            }
            CMSampleBufferInvalidate(videoSampleBuffer);
            CFRelease(videoSampleBuffer);
        }else{
            
            isCirculationBool = NO;
            NSLog(@"videoSampleBuffer is null");
            if (self.finishHandle) {
                self.finishHandle();
            }
            [self.assetReader cancelReading];
            return;
        }
    }else{
        
        NSLog(@"assetReader有问题");
        return;
    }
    
    
    if (self.assetReader.status == AVAssetReaderStatusReading) {
        
        CMSampleBufferRef audioSampleBuffer = [self.audioTrackOutput copyNextSampleBuffer];
        if (audioSampleBuffer) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(outputProcessAudioFrameSampleBuffer:)]) {
                [self.delegate outputProcessAudioFrameSampleBuffer:audioSampleBuffer];
            }
//            CMSampleBufferInvalidate(audioSampleBuffer);
            CFRelease(audioSampleBuffer);
        }
    }else{
        
        NSLog(@"assetReader有问题");
        return;
    }
    //循环读取下一帧视频
    if (isCirculationBool) {
        [NSThread sleepForTimeInterval:1/240.0];
        [self processingBuffer];
    }
}

- (void)finishProcessingWithCompletionHandler:(DDAVAssetRenderFinishHandle)handle{
    
    if (handle) {
        self.finishHandle = handle;
    }
}

- (void)cancelProcessingHandler:(void (^)(void))handler{
    _isCancelProcessingBool = YES;
    if (handler) {
        handler();
    }
}


@end
