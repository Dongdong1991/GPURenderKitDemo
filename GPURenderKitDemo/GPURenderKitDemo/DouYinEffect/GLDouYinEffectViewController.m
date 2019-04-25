//
//  GLDouYinEffectViewController.m
//  WEOpenGLDemo
//
//  Created by 刘海东 on 2019/2/19.
//  Copyright © 2019 Leo. All rights reserved.
//

#import "GLDouYinEffectViewController.h"
#import "DouYinEffectTabView.h"
#import <GPURenderKit/GPURenderKit.h>

@interface GLDouYinEffectViewController ()<DouYinEffectTabViewDelegate>
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *preview;
@property (nonatomic, strong) GLImageThreePartitionGroupFilter *partitionFilter;
@property (nonatomic, strong) GLImageFourPointsMirrorFilter *pointsMirrorFiter;
@property (nonatomic, strong) GLImageGlitchEffectGridFilter *glitchEffectGridFilter;
@property (nonatomic, strong) GLImageGlitchEffectLineFilter *glitchEffectLineFilter;
@property (nonatomic, strong) GLImageSoulOutFilter *soulOutFilter;
@property (nonatomic, strong) GLImageZoomFilter *zoomFilter;
@property (nonatomic, strong) GLImageWaterReflectionFilter *waterReflectionFilter;
@property (nonatomic, strong) GLImageBlurSnapViewFilterGroup *blurSnapViewFilter;

@property (nonatomic, strong) DouYinEffectTabView *douYinEffectTabView;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *outPutFilter;

@property (nonatomic, assign) DouYinEffectType selectEffectType;
@property (nonatomic, strong) CADisplayLink *displayLink;


@end


@implementation GLDouYinEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.preview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.preview.layer.contentsScale = 2.0;
    self.preview.backgroundColor = [UIColor blackColor];
    [self.preview setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.view addSubview:self.preview];
    
    self.outPutFilter = self.partitionFilter;
    [self.outPutFilter addTarget:self.preview];
    [self.videoCamera addTarget:self.partitionFilter];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoCamera startCameraCapture];
    });
    
    [self douYinEffectTabView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self stopDisplayLink];
}

