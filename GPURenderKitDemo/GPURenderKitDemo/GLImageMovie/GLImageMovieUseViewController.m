//
//  GLImageMovieUseViewController.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/5.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "GLImageMovieUseViewController.h"
#import "DDAVAssetRenderManage.h"
#import "DDMediaEditorManage.h"
#import "MBProgressHUD.h"
#import "MovieViewController.h"
@interface GLImageMovieUseViewController ()<DDAVAssetRenderManageDelegate>

@property (nonatomic, strong) DDAVAssetRenderManage *assetRenderManage;
@property (nonatomic, strong) GLImageMovie *imageMovie;
@property (nonatomic, strong) GPUImageMovieWriterFix *movieWriter;
@property (nonatomic, strong) GPUImageView *preview;
@property (nonatomic, strong) DDMediaEditorManage *mediaEditorManage;
@property (nonatomic, strong) GLImageLutFilter *lutFilter;

@property (nonatomic, strong) UIImage *lutImage;
@property (nonatomic, strong) NSURL *musicFileUrl;

@property (nonatomic, strong) UIButton *addMusicBtn;
@property (nonatomic, strong) UIButton *changeLutBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSURL *outputFileUrl;


@end

@implementation GLImageMovieUseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_mediaEditorManage) {
        if (!_mediaEditorManage.isPlaying) {
            @weakify(self);
            [_mediaEditorManage videoSeekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                @strongify(self);
                [self.mediaEditorManage playVideo];
            }];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.preview.layer.contentsScale = 2.0;
    self.preview.backgroundColor = [UIColor blackColor];
    [self.preview setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.view addSubview:self.preview];
    
    //添加滤镜filter
    self.lutFilter = [[GLImageLutFilter alloc]init];
    self.lutImage = [UIImage imageNamed:@"heibai.png"];
    [self.lutFilter setLutImage:self.lutImage];
    [self.lutFilter addTarget:self.preview];
    
    //
    [self.mediaEditorManage.movie addTarget:self.lutFilter];
    
    @weakify(self);
    [self.mediaEditorManage playVideo];
    [self.mediaEditorManage setVideoPlayEndCallBack:^{
        @strongify(self);
        @weakify(self);
        [self.mediaEditorManage videoSeekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            @strongify(self);
            [self.mediaEditorManage playVideo];
        }];
    }];
    
    //添加背景音乐
    self.addMusicBtn = [self createBtnTit:@"添加音乐" btnFrame:CGRectMake(0, kScreen_H - 100, kScreen_W/4.0, 50) action:@selector(addMusicAction)];
    //切换滤镜
    self.changeLutBtn = [self createBtnTit:@"切换滤镜" btnFrame:CGRectMake((kScreen_W - kScreen_W/4.0)/2.0, kScreen_H - 100, kScreen_W/4.0, 50) action:@selector(changLutAction)];
    //保存视频
    self.saveBtn = [self createBtnTit:@"保   存" btnFrame:CGRectMake(kScreen_W - kScreen_W/4.0, kScreen_H - 100, kScreen_W/4.0, 50) action:@selector(saveAction)];
}

- (DDMediaEditorManage *)mediaEditorManage{
    
    if (!_mediaEditorManage) {
        NSURL *mediaUrl = [[NSBundle mainBundle] URLForResource:@"测试视频" withExtension:@"mp4"];
        _mediaEditorManage = [[DDMediaEditorManage alloc]initWithUrl:mediaUrl];
    }
    return _mediaEditorManage;
}

- (UIButton *)createBtnTit:(NSString *)btnTit btnFrame:(CGRect)btnFrame action:(SEL)action{
    
    UIButton *targetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [targetBtn setTitle:btnTit forState:UIControlStateNormal];
    targetBtn.frame = btnFrame;
    [targetBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:targetBtn];
    return targetBtn;
}


