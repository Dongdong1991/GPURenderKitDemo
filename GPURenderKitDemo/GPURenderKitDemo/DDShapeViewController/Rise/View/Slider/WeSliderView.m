//
//  WeSliderView.m
//  LWSliderViewDemo
//
//  Created by Leo on 2018/3/14.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "WeSliderView.h"

@interface WeSliderView () <UIGestureRecognizerDelegate>


@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, assign) float ratio;

@end

@implementation WeSliderView
{
    float currentRatio;
    float threshold;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubviews];
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self createSubviews];
        [self setup];
    }
    return self;
}

- (void)setup
{
    threshold   = 0.1;
    _thumbWidth  = 20;
    
    _minmimValue = -1.0;
    _maxmimValue = 1.0;
    
    _progress    = -1.0;
    _trackHeight = 4.0;
    self.ratio   = 0.0;
    _followViewIntervalY = 0.0;
    
    _needInterruptAtZero = YES;
    
    self.thumbTintColor = [UIColor colorWithRed:255/255.0 green:108/255.0 blue:156/255.0 alpha:1.0];
    self.trackTintColor = [UIColor lightGrayColor];
    self.progressTintColor = [UIColor colorWithRed:255/255.0 green:108/255.0 blue:156/255.0 alpha:1.0];
}

