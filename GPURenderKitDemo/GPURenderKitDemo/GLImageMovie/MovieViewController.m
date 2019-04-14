//
//  MovieViewController.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/15.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "MovieViewController.h"
#import "DDMediaEditorManage.h"
@interface MovieViewController ()
@property (nonatomic, strong) GPUImageView *preview;
@property (nonatomic, strong) DDMediaEditorManage *mediaEditorManage;
@property (nonatomic, strong) NSURL *mediaFileUrl;
@end

@implementation MovieViewController

- (instancetype)initWithMediaFileUrl:(NSURL *)mediaFileUrl
{
    self = [super init];
    if (self) {
        
        self.mediaFileUrl = mediaFileUrl;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.preview.layer.contentsScale = 2.0;
    self.preview.backgroundColor = [UIColor blackColor];
    [self.preview setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.view addSubview:self.preview];
    
    [self.mediaEditorManage.movie addTarget:self.preview];
    
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
    
    
}

- (DDMediaEditorManage *)mediaEditorManage{
    
    if (!_mediaEditorManage) {
        _mediaEditorManage = [[DDMediaEditorManage alloc]initWithUrl:self.mediaFileUrl];
    }
    return _mediaEditorManage;
}


@end