- (void)addMusicAction{
    
        if (!self.musicFileUrl) {
            NSURL *mediaUrl = [[NSBundle mainBundle] URLForResource:@"6666" withExtension:@"mp3"];
            self.musicFileUrl = mediaUrl;
            [self.addMusicBtn setTitle:@"移除音乐" forState:UIControlStateNormal];
            [self.mediaEditorManage addAudioPath:self.musicFileUrl];
            [self.mediaEditorManage adjustVolumeForMusic:0.9];
            [self.mediaEditorManage adjustVolumeForVideo:0.1];
            @weakify(self);
            [self.mediaEditorManage videoSeekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                @strongify(self);
                [self.mediaEditorManage playVideo];
            }];
            
        }else{
            
            [self.addMusicBtn setTitle:@"添加音乐" forState:UIControlStateNormal];
            self.musicFileUrl = nil;
            [self.mediaEditorManage adjustVolumeForVideo:1.0];
            [self.mediaEditorManage removeMusic];
        }
}



- (void)changLutAction{
    
    NSArray *lutArray = @[@"gaoya",@"heibai",@"jingdu",@"meishi",@"xiatian"];
    NSInteger index = arc4random()%(lutArray.count);
    self.lutImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",lutArray[index]]];
    [self.lutFilter setLutImage:self.lutImage];
}

- (void)saveAction{
    
    [self.mediaEditorManage pauseVideo];
    [MBProgressHUD showHUDAddedTo:self.preview animated:YES];
    
    NSURL *mediaUrl = [[NSBundle mainBundle] URLForResource:@"测试视频" withExtension:@"mp4"];
    self.assetRenderManage = [[DDAVAssetRenderManage alloc]initWithVideoFileUrl:mediaUrl];
    self.assetRenderManage.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [self.assetRenderManage finishProcessingWithCompletionHandler:^{
        NSLog(@"渲染完成");
        [weakSelf finshRecord];
    }];
    
    self.assetRenderManage.videoVolume = 1.0;
    self.assetRenderManage.isAddVideoVoiceBool = YES;
    
    if (self.musicFileUrl) {
        self.assetRenderManage.videoVolume = 0.3;
        [self.assetRenderManage mixMusicFilePath:self.musicFileUrl startTime:kCMTimeZero musicVolume:0.7];
    }
    
    self.imageMovie = [[GLImageMovie alloc]init];
    self.imageMovie.runBenchmark = YES;
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/videoFromSaveManager.mov"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    self.outputFileUrl = movieURL;
    self.movieWriter = [[GPUImageMovieWriterFix alloc] initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    
    self.movieWriter.encodingLiveVideo = YES;
    self.movieWriter.assetWriter.movieFragmentInterval = kCMTimeInvalid;
    self.movieWriter.hasAudioTrack = YES;
    
    GLImageLutFilter *lutFilter = [[GLImageLutFilter alloc]init];
    [lutFilter setLutImage:self.lutImage];
    
    [self.imageMovie addTarget:self.lutFilter];
    [self.lutFilter addTarget:self.movieWriter];
    
    [self.movieWriter startRecording];
    [self.assetRenderManage startProcessing];

}

- (void)finshRecord{
    [self.imageMovie endProcessing];
    [self.movieWriter endProcessing];
    
    [MBProgressHUD hideHUDForView:self.preview animated:YES];
    @weakify(self);
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"渲染完成----");
            @strongify(self);
            MovieViewController *vc = [[MovieViewController alloc]initWithMediaFileUrl:self.outputFileUrl];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
}

- (void)outputProcessAudioFrameSampleBuffer:(CMSampleBufferRef)sampleBufferRef{
    [self.movieWriter processAudioBuffer:sampleBufferRef];
}

- (void)outputProcessMovieFrameSampleBuffer:(CMSampleBufferRef)sampleBufferRef{
    [self.imageMovie processMovieFrameSampleBuffer:sampleBufferRef];
}



@end
