//
//  VideoEcodeViewController.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/27.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "VideoEcodeViewController.h"
#import "DDVideoEcodeManage.h"

@interface VideoEcodeViewController ()<GPUImageVideoCameraDelegate>
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *preview;

@end

@implementation VideoEcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.videoCamera addTarget:self.preview];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCamera startCameraCapture];
    });
    
    
}

#pragma mark ------------------------------------------------------ lazy ------------------------------------------------------
- (GPUImageView *)preview{
    if (!_preview) {
        _preview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
        _preview.layer.contentsScale = 2.0;
        _preview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [_preview setBackgroundColorRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        [self.view addSubview:_preview];
    }
    return _preview;
}
- (GPUImageVideoCamera *)videoCamera
{
    if (!_videoCamera)
    {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.runBenchmark = NO;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _videoCamera.delegate = self;
        [_videoCamera startCameraCapture];
    }
    return _videoCamera;
}







@end
