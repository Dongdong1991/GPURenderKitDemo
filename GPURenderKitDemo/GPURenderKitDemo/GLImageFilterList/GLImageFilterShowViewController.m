//
//  GLImageFilterShowViewController.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/13.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "GLImageFilterShowViewController.h"
#import "GLImagePickerHelper.h"
#import "GLSliderView.h"
#import "GLFilterInfoView.h"

@interface GLImageFilterShowViewController ()

@property (nonatomic, strong) GLSliderView      *silderView;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImagePicture   *picture;
@property (nonatomic, strong) GPUImageMovie     *movie;
@property (nonatomic, strong) GPUImageOutput    *inputSource;
@property (nonatomic, strong) GPUImageView      *preview;
@property (nonatomic, assign) GLIMAGE_FILTER_TYPE filterType;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, strong) GPUImageOutput <GPUImageInput> *filter;
@property (nonatomic, strong) GLFilterInfoView *filterInfoView;
@property (nonatomic,   copy) void (^silderValueDidChangeHandler)(float value);



@end

@implementation GLImageFilterShowViewController

- (instancetype)initWithFilterType:(GLIMAGE_FILTER_TYPE)filterType
{
    self = [super init];
    if (self) {
        
        self.filterType = filterType;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    [self setupFilter];
    
}

- (void)createSubviews
{
    CGRect frame = self.view.bounds;
    self.preview = [[GPUImageView alloc] initWithFrame:frame];
    self.preview.layer.contentsScale = 2.0;
    self.preview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.preview setBackgroundColorRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self.view addSubview:self.preview];
    [self.view addSubview:self.silderView];
    self.filterInfoView = [[GLFilterInfoView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    self.filterInfoView.userInteractionEnabled = NO;
    self.filterInfoView.title = self.title;
    self.filterInfoView.selected = NO;
    self.filterInfoView.degree = 0.0;
    self.filterInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.filterInfoView];
    
    if (self.inputSourceType == GL_INPUT_SOURCE_CAMERA)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rotate"] style:UIBarButtonItemStyleDone target:self action:@selector(rotateCamera)];
    }
    else if (self.inputSourceType == GL_INPUT_SOURCE_IMAGE)
    {
        UIBarButtonItem *albumButton = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(selectImageFromAlbum)];
        self.navigationItem.rightBarButtonItems = @[albumButton];
    }
}

- (void)setupFilter
{
    switch (self.filterType) {
        case GLIMAGE_LUT:
        {
            GLImageLutFilter *lutFilter = [[GLImageLutFilter alloc]init];
            [lutFilter setLutImage:[UIImage imageNamed:@"exposure_n"]];
            self.filter = lutFilter;
        }
            break;
        case GL_IMAGE_ADDSTICKER:
        {
            GLImageAddStickerFilter *stickerFilter = [[GLImageAddStickerFilter alloc]init];
            UIImage *stickerImage = [UIImage imageNamed:@"bunny"];
            [stickerFilter setStickerImage:stickerImage];
            stickerFilter.center = CGPointMake(0.5, 0.5);
            stickerFilter.theta = 0.0;
            self.filter = stickerFilter;
            self.silderView.minimumValue = 0.0;
            self.silderView.maximumValue = 2.0;
            
            self.silderValueDidChangeHandler = ^(float value) {
                stickerFilter.theta = value*M_PI;
                stickerFilter.center = CGPointMake(0.5*value, 0.5*value);
                NSLog(@"调节中心点，大小");
            };
        }
            break;
            
            
            
        default:
            break;
    }
    
}

- (void)rotateCamera
{
    [self.videoCamera rotateCamera];
}

- (void)selectImageFromAlbum
{
    __weak typeof(self) weakSelf = self;
    [GLImagePickerHelper showInController:self completion:^(UIImage *image, UIImage *thumbImage) {
        
        weakSelf.sourceImage = image;
        [weakSelf changeInputPicture:image];
    }];
}


- (void)changeInputPicture:(UIImage *)image
{
    GPUImagePicture *newPicture = [[GPUImagePicture alloc] initWithImage:image];
    
    for (id<GPUImageInput> target in _picture.targets)
    {
        [newPicture addTarget:target];
    }
    
    _picture = nil;
    _picture = newPicture;
    
    [self startProcessFilter];
}

- (void)startProcessFilter
{
    switch (self.inputSourceType)
    {
        case GL_INPUT_SOURCE_CAMERA: break;
        case GL_INPUT_SOURCE_IMAGE: [self.picture processImage]; break;
        case GL_INPUT_SOURCE_MOVIE: break;
        default: break;
    }
}

- (void)setFilter:(GPUImageOutput <GPUImageInput> *)filter
{
    _filter = filter;
    [self.inputSource addTarget:_filter];
    [_filter addTarget:self.preview];
    [self startProcessFilter];
}

#pragma mark - Input Source

- (GPUImageVideoCamera *)videoCamera
{
    if (!_videoCamera)
    {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
        _videoCamera.runBenchmark = YES;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        [_videoCamera startCameraCapture];
    }
    
    return _videoCamera;
}

- (GPUImagePicture *)picture
{
    if (!_picture)
    {
        if (self.sourceImage)
        {
            _picture = [[GPUImagePicture alloc] initWithImage:self.sourceImage];
        }
        else
        {
            _picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"flower"]];
        }
    }
    
    return _picture;
}

- (GPUImageMovie *)movie
{
    if (!_movie)
    {
        _movie = [[GPUImageMovie alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"测试视频" ofType:@"mp4"]]];
        _movie.shouldRepeat = YES;
        _movie.playAtActualSpeed = YES;
        [_movie startProcessing];
    }
    
    return _movie;
}

- (GLSliderView *)silderView
{
    if (!_silderView)
    {
        _silderView = [[GLSliderView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
        [_silderView addTarget:self action:@selector(sliderViewValueDidChangeAction:)];
    }
    
    return _silderView;
}

- (GPUImageOutput *)inputSource
{
    switch (self.inputSourceType)
    {
        case GL_INPUT_SOURCE_CAMERA: return self.videoCamera;
        case GL_INPUT_SOURCE_IMAGE: return self.picture;
        case GL_INPUT_SOURCE_MOVIE: return self.movie;
        default: return nil;
    }
}



- (void)sliderViewValueDidChangeAction:(UISlider *)sender
{
    if (self.silderValueDidChangeHandler)
    {
        self.silderValueDidChangeHandler(sender.value);
    }
    
    self.filterInfoView.degree = sender.value;
    [self startProcessFilter];
}


@end
