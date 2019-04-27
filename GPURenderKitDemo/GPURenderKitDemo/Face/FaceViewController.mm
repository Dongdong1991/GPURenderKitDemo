//
//  FaceViewController.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/15.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "FaceViewController.h"
#import "MGFaceLicenseHandle.h"
#import "MGFacepp.h"
#import "FaceSliderView.h"

@interface FaceViewController ()<GPUImageVideoCameraDelegate>
@property (nonatomic, strong) MGFacepp *markManager;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *preview;
@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;
@property (nonatomic, strong) GLImageFaceChangeFilterGroup *faceChangeFilterGroup;
@property (nonatomic, strong) UIButton *rotateBtn;
@property (nonatomic, strong) UISwitch *switchView;

@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, assign) BOOL faceServiceBool;
@property (nonatomic, strong) FaceSliderView *thinFaceView;
@property (nonatomic, strong) FaceSliderView *eyeFaceView;
@property (nonatomic, strong) FaceSliderView *noseFaceView;
@property (nonatomic, strong) FaceSliderView *beautifyView;

@end

@implementation FaceViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeAllObject];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     GLImageFaceChangeFilter是人脸微整的效果。是把识别到的106个人脸关键点传到shader里面去。然后做像素的平移变化。
     你们可以先查看项目里面有一张图片。"人脸106个关键点.png"。结合shader里面用到的点加深理解。
     */
    
    
    @weakify(self);
    [self checkFaceServiceBlock:^(BOOL results) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.faceServiceBool = results;
            if (results) {
                [self configFaceMarkManager];
                [self setupFaceConfig];
            }else{
                NSLog(@"授权未通过，未能开启人脸关键点识别服务。");
                [self setupNoFaceConfig];
            }
        });
    }];
}

- (void)checkFaceServiceBlock:(void(^)(BOOL results))block{
    
    /** 进行联网授权版本判断，联网授权就需要进行网络授权 */
    BOOL needLicense = [MGFaceLicenseHandle getNeedNetLicense];
    if (needLicense) {
        [MGFaceLicenseHandle licenseForNetwokrFinish:^(bool License, NSDate *sdkDate) {
            if (!License) {
                NSLog(@"联网授权失败 ！！！");
                if (block) {
                    block(NO);
                }
            } else {
                NSLog(@"联网授权成功");
                if (block) {
                    block(YES);
                }
            }
        }];
        
    } else {
        NSLog(@"SDK 为非联网授权版本！");
        if (block) {
            block(NO);
        }
    }
}

- (void)setupFaceConfig{
    
    //添加瘦脸，大眼filter
    self.faceChangeFilterGroup = [[GLImageFaceChangeFilterGroup alloc]init];
    [self.faceChangeFilterGroup setCaptureDevicePosition:self.videoCamera.cameraPosition];
    [self.faceChangeFilterGroup addTarget:self.preview];
    [self.beautifyFilter addTarget:self.faceChangeFilterGroup];
    [self.videoCamera addTarget:self.beautifyFilter];
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 40*2;
    CGFloat h = 50;
    
    @weakify(self);
    
    //脸部控制
    self.thinFaceView = [[FaceSliderView alloc]initWithFrame:CGRectMake(40, kScreen_H - 100, w, h)];
    [self.view addSubview:self.thinFaceView];
    self.thinFaceView.title = @"瘦脸or胖脸";
    self.thinFaceView.minimumValue = -1.0;
    self.thinFaceView.maximumValue = 1.0;
    self.thinFaceView.valueChangeBlock = ^(float value) {
        @strongify(self);
        self.faceChangeFilterGroup.thinFaceParam = value;
    };
    
    //大眼控制
    self.eyeFaceView = [[FaceSliderView alloc]initWithFrame:CGRectMake(40, kScreen_H - 100 - 50, w, h)];
    [self.view addSubview:self.eyeFaceView];
    self.eyeFaceView.title = @"大眼or小眼";
    self.eyeFaceView.minimumValue = -1.0;
    self.eyeFaceView.maximumValue = 1.0;
    self.eyeFaceView.valueChangeBlock = ^(float value) {
        @strongify(self);
        self.faceChangeFilterGroup.eyeParam = value;
    };
    
    //鼻子控制
    self.noseFaceView = [[FaceSliderView alloc]initWithFrame:CGRectMake(40, kScreen_H - 100 - 100, w, h)];
    [self.view addSubview:self.noseFaceView];
    self.noseFaceView.title = @"大鼻or小鼻";
    self.noseFaceView.minimumValue = -1.0;
    self.noseFaceView.maximumValue = 1.0;
    self.noseFaceView.valueChangeBlock = ^(float value) {
        @strongify(self);
        self.faceChangeFilterGroup.noseParam = value;
    };


    //美颜
    self.beautifyView = [[FaceSliderView alloc]initWithFrame:CGRectMake(40, kScreen_H - 100 - 150, w, h)];
    [self.view addSubview:self.beautifyView];
    self.beautifyView.title = @"美颜";
    self.beautifyView.minimumValue = 0.0;
    self.beautifyView.maximumValue = 1.0;
    self.beautifyView.valueChangeBlock = ^(float value) {
        @strongify(self);
        self.beautifyFilter.intensity = value;
    };
    
    [self rotateBtn];
    [self switchView];
    
}

