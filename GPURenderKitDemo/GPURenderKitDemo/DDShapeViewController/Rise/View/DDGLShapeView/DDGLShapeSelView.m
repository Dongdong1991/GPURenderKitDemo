//
//  DDGLShapeSelView.m
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/6/6.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#define kControlViewW 50
#define kSelfSize self.frame.size

#import "DDGLShapeSelView.h"
#import "DDGLShapeControlView.h"
#import "DDGLSelectView.h"


@interface DDGLShapeSelView ()
@property (nonatomic, assign) DDGLShapeViewType type;
@property (nonatomic, strong) DDGLShapeControlView *controlView1;
@property (nonatomic, strong) DDGLShapeControlView *controlView2;
@property (nonatomic, strong) DDGLSelectView *selectView;
@property (nonatomic, assign) CGRect subFrame;
@end


@implementation DDGLShapeSelView

- (instancetype)initWithFrame:(CGRect)frame type:(DDGLShapeViewType)type subFrame:(CGRect)subFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        _subFrame = subFrame;
        
        _type = type;

    }
    return self;
}

- (DDGLShapeControlView *)controlView1
{
    if (!_controlView1) {
        
        CGRect rect;
        if (_type == DDGLShapeViewType_Vertical) {
            rect = CGRectMake(kSelfSize.width-kSelfSize.width, -kControlViewW/2.0+kSelfSize.height*_valueRange.min, kSelfSize.width, kControlViewW);
        }else
        {
            rect = CGRectMake(kSelfSize.width*_valueRange.min-kControlViewW/2.0, 0, kControlViewW, kSelfSize.height);
        }
        _controlView1 = [[DDGLShapeControlView alloc]initWithFrame:rect type:_type];
        _controlView1.userInteractionEnabled = YES;
        [self addSubview:_controlView1];
        UILongPressGestureRecognizer *logPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        logPressGestureRecognizer.minimumPressDuration = 0.0;
        [_controlView1 addGestureRecognizer:logPressGestureRecognizer];
        
    }
    return _controlView1;
}

- (DDGLShapeControlView *)controlView2
{
    if (!_controlView2) {
        
        CGRect rect;
        if (_type == DDGLShapeViewType_Vertical) {
            rect = CGRectMake(kSelfSize.width-kSelfSize.width, kSelfSize.height*_valueRange.max-kControlViewW/2.0, kSelfSize.width, kControlViewW);
        }else
        {
            rect = CGRectMake((kSelfSize.width - kControlViewW/2.0)*_valueRange.max, 0, kControlViewW, kSelfSize.height);
        }
        _controlView2 = [[DDGLShapeControlView alloc]initWithFrame:rect type:_type];
        _controlView2.userInteractionEnabled = YES;
        [self addSubview:_controlView2];
        UILongPressGestureRecognizer *logPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        logPressGestureRecognizer.minimumPressDuration = 0.0;
        [_controlView2 addGestureRecognizer:logPressGestureRecognizer];
    }
    return _controlView2;
}

- (DDGLSelectView *)selectView
{
    if (!_selectView) {
        
        _selectView = [[DDGLSelectView alloc]init];
        _selectView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
        _selectView.type = _type;
        [self addSubview:_selectView];
        [self sendSubviewToBack:_selectView];
        if (_type == DDGLShapeViewType_Vertical)
        {
            _selectView.frame = CGRectMake(0, CGRectGetMidY(self.controlView1.frame), CGRectGetWidth(self.frame), CGRectGetMidY(self.controlView2.frame) - CGRectGetMidY(self.controlView1.frame));
        }else
        {
            _selectView.frame = CGRectMake(CGRectGetMidX(self.controlView1.frame), 0, CGRectGetMidX(self.controlView2.frame)-CGRectGetMidX(self.controlView1.frame), CGRectGetHeight(self.frame));
        }
        _selectView.hidden = YES;
        
    }
    return _selectView;
}



#pragma mark func

