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
@property (nonatomic, strong) DouYinEffectTabView *douYinEffectTabView;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *outPutFilter;

@end


@implementation GLDouYinEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.preview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.preview.layer.contentsScale = 2.0;
    self.preview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.preview setBackgroundColorRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self.view addSubview:self.preview];
    
    self.outPutFilter = self.partitionFilter;
    [self.outPutFilter addTarget:self.preview];
    [self.videoCamera addTarget:self.partitionFilter];
    
    
    [self douYinEffectTabView];
    
    
}

- (GPUImageVideoCamera *)videoCamera
{
    if (!_videoCamera)
    {
        _videoCamera = [[GPUImageVideoCamera alloc] init];
        _videoCamera.runBenchmark = YES;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        [_videoCamera startCameraCapture];
        [_videoCamera rotateCamera];
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



- (void)dealloc
{
    [self.videoCamera stopCameraCapture];
    _videoCamera = nil;
}


- (void)didSelectEffectType:(DouYinEffectType)type{
    
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
            
            
        default:
            break;
    }
    
    [self.outPutFilter addTarget:self.preview];
    [self.videoCamera addTarget:self.outPutFilter];

    
}


@end