- (void)setupNoFaceConfig{
    
    
    [self.beautifyFilter addTarget:self.preview];
    [self.videoCamera addTarget:self.beautifyFilter];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 40*2;
    CGFloat h = 50;
    
    @weakify(self);

    //美颜
    self.beautifyView = [[FaceSliderView alloc]initWithFrame:CGRectMake(40, kScreen_H - 100 - 70, w, h)];
    [self.view addSubview:self.beautifyView];
    self.beautifyView.title = @"美颜";
    self.beautifyView.minimumValue = 0.0;
    self.beautifyView.maximumValue = 1.0;
    self.beautifyView.valueChangeBlock = ^(float value) {
        @strongify(self);
        self.beautifyFilter.intensity = value;
    };
    
    [self rotateBtn];
}



- (void)configFaceMarkManager{
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:KMGFACEMODELNAME ofType:@""];
    NSData *modelData = [NSData dataWithContentsOfFile:modelPath];
    
    int maxFaceCount = 0;
    int faceSize = 100;
    int internal = 40;

    MGDetectROI detectROI = MGDetectROIMake(0, 0, 0, 0);

    self.markManager = [[MGFacepp alloc] initWithModel:modelData
                                               maxFaceCount:maxFaceCount
                                              faceppSetting:^(MGFaceppConfig *config) {
                                                  config.minFaceSize = faceSize;
                                                  config.interval = internal;
                                                  config.orientation = 90;
                                                  config.detectionMode = MGFppDetectionModeTrackingFast;
                                                  config.detectROI = detectROI;
                                                  config.pixelFormatType = PixelFormatTypeNV21;
                                              }];
    
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

- (GPUImageBeautifyFilter *)beautifyFilter{
    if (!_beautifyFilter) {
        _beautifyFilter = [[GPUImageBeautifyFilter alloc]init];
        _beautifyFilter.intensity = 0.0;
    }
    return _beautifyFilter;
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
        self.devicePosition = _videoCamera.cameraPosition;
        [_videoCamera startCameraCapture];
    }
    
    return _videoCamera;
}

- (UIButton *)rotateBtn{
    if (!_rotateBtn) {
        _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_rotateBtn];
        UIImage *image = [UIImage imageNamed:@"rotate"];
        _rotateBtn.frame = CGRectMake(kScreen_W - 1.5 *image.size.width, 100, image.size.width,image.size.height );
        [_rotateBtn setImage:image forState:UIControlStateNormal];
        [_rotateBtn addTarget:self action:@selector(rotateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateBtn;
}

- (UISwitch *)switchView{
    if (!_switchView) {
        
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(self.rotateBtn.frame), 51, 31)];
        _switchView.on = YES;
        [_switchView addTarget:self action:@selector(switchViewvalueChanged:) forControlEvents:(UIControlEventValueChanged)];
        [self.view addSubview:_switchView];
    }
    return _switchView;
}

- (void)rotateBtnAction{
    [_videoCamera rotateCamera];
    self.devicePosition = _videoCamera.cameraPosition;
    
    if (self.faceServiceBool) {
        [self.faceChangeFilterGroup setCaptureDevicePosition:self.videoCamera.cameraPosition];
    }
    
}

/** 是否显示人脸检测关键点 */
- (void)switchViewvalueChanged:(UISwitch *)switchView{
    
    self.faceChangeFilterGroup.isShowFaceDetectPointBool = switchView.isOn;
}


#pragma mark ------------------------------------------------------ GPUImageVideoCameraDelegate ------------------------------------------------------
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{

    if (self.faceServiceBool) {
        if (self.markManager.status != MGMarkWorking) {
            [self detectSampleBuffer:sampleBuffer];
        }
    }else{
        NSLog(@"未能开启人脸检测");
    }
}


- (void)detectSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    MGImageData *imageData = [[MGImageData alloc] initWithSampleBuffer:sampleBuffer];
    [self.markManager beginDetectionFrame];

    NSArray *tempArray = [self.markManager detectWithImageData:imageData];
    NSUInteger faceCount = tempArray.count;
    if (faceCount == 0) {
        self.faceChangeFilterGroup.isHaveFace = NO;
        [self.faceChangeFilterGroup setFacePointsArray:@[]];
    }else{
        self.faceChangeFilterGroup.isHaveFace = YES;
    }
    NSLog(@"face Count : %zd",faceCount);
    for (MGFaceInfo *faceInfo in tempArray) {
        [self.markManager GetGetLandmark:faceInfo isSmooth:YES pointsNumber:106];
//        NSLog(@"%@",faceInfo.points);
        [self.faceChangeFilterGroup setFacePointsArray:faceInfo.points];
    }
    [self.markManager endDetectionFrame];
}


#pragma mark ------------------------------------------------------ 清空所有数据 ------------------------------------------------------
- (void)removeAllObject{
    [_videoCamera stopCameraCapture];
    if (_faceChangeFilterGroup) {
        [_faceChangeFilterGroup removeAllTargets];
        _faceChangeFilterGroup = nil;
    }
    
    if (_beautifyFilter) {
        [_beautifyFilter removeAllTargets];
        _beautifyFilter = nil;
    }
    
    if (_preview) {
        _preview = nil;
    }
    
    if (_markManager) {
        _markManager = nil;
    }
}

@end