- (void)handlePan:(UILongPressGestureRecognizer *)sender {
    
    
    DDGLShapeControlView *tapSuperView = (DDGLShapeControlView *)sender.view;
    
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.selectView.hidden = NO;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.selectView.hidden = NO;
            if (sender.numberOfTouches <= 0) {
                return;
            }
            CGPoint tapPoint = [sender locationOfTouch:0 inView:self];
            
            
            switch (_type) {
                case DDGLShapeViewType_Vertical:
                {
                    tapPoint = CGPointMake(tapPoint.x, tapPoint.y-kControlViewW/2.0);
                    
                    [self verticalConfigPoint:tapPoint tapSuperView:tapSuperView];
                }
                    break;
                case DDGLShapeViewType_Horizontal:
                {
                    tapPoint = CGPointMake(tapPoint.x-kControlViewW/2.0, tapPoint.y);
                    [self horizontalConfigPoint:tapPoint tapSuperView:tapSuperView];
                }
                    break;
                    
                default:
                    break;
            }
            
            //滑动中
            if (self.delegate && [self.delegate respondsToSelector:@selector(strectchSelViewSwiping)]) {
                [self.delegate strectchSelViewSwiping];
            }
            
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            self.selectView.hidden = YES;
            [self calculateValue];
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            self.selectView.hidden = YES;
            [self calculateValue];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.selectView.hidden = YES;
            [self calculateValue];
        }
            break;
            
        default:
            break;
    }
    
}

/** 停止滑动时候 计算最大值 最小值 */
- (void)calculateValue
{
    
    float max = 1.0;
    float min = 0.0;
    
    if (_type == DDGLShapeViewType_Vertical) {
        float value1 = CGRectGetMidY(self.controlView1.frame)/self.frame.size.height;
        float value2 = CGRectGetMidY(self.controlView2.frame)/self.frame.size.height;
        if (value1>=value2) {
            max = value1;
            min = value2;
        }else
        {
            max = value2;
            min = value1;
        }
    }else
    {
        float value1 = CGRectGetMidX(self.controlView1.frame)/self.frame.size.width;
        float value2 = CGRectGetMidX(self.controlView2.frame)/self.frame.size.width;
        if (value1>=value2) {
            max = value1;
            min = value2;
        }else
        {
            max = value2;
            min = value1;
        }

    }
    
    
    if ([self.delegate respondsToSelector:@selector(strectchSelViewSwipEndMaxValue:minValue:)]) {
        [self.delegate strectchSelViewSwipEndMaxValue:max minValue:min];
    }
    
    
}


