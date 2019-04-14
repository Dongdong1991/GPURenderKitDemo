//
//  DDMediaEditorManage.m
//  WEVideoEffect
//
//  Created by 刘海东 on 2018/11/5.
//  Copyright © 2018 刘海东. All rights reserved.
//

#import "DDMediaEditorManage.h"


@interface DDMediaEditorManage ()

@property (nonatomic, strong) UIImage *lutImage;
@property (nonatomic, assign) BOOL playIng;
@property (nonatomic, assign) BOOL videoStatusReadyToPlayBool;
@property (nonatomic, assign) BOOL isVideoPlayEndCallBackNowBool;
@end

@implementation DDMediaEditorManage

- (instancetype)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        _videoUrl = url;
        _playIng = NO;
        _videoStatusReadyToPlayBool = NO;
        _isVideoPlayEndCallBackNowBool = NO;
    }
    return self;
}

#pragma mark lazy
static NSString * const VideoPlayerItemStatusContext = @"VideoPlayerItemStatusContext";
- (AVPlayerItem *)playerItem
{
    if (!_videoPlayerItem)
    {
        _videoPlayerItem = [[AVPlayerItem alloc]initWithURL:self.videoUrl];
        [_videoPlayerItem addObserver:self forKeyPath:@"status" options:0 context:(__bridge void * _Nullable)VideoPlayerItemStatusContext];
        
    }
    return _videoPlayerItem;
}

- (AVPlayer *)videoPlayer
{
    if (!_videoPlayer)
    {
        _videoPlayer =[[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        
        @weakify(self);
        [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, self.videoPlayerItem.asset.duration.timescale) queue:nil usingBlock:^(CMTime time) {
            @strongify(self);
            
            if (self.videoCMTimeCallBack) {
                self.videoCMTimeCallBack(self.videoPlayerItem.currentTime, self.videoPlayerItem.asset.duration);
            }
            
            if (CMTimeGetSeconds(time) >= CMTimeGetSeconds(self.videoPlayerItem.asset.duration))
            {
                if (self.videoPlayEndCallBack && self.isVideoPlayEndCallBackNowBool == NO)
                {
                    self.playIng = NO;
                    self.videoPlayEndCallBack();
                    self.isVideoPlayEndCallBackNowBool = YES;
                    @weakify(self);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @strongify(self);
                        self.isVideoPlayEndCallBackNowBool = NO;
                    });
                }
            }else
            {
                //                NSLog(@"播放中");
            }
        }];
        
    }
    return _videoPlayer;
}


- (GPUImageMovie *)movie
{
    if (!_movie)
    {
        _movie =[[GPUImageMovie alloc]initWithPlayerItem:self.playerItem];
        _movie.runBenchmark =NO;
        _movie.playAtActualSpeed =YES;
    }
    return _movie;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == (__bridge void * _Nullable)(VideoPlayerItemStatusContext))
    {
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerItem * item = (AVPlayerItem *)object;
            if (item.status == AVPlayerItemStatusReadyToPlay)
            { //准备好播放
                NSLog(@"AVPlayerItemStatusReadyToPlay--->");
                if (self.videoAVPlayerItemStatusReadyToPlayCallBack &&self.videoStatusReadyToPlayBool == NO)
                {
                    self.videoAVPlayerItemStatusReadyToPlayCallBack();
                }
                self.videoStatusReadyToPlayBool = YES;
            }else if (item.status == AVPlayerItemStatusFailed){ //失败
                NSLog(@"AVPlayerItemStatusFailed--->");
            }
        }
    }
}

#pragma mark Public methods
/** 视频是否可播放 */
- (BOOL)getVideoStatusReadyToPlay
{
    return self.videoStatusReadyToPlayBool;
}

/** 播放 */
- (void)playVideo
{
    NSLog(@"播放");
    if (self.playIng)
    {
        return;
    }
    
    [self.videoPlayer play];
    [self.movie startProcessing];
    self.playIng = YES;
    if (_audioPlayer && _audioPlayerItem)
    {
        [_audioPlayer play];
    }
}

/**重新播放**/
- (void)replayVideo
{
    @weakify(self);
    [self videoSeekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        @strongify(self);
        [self playVideo];
    }];
}

/** 暂停 */
- (void)pauseVideo
{
    NSLog(@"暂停");
    
    [self.videoPlayer pause];
    [self.movie endProcessing];
    self.playIng = NO;
    if (_audioPlayer && _audioPlayerItem)
    {
        [_audioPlayer pause];
    }
}

/** 跳到指定时间 */
- (void)videoSeekToTime:(CMTime)time completionHandler:(void(^)(BOOL finished))completionHandler
{
    NSLog(@"显示视频预览图");
    CMTime seekTimeInProgress = time;
    if (self.videoPlayerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        NSLog(@"AVPlayerItemStatusReadyToPlay");
        [self.videoPlayer pause];
        self.playIng = NO;
        [self.videoPlayer seekToTime:seekTimeInProgress
                     toleranceBefore:kCMTimeZero
                      toleranceAfter:kCMTimeZero
                   completionHandler:^(BOOL finished) {
                       
                       if (completionHandler) {
                           completionHandler(finished);
                       }
                   }];
        [self.movie endProcessing];
    }else if (self.videoPlayerItem.status == AVPlayerItemStatusUnknown)
    {
        
        NSLog(@"AVPlayerItemStatusUnknown");
    }else
    {
        NSLog(@"AVPlayerItemStatusFailed");
    }
}