- (void)createSubviews
{
    self.trackView = [[UIView alloc] init];
    self.trackView.clipsToBounds = YES;
    [self addSubview:self.trackView];
    
    self.progressView = [[UIView alloc] init];
    [self.trackView addSubview:self.progressView];
    
    self.thumbView = [[UIImageView alloc] init];
    self.thumbView.layer.cornerRadius = _thumbWidth / 2.0;
    [self addSubview:self.thumbView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureActionHandler:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (CGPoint)centerPoint
{
    return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
}

- (void)layoutSubviews
{
    CGPoint center = [self centerPoint];
    self.trackView.frame = CGRectMake(0, 0, self.bounds.size.width - _thumbWidth, _trackHeight);
    self.trackView.center = center;
    self.trackView.layer.cornerRadius = _trackHeight / 2.0;
    
    self.progressView.frame = self.trackView.bounds;
    self.thumbView.frame = CGRectMake(0, 0, _thumbWidth, _thumbWidth);
    self.thumbView.layer.cornerRadius = _thumbWidth / 2.0;
    
    [self updateProgressFrame];
}

- (void)updateProgressFrame
{
    float x = [self isOriginalPointCenter] ? self.trackView.bounds.size.width / 2.0 : 0.0;
    float w = [self progressWidth];
    self.progressView.frame = CGRectMake(x, 0, w * _progress, self.trackView.bounds.size.height);
    self.thumbView.center = CGPointMake(self.trackView.frame.origin.x + x + w * _progress, [self centerPoint].y);
    
    if (self.followView)
    {
        self.followView.center = CGPointMake(self.thumbView.center.x, CGRectGetMinY(self.thumbView.frame) - self.followView.frame.size.height / 2.0 - _followViewIntervalY);
    }
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    _thumbTintColor = thumbTintColor;
    self.thumbView.backgroundColor = thumbTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    self.trackView.backgroundColor = trackTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    self.progressView.backgroundColor = progressTintColor;
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    [self.thumbView setImage:thumbImage];
    
    if (thumbImage)
    {
        self.thumbView.backgroundColor = [UIColor clearColor];
        self.thumbView.layer.cornerRadius = 0.0;
        _thumbWidth = thumbImage.size.width;
        [self setNeedsLayout];
    }
}

-(void)setThumbWidth:(float)thumbWidth {
    _thumbWidth = thumbWidth;
    [self setNeedsLayout];
}

- (void)setFollowView:(UIView *)followView
{
    if (_followView)
    {
        [_followView removeFromSuperview];
    }
    
    _followView = followView;
    followView.hidden = YES;
    [self addSubview:_followView];
}

- (void)setTrackBorderWidth:(float)width color:(UIColor *)color
{
    self.trackView.layer.borderWidth = width;
    self.trackView.layer.borderColor = color.CGColor;
}

- (void)setThumbBorderWidth:(float)width color:(UIColor *)color
{
    self.thumbView.layer.borderWidth = width;
    self.thumbView.layer.borderColor = color.CGColor;
}

- (void)setTrackHeight:(float)trackHeight
{
    _trackHeight = trackHeight;
    [self setNeedsLayout];
}

- (void)setHiddenThumb:(BOOL)hiddenThumb
{
    _hiddenThumb = hiddenThumb;
    self.thumbView.hidden = hiddenThumb;
}

- (void)setMinmimValue:(float)minmimValue
{
    _minmimValue = minmimValue;
    [self setValue:_value];
}

- (void)setFollowViewIntervalY:(float)followViewIntervalY
{
    _followViewIntervalY = followViewIntervalY;
}

- (void)setMaxmimValue:(float)maxmimValue
{
    _maxmimValue = maxmimValue;
    [self setValue:_value];
}

- (void)setRatio:(float)ratio
{
    float minRatio = [self isOriginalPointCenter] ? -1.0 : threshold;
    float currentThreshold = [self isOriginalPointCenter] && _needInterruptAtZero ? threshold : 0.0;
    ratio = MAX(minRatio - threshold, MIN(1.0 + threshold, ratio));
    _ratio = ratio;
    
    if (fabs(ratio) < currentThreshold)
    {
        self.progress = 0.0;
    }
    else
    {
        if (ratio > 0)
        {
            self.progress =  ratio - currentThreshold;
        }
        else
        {
            self.progress = ratio + currentThreshold;
        }
    }
}

- (void)setProgress:(float)progress
{
    float minProgress = [self isOriginalPointCenter] ? -1.0 : 0.0;
    progress = MAX(minProgress, MIN(1.0, progress));
    
    if (_progress == progress)
    {
        return;
    }
    
    _progress = progress;
    [self updateProgressFrame];
    
    if (self.valueDidChangeHandler)
    {
        _value = progress >= 0 ? (_maxmimValue * progress) : (_minmimValue * -progress);
        self.valueDidChangeHandler(_value);
    }else{
        _value = progress >= 0 ? (_maxmimValue * progress) : (_minmimValue * -progress);
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setValue:(float)value
{
    value = MAX(_minmimValue, MIN(_maxmimValue, value));
    _value = value;
    
    if (_minmimValue != _maxmimValue)
    {
        if (_minmimValue >= 0)
        {
            _progress = (value - _minmimValue) / (_maxmimValue - _minmimValue);
        }
        else
        {
            _progress = value >= 0 ? value / _maxmimValue : -value / _minmimValue;
        }
        
        float currentThreshold = [self isOriginalPointCenter] && _needInterruptAtZero ? threshold : 0.0;
        
        if (_progress >= 0)
        {
            _ratio = _progress + currentThreshold;
        }
        else
        {
            _ratio = _progress - currentThreshold;
        }
        
        [self updateProgressFrame];
    }
}

- (void)setValue:(float)value animation:(BOOL)animation
{
    if (animation)
    {
        [UIView animateWithDuration:0.35 animations:^{
            self.value = value;
        }];
    }
    else
    {
        self.value = value;
    }
}



- (BOOL)isOriginalPointCenter
{
    return _minmimValue < 0 && _maxmimValue > 0;
}

- (float)progressWidth
{
    return [self isOriginalPointCenter] ? self.trackView.bounds.size.width / 2.0 : self.trackView.bounds.size.width;
}

- (void)panGestureActionHandler:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        currentRatio  = self.ratio;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [gesture translationInView:gesture.view];
        
        if ([self isOriginalPointCenter])
        {
            self.ratio = currentRatio + translate.x / self.progressWidth * (1.0 + threshold);
        }
        else
        {
            self.ratio = currentRatio + translate.x / self.progressWidth;
        }
    }
    else
    {
        [self doTouchEndAction];
    }
}

- (void)doTouchBeginAction
{
    if (self.touchBeginHandler)
    {
        self.touchBeginHandler(_value);
    }
    
    self.followView.hidden = NO;
}

- (void)doTouchEndAction
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];

    if (self.touchEndHandler)
    {
        self.touchEndHandler(_value);
    }

    self.followView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self doTouchBeginAction];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self doTouchEndAction];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
