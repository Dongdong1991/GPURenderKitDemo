//
//  ATRiseViewController.m
//  Artist
//
//  Created by huangjinwen on 2018/6/21.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import "ATRiseViewController.h"
#import "ATRiseMenuView.h"
#import <GPURenderKit/GPURenderKit.h>

@interface ATRiseViewController ()<DDGLShapingViewDelegate>
@property (nonatomic, strong) DDGLShapingView *glShapingView;
@property (nonatomic, assign) DDGLNormValueRange rangeValue;
@property (nonatomic, strong) UISlider *slider;
@end

@implementation ATRiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDGLNormValueRange range = {0,0};
    range.max = 0.5;
    range.min = 0.2;
    _rangeValue = range;
    self.view.backgroundColor = [UIColor blackColor];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self configUI];
    });
}


- (void)configUI
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 50, 100, 50);
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(20, kScreen_H - 100, kScreen_W - 40, 50)];
    [self.view addSubview:slider];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    [slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(kScreen_W-100, 50, 100, 50);
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (DDGLShapingView *)glShapingView
{
    if (!_glShapingView) {
        float h = kScreen_H - kATRiseMenuView_h - SafeTopMargin - SafeBottomMargin - 50;
        _glShapingView = [[DDGLShapingView alloc]initWithFrame:CGRectMake(0, SafeTopMargin + 50, kScreen_W, h) type:_type image:self.previewImage];
        _glShapingView.delegate = self;
        [self.view addSubview:_glShapingView];
        [_glShapingView changeRange:self.rangeValue];
    }
    return _glShapingView;
}

- (void)shapingViewSwiping
{
    self.slider.value = 0.0;
    [self.glShapingView changeValue:self.slider.value];
    
}
- (void)shapingViewGetVertexArray:(NSArray *)vertexArray textureCoordinateArray:(NSArray *)textureCoordinateArray changeValue:(float)changeValue type:(DDGLShapeViewType)type
{
    
}
- (void)shapingViewSwipEndMaxValue:(float)max minValue:(float)min
{
    _rangeValue.max = max;
    _rangeValue.min = min;
    [_glShapingView changeRange:self.rangeValue];
    
}



- (void)setType:(DDGLShapeViewType)type
{
    _type = type;
}

- (void)setPreviewImage:(UIImage *)previewImage
{
    _previewImage = previewImage;
    [self glShapingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    NSLog(@"ATRiseViewController-- 增高或瘦身 dealloc");
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAction
{
    UIImage *ima = [self.glShapingView getProcessImage];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:ima];
    float h = ((kScreen_W-100)/ima.size.width) *ima.size.height;
    imageView.frame = CGRectMake(50, 200,  kScreen_W-100, h);
    [self.view addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
    });
    
}


- (void)valueChange:(UISlider *)slider
{
    [self.glShapingView changeValue:slider.value];
}




@end
