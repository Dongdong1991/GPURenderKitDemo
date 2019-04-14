//
//  DDAVAssetRenderManage.h
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/5.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <GPURenderKit/GPURenderKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DDAVAssetRenderFinishHandle)(void);

@protocol DDAVAssetRenderManageDelegate <NSObject>

- (void)outputProcessMovieFrameSampleBuffer:(CMSampleBufferRef)sampleBufferRef;

- (void)outputProcessAudioFrameSampleBuffer:(CMSampleBufferRef)sampleBufferRef;


@end


@interface DDAVAssetRenderManage : NSObject

/** 是否保留视频原声 */
@property (nonatomic, assign) BOOL isAddVideoVoiceBool;

/** 视频声音大小 */
@property (nonatomic, assign) float videoVolume;

/** frameDuration */
@property (nonatomic, assign) CMTime frameDuration;

@property (nonatomic, weak) id<DDAVAssetRenderManageDelegate> delegate;

- (instancetype)initWithVideoFileUrl:(NSURL *)videoFileUrl;


/**
 视频添加背景音乐

 @param musicFilePath 音乐文件路径
 @param startTime 开始时间
 @param musicVolume 音乐音量大小
 */
- (void)mixMusicFilePath:(NSURL *)musicFilePath startTime:(CMTime)startTime musicVolume:(float)musicVolume;


/**
 开始渲染
 */
- (void)startProcessing;


/**
 结束渲染的回调

 @param handle  结束渲染的回调
 */
- (void)finishProcessingWithCompletionHandler:(DDAVAssetRenderFinishHandle)handle;


/**
 取消渲染的回调

 @param handler 取消渲染的回调
 */
- (void)cancelProcessingHandler:(void (^)(void))handler;


@end

NS_ASSUME_NONNULL_END