#pragma mark 竖
- (void)verticalConfigPoint:(CGPoint)tapPoint tapSuperView:(DDGLShapeControlView *)tapSuperView
{
    
    CGRect rect;
    if (tapSuperView == self.controlView1) {
        rect = self.controlView1.frame;
    }else{
        rect = self.controlView2.frame;
    }
    
    if (tapPoint.y<-kControlViewW/2.0)
    {
        tapPoint.y = -kControlViewW/2.0;
    }
    else if (tapPoint.y>kSelfSize.height-kControlViewW/2.0)
    {
        tapPoint.y = kSelfSize.height-kControlViewW/2.0;
    }
    
    rect.origin.y = tapPoint.y;
    
    if (tapSuperView == self.controlView1) {
        self.controlView1.frame = rect;
    }else{
        self.controlView2.frame = rect;
    }
    
    CGRect rect1 = self.controlView1.frame;
    CGRect rect2 = self.controlView2.frame;
    
    CGRect selectRect = self.selectView.frame;
    
    if (rect1.origin.y<rect2.origin.y) {
        selectRect.origin.y = CGRectGetMidY(self.controlView1.frame);
        selectRect.size.height = CGRectGetMidY(self.controlView2.frame) - CGRectGetMidY(self.controlView1.frame);
    }
    else
    {
        selectRect.origin.y = CGRectGetMidY(self.controlView2.frame);
        selectRect.size.height = CGRectGetMidY(self.controlView1.frame) - CGRectGetMidY(self.controlView2.frame);
    }
    self.selectView.frame = selectRect;
    
}
#pragma mark 横
- (void)horizontalConfigPoint:(CGPoint)tapPoint tapSuperView:(DDGLShapeControlView *)tapSuperView
{
    
    CGRect rect;
    if (tapSuperView == self.controlView1) {
        rect = self.controlView1.frame;
    }else{
        rect = self.controlView2.frame;
    }
    
    if (tapPoint.x<-kControlViewW/2.0)
    {
        tapPoint.x = -kControlViewW/2.0;
    }
    else if (tapPoint.x>kSelfSize.width-kControlViewW/2.0)
    {
        tapPoint.x = kSelfSize.width-kControlViewW/2.0;
    }
    
    rect.origin.x = tapPoint.x;
    
    if (tapSuperView == self.controlView1) {
        self.controlView1.frame = rect;
    }else{
        self.controlView2.frame = rect;
    }
    
    CGRect rect1 = self.controlView1.frame;
    CGRect rect2 = self.controlView2.frame;
    
    CGRect selectRect = self.selectView.frame;
    
    if (rect1.origin.x<rect2.origin.x) {
        selectRect.origin.x = CGRectGetMidX(self.controlView1.frame);
        selectRect.size.width = CGRectGetMidX(self.controlView2.frame) - CGRectGetMidX(self.controlView1.frame);
    }
    else
    {
        selectRect.origin.x = CGRectGetMidX(self.controlView2.frame);
        selectRect.size.width = CGRectGetMidX(self.controlView1.frame) - CGRectGetMidX(self.controlView2.frame);
    }
    self.selectView.frame = selectRect;
    
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil)
    {
        for (UIView*subView in self.subviews)
        {
            if ([subView isKindOfClass:[DDGLShapeControlView class]])
            {
                CGPoint lowLeftPoint = [subView convertPoint:point fromView:self];
                if ([subView pointInside:lowLeftPoint withEvent:event])
                {
                    view = subView;
                }
            }
        }
    }
    return view;
}

#pragma mark set
- (void)setValueRange:(DDGLNormValueRange)valueRange
{
    _valueRange = valueRange;
    [self controlView1];
    [self controlView2];
    [self selectView];
    [self updateSubViewsFrame];
}

- (void)updateSubViewsFrame
{
    CGRect rect;
    if (_type == DDGLShapeViewType_Vertical) {
        rect = CGRectMake(kSelfSize.width-kSelfSize.width, -kControlViewW/2.0+kSelfSize.height*_valueRange.min, kSelfSize.width, kControlViewW);
    }else
    {
        rect = CGRectMake(kSelfSize.width*_valueRange.min-kControlViewW/2.0, 0, kControlViewW, kSelfSize.height);
    }
    _controlView1.frame = rect;
    
    
    CGRect rect2;
    if (_type == DDGLShapeViewType_Vertical) {
        rect2 = CGRectMake(kSelfSize.width-kSelfSize.width, kSelfSize.height*_valueRange.max-kControlViewW/2.0, kSelfSize.width, kControlViewW);
    }else
    {
        rect2 = CGRectMake((kSelfSize.width - kControlViewW/2.0)*_valueRange.max, 0, kControlViewW, kSelfSize.height);
    }
    _controlView2.frame = rect2;
    
    if (_type == DDGLShapeViewType_Vertical)
    {
        self.selectView.frame = CGRectMake(CGRectGetMinX(self.subFrame), CGRectGetMidY(self.controlView1.frame), CGRectGetWidth(self.subFrame), CGRectGetMidY(self.controlView2.frame) - CGRectGetMidY(self.controlView1.frame));
    }else
    {
        self.selectView.frame = CGRectMake(CGRectGetMidX(self.controlView1.frame), self.subFrame.origin.y, CGRectGetMidX(self.controlView2.frame)-CGRectGetMidX(self.controlView1.frame), CGRectGetHeight(self.subFrame));
    }
}





@end