- (GPUImageVideoCamera *)videoCamera
{
    if (!_videoCamera)
    {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.runBenchmark = NO;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    
    return _videoCamera;
}

- (GLImageThreePartitionGroupFilter *)partitionFilter
{
    if (!_partitionFilter) {
        _partitionFilter = [[GLImageThreePartitionGroupFilter alloc]init];
        [_partitionFilter setTopLutImg:[UIImage imageNamed:@"xiatian"]];
        [_partitionFilter setMidLutImg:[UIImage imageNamed:@"meishi"]];
        [_partitionFilter setBottomLutImg:[UIImage imageNamed:@"heibai"]];
    }
    return _partitionFilter;
}

- (GLImageFourPointsMirrorFilter *)pointsMirrorFiter
{
    if (!_pointsMirrorFiter) {
        _pointsMirrorFiter = [[GLImageFourPointsMirrorFilter alloc]init];
    }
    return _pointsMirrorFiter;
}

- (GLImageGlitchEffectLineFilter *)glitchEffectLineFilter{
    if (!_glitchEffectLineFilter) {
        _glitchEffectLineFilter = [[GLImageGlitchEffectLineFilter alloc]init];
    }
    return _glitchEffectLineFilter;
}

- (GLImageGlitchEffectGridFilter *)glitchEffectGridFilter{
    if (!_glitchEffectGridFilter) {
        _glitchEffectGridFilter = [[GLImageGlitchEffectGridFilter alloc]init];
        [_glitchEffectGridFilter setPlaidImage:[UIImage imageNamed:@"glitchPicture000.png"]];
    }
    return _glitchEffectGridFilter;
}

- (GLImageSoulOutFilter *)soulOutFilter{
    if (!_soulOutFilter) {
        _soulOutFilter = [[GLImageSoulOutFilter alloc]init];
    }
    return _soulOutFilter;
}

- (GLImageZoomFilter *)zoomFilter{
    if (!_zoomFilter) {
        
        _zoomFilter = [[GLImageZoomFilter alloc]init];
    }
    return _zoomFilter;
}

- (GLImageWaterReflectionFilter *)waterReflectionFilter{
  
    if (!_waterReflectionFilter) {
        
        _waterReflectionFilter = [[GLImageWaterReflectionFilter alloc]init];
    }
    return _waterReflectionFilter;
}

- (GLImageBlurSnapViewFilterGroup *)blurSnapViewFilter{
    
    if (!_blurSnapViewFilter) {
        _blurSnapViewFilter = [[GLImageBlurSnapViewFilterGroup alloc]init];
    }
    return _blurSnapViewFilter;
}


- (DouYinEffectTabView *)douYinEffectTabView
{
    
    if (!_douYinEffectTabView)
    {
        _douYinEffectTabView = [[DouYinEffectTabView alloc]initWithFrame:CGRectMake(100, (kScreen_H - 200)/2.0, kScreen_W - 100, 200)];
        _douYinEffectTabView.delegate = self;
        [self.view addSubview:_douYinEffectTabView];
    }
    return _douYinEffectTabView;
    
}

- (void)startDisplayLinkFrameInterval:(NSInteger)frameInterval{
    self.displayLink = nil;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink.frameInterval = frameInterval;
}
- (void)handleDisplayLink:(CADisplayLink*)displayLink
{
    switch (self.selectEffectType) {
        case DouYinEffectType_GLImageGlitchEffectLineFilter:
        {
            self.glitchEffectLineFilter.intensity = arc4random()%100/100.0;
        }
            break;
        case DouYinEffectType_GLImageGlitchEffectGridFilter:
        {
            self.glitchEffectGridFilter.intensity = arc4random()%100/100.0;
            int index = arc4random()%6;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"glitchPicture00%d.png",index]];
            [self.glitchEffectGridFilter setPlaidImage:image];
        }
            break;
            
            
        default:
            break;
            
    }
}

- (void)stopDisplayLink{
    
    [self.displayLink invalidate];
    self.displayLink.paused = YES;
    _displayLink = nil;
}

- (void)dealloc
{
    [self.videoCamera stopCameraCapture];
    _videoCamera = nil;
}


- (void)didSelectEffectType:(DouYinEffectType)type{
    
    self.selectEffectType = type;
    [self stopDisplayLink];
    [self.outPutFilter removeTarget:self.preview];
    
    switch (type) {
        case DouYinEffectType_GLImageThreePartition:
        {
            self.outPutFilter = self.partitionFilter;
        }
            break;
        case DouYinEffectType_GLImageFourPointsMirrorFilter:
        {
            self.outPutFilter = self.pointsMirrorFiter;
        }
            break;
        case DouYinEffectType_GLImageGlitchEffectLineFilter:
        {
            self.outPutFilter = self.glitchEffectLineFilter;
            [self startDisplayLinkFrameInterval:2];
        }
            break;
        case DouYinEffectType_GLImageGlitchEffectGridFilter:
        {
            self.outPutFilter = self.glitchEffectGridFilter;
            [self startDisplayLinkFrameInterval:30];
        }
            break;
        case DouYinEffectType_GLImageSoulOutFilter:
        {
            self.outPutFilter = self.soulOutFilter;
        }
            break;
        case DouYinEffectType_GLImageZoomFilter:
        {
            self.outPutFilter = self.zoomFilter;
        }
            break;
        case DouYinEffectType_GLImageWaterReflectionFilter:
        {
            self.outPutFilter = self.waterReflectionFilter;
        }
            break;
        case DouYinEffectType_GLImageBlurSnapViewFilterGroup:
        {
            
            self.outPutFilter = self.blurSnapViewFilter;
        }
            break;

            
        default:
            break;
    }
    
    [self.outPutFilter addTarget:self.preview];
    [self.videoCamera addTarget:self.outPutFilter];
}





@end
