//
//  GLSliderView.m
//  GLImageDemo
//
//  Created by LEO on 2018/3/12.
//  Copyright © 2018年 LEO. All rights reserved.
//

#import "GLSliderView.h"

@interface GLSliderView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISlider  *sliderView;
@property (nonatomic, strong) UIView    *trackView;
@property (nonatomic, strong) UIView    *progressView;
@property (nonatomic, assign) float     progress;
@property (nonatomic,   weak) id        target;
@property (nonatomic, assign) SEL       action;

@end

@implementation GLSliderView
{
    float currentProgress;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        _progress = 0.1;
        self.progress = 0.0;
        _minimumValue = 0.0;
        _maximumValue = 1.0;
    }
    return self;
}

- (void)createSubviews
{
    //self.backgroundColor = [UIColor whiteColor];
    
    self.trackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 5)];
    self.trackView.backgroundColor = RGBA(0, 152, 255, 0.1);
    [self addSubview:self.trackView];
    
    self.progressView = [[UIView alloc] initWithFrame:self.trackView.bounds];
    self.progressView.backgroundColor = RGB(48, 109, 215);
    [self addSubview:self.progressView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHanlder:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (void)setProgress:(float)progress
{
    progress = MIN(MAX(progress, 0.0), 1.0);
    
    if (_progress != progress)
    {
        _progress = progress;
        _value = self.minimumValue + (self.maximumValue - self.minimumValue) * _progress;
        self.progressView.frame = CGRectMake(0, 0, self.trackView.bounds.size.width * progress, self.trackView.bounds.size.height);
        [self performActionWithValue:_value];
    }
}

- (void)setValue:(float)value
{
    _value = value;
    _progress = (value - self.minimumValue) / (self.maximumValue - self.minimumValue);
    self.progressView.frame = CGRectMake(0, 0, self.trackView.bounds.size.width * _progress, self.trackView.bounds.size.height);
}

- (void)setMinimumValue:(float)minimumValue
{
    _minimumValue = minimumValue;
    [self setValue:self.value];
}

- (void)setMaximumValue:(float)maximumValue
{
    _maximumValue = maximumValue;
    [self setValue:self.value];
}

- (void)performActionWithValue:(float)value
{
    if (self.sliderViewValueDidChangeHandler)
    {
        self.sliderViewValueDidChangeHandler(value);
    }
    
    if (self.target && self.action)
    {
        [self.target performSelector:self.action withObject:self afterDelay:0.0];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)panGestureHanlder:(UIPanGestureRecognizer *)gesture
{
    CGPoint translate = [gesture translationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        currentProgress = _progress;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        self.progress = currentProgress + translate.x / self.trackView.bounds.size.width;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