/** 添加音乐 */
- (void)addAudioPath:(NSURL *)audioPath
{
    
    _audioPlayer = nil;
    _audioPlayerItem = nil;
    self.audioPlayer = [[AVPlayer alloc ]init];
    self.audioPlayerItem =[AVPlayerItem playerItemWithURL:audioPath];
    [self.audioPlayer replaceCurrentItemWithPlayerItem:self.audioPlayerItem];
    [self.audioPlayer play];
    @weakify(self);
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, self.audioPlayerItem.asset.duration.timescale) queue:nil usingBlock:^(CMTime time) {
        @strongify(self);
        if (time.value == self.audioPlayerItem.asset.duration.value)
        {
            if (self.audioPlayEndCallBack)
            {
                self.audioPlayEndCallBack();
            }
        }else
        {
        }
        
        if (self.audioCMTimeCallBack && self.audioPlayerItem)
        {
            NSLog(@"<<%f",CMTimeGetSeconds(self.audioPlayerItem.currentTime));
            self.audioCMTimeCallBack(self.audioPlayerItem.currentTime, self.audioPlayerItem.duration);
        }
    }];
    
}
/** 移除音乐 */
- (void)removeMusic
{
    [self pauseMusic];
    _audioPlayer = nil;
    _audioPlayerItem = nil;
}

/** 播放音乐 */
- (void)playMusic
{
    if (_audioPlayer && _audioPlayerItem)
    {
        [_audioPlayer play];
    }
}
/** 暂停音乐 */
- (void)pauseMusic
{
    if (_audioPlayer && _audioPlayerItem)
    {
        [_audioPlayer pause];
    }
}

/** 音乐跳到指定时间 */
- (void)audioSeekToTime:(CMTime)time
{
    if (_audioPlayer && _audioPlayerItem)
    {
        [self.audioPlayerItem seekToTime:time];
    }
}

/** 视频声音大小 */
- (void)adjustVolumeForVideo:(float)videoVolume
{
    if (videoVolume>=0&&videoVolume<=1.0)
    {
        _videoPlayer.volume = videoVolume;
    }
}
/** 音乐声音大小 */
- (void)adjustVolumeForMusic:(float)musicVolume
{
    if (musicVolume>=0&&musicVolume<=1.0)
    {
        _audioPlayer.volume = musicVolume;
    }
}

/** 获取视频时长 */
- (float)getVideoDuration
{
    return (float)CMTimeGetSeconds(self.videoPlayerItem.asset.duration);
}

/** 获取音乐时长 */
- (float)getAudioDuration
{
    return (float)CMTimeGetSeconds(self.audioPlayerItem.asset.duration);
}

/** 获取视频时长 */
- (CMTime)getVideoDurationTime
{
    return self.videoPlayerItem.asset.duration;
}

/** 获取音乐时长 */
- (CMTime)getAudioDurationTime
{
    return self.audioPlayerItem.asset.duration;
}
/** 是否播放中 */
- (BOOL)isPlaying{
    return _playIng;
}


#pragma mark privatelyFunc
/** 释放时候需要调用 */
- (void)removeAllObject
{
    [_movie cancelProcessing];
    [_movie endProcessing];
    [_movie removeAllTargets];
    _delegate = nil;
    _movie = nil;
    _lutImage = nil;
    [_videoPlayer pause];
    [_videoPlayerItem removeObserver:self forKeyPath:@"status"];
    [_videoPlayerItem cancelPendingSeeks];
    [_videoPlayerItem.asset cancelLoading];
    [_videoPlayer.currentItem cancelPendingSeeks];
    [_videoPlayer.currentItem.asset cancelLoading];
    _videoPlayer = nil;
    _videoPlayerItem = nil;
    
    [_audioPlayer pause];
    [_audioPlayerItem cancelPendingSeeks];
    [_audioPlayerItem.asset cancelLoading];
    [_audioPlayer.currentItem cancelPendingSeeks];
    [_audioPlayer.currentItem.asset cancelLoading];
    _audioPlayer = nil;
    _audioPlayerItem = nil;
    _videoAVPlayerItemStatusReadyToPlayCallBack = nil;
    _videoPlayEndCallBack = nil;
    
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    NSLog(@"DDMediaEditorManage------->removeAllObject");
    
}

- (void)dealloc
{
    [self removeAllObject];
    NSLog(@"DDMediaEditorManage --->delloc 释放了");
}

- (BOOL)willDealloc
{
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf assertNotDealloc];
    });
    return YES;
}

- (void)assertNotDealloc
{
    NSAssert(NO, @"");
}


@end

