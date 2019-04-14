//
//  GLImageFilterListViewController.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/11.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "GLImageFilterListViewController.h"
#import <GPURenderKit/GPURenderKit.h>
#import "GLImageFilterShowViewController.h"


@interface GLImageFilterListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *preview;
@property (nonatomic, copy) NSString *oldCategorySession; //保存session，恢复时使用
@property (nonatomic, strong) GPUImageMovieWriterFix *movieWriter;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) GL_INPUT_SOURCE_TYPE inputSourceType;


@end

@implementation GLImageFilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputSourceType = GL_INPUT_SOURCE_IMAGE;
    [self createTitleView];
    [self createTableView];
}


- (void)createTitleView
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"相机", @"照片", @"影片"]];
    segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    [segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl setSelectedSegmentIndex:self.inputSourceType];
}

- (void)segmentedAction:(UISegmentedControl *)sender
{
    self.inputSourceType = sender.selectedSegmentIndex;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return GLIMAGE_NUMBEROFFILTER;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSInteger index = indexPath.row;
    cell.textLabel.text = GetFilterNameWithType(index);
    
    return cell;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GLImageFilterShowViewController *filterViewController = [[GLImageFilterShowViewController alloc] initWithFilterType:indexPath.row];
    filterViewController.title = cell.textLabel.text;
    filterViewController.inputSourceType = self.inputSourceType;
    [self.navigationController pushViewController:filterViewController animated:YES];
}



- (void)test{
    [self.videoCamera addTarget:self.preview];
    self.oldCategorySession = [AVAudioSession sharedInstance].category;
    [GLImageFilterListViewController setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers];
    [self.videoCamera startCameraCapture];

}

- (GPUImageView *)preview{
    
    if (!_preview) {
        _preview = [[GPUImageView alloc]initWithFrame:self.view.bounds];
        _preview.backgroundColor = [UIColor blackColor];
        [_preview setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.view addSubview:_preview];
    }
    return _preview;
}


- (GPUImageVideoCamera *)videoCamera{
    
    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;//设置照片的方向为设备的定向
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;//设置前置为镜像
        _videoCamera.horizontallyMirrorRearFacingCamera = NO;//设置后置为非镜像
    }
    return _videoCamera;
}

- (GPUImageMovieWriterFix *)movieWriter{
    if (!_movieWriter) {
        
        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/videoFromSaveManager.mov"];
        unlink([pathToMovie UTF8String]);
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        _movieWriter = [[GPUImageMovieWriterFix alloc]initWithMovieURL:movieURL size:CGSizeMake(720, 1280)];
    }
    return _movieWriter;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _movieWriter.encodingLiveVideo = YES;
    _movieWriter.shouldPassthroughAudio = YES;
    _movieWriter.assetWriter.movieFragmentInterval = kCMTimeInvalid;
    _movieWriter.hasAudioTrack = YES;
    
    [self.videoCamera addTarget:self.movieWriter];

    
    bool addAudioInputBool =  [_videoCamera addAudioInputsAndOutputs];
    if (addAudioInputBool) {
        NSLog(@"添加成功");
    }else{
        NSLog(@"添加失败");
    }
    
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    [self.movieWriter startRecording];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.movieWriter endProcessing];
        
        [self.movieWriter finishRecordingWithCompletionHandler:^{
            NSLog(@"录制完成");
            
        }];
        
    });
    
    
    
    
}


+ (void)setCategory:(AVAudioSessionCategory)category withOptions:(AVAudioSessionCategoryOptions)options {
    if ([[AVAudioSession sharedInstance].category isEqualToString:category]) {
        return;
    }
    
    NSError *error = nil;
    BOOL isSuccess = [[AVAudioSession sharedInstance] setCategory:category withOptions:options error:&error];
    if (error) {
        NSLog(@"set audiosession error ! category:%@ , options:%lu, error:%@",category,(unsigned long)options,error.description);
    }
    
    NSError *activeError = nil;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&activeError];
    if (activeError) {
        NSLog(@"setAudioSessionPlaybackAndMixWithOthers deactive audiosession failed !");
    }
}


- (void)dealloc{
    NSLog(@"---->");
    [GLImageFilterListViewController setCategory:self.oldCategorySession withOptions:AVAudioSessionCategoryOptionMixWithOthers];
}



@end
