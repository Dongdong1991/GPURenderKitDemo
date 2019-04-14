//
//  DDMediaEditorManage.h
//  WEVideoEffect
//
//  Created by 刘海东 on 2018/11/5.
//  Copyright © 2018 刘海东. All rights reserved.
//

/** 视频编辑管理 */

#import <Foundation/Foundation.h>
#import <GPURenderKit/GPURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDMediaEditorManageDelegate <NSObject>
@optional
/** 播放暂停 */
- (void)videoEditoPause;
@end

@interface DDMediaEditorManage : NSObject

@property (nonatomic, weak) id <DDMediaEditorManageDelegate> delegate;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) GPUImageMovie *movie;
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerItem *videoPlayerItem;
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayerItem *audioPlayerItem;
@property (nonatomic, strong) GPUImageView *glMediaView;
@property (nonatomic, copy) void (^audioCMTimeCallBack)(CMTime currentTime,CMTime durationTime);
/** 视频播放进度回调 */
@property (nonatomic, copy) void (^videoCMTimeCallBack)(CMTime currentTime,CMTime durationTime);
/** 视频播放结束 */
@property (nonatomic, copy) void (^videoPlayEndCallBack)(void);
/** 背景音乐播放结束 */
@property (nonatomic, copy) void (^audioPlayEndCallBack)(void);
/** 视频配置完成可以播放的回调 */
@property (nonatomic, copy) void (^videoAVPlayerItemStatusReadyToPlayCallBack)(void);

- (instancetype)initWithUrl:(NSURL *)url;
/** 视频是否可播放 */
- (BOOL)getVideoStatusReadyToPlay;
/** 播放 */
- (void)playVideo;
/**重新播放**/
- (void)replayVideo;
/** 暂停 */
- (void)pauseVideo;
/** 跳到指定时间 */
- (void)videoSeekToTime:(CMTime)time completionHandler:(void(^)(BOOL finished))completionHandler;
/** 添加音乐 */
- (void)addAudioPath:(NSURL *)audioPath;
/** 移除音乐 */
- (void)removeMusic;
/** 播放音乐 */
- (void)playMusic;
/** 暂停音乐 */
- (void)pauseMusic;
/** 音乐跳到指定时间 */
- (void)audioSeekToTime:(CMTime)time;
/** 视频声音大小 */
- (void)adjustVolumeForVideo:(float)videoVolume;
/** 音乐声音大小 */
- (void)adjustVolumeForMusic:(float)musicVolume;
/** 获取视频时长 */
- (float)getVideoDuration;
/** 获取音乐时长 */
- (float)getAudioDuration;
/** 获取视频时长 */
- (CMTime)getVideoDurationTime;
/** 获取音乐时长 */
- (CMTime)getAudioDurationTime;
/** 是否播放中 */
- (BOOL)isPlaying;
/** 释放时候需要调用 */
- (void)removeAllObject;

@end

NS_ASSUME_NONNULL_END
