//
//  DDGLShapeControlView.m
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/6/6.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#import "DDGLShapeControlView.h"

@interface DDGLShapeControlView ()


@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *controlView1;

@property (nonatomic, strong) UIImageView *controlView2;

@property (nonatomic, assign) DDGLShapeViewType type;



@end

@implementation DDGLShapeControlView


- (instancetype)initWithFrame:(CGRect)frame type:(DDGLShapeViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = type;
        
        [self lineView];
        [self controlView1];
        [self controlView2];
        
        
        if (_type == DDGLShapeViewType_Vertical)
        {
            self.controlView1.hidden = YES;
        }
        else
        {
            self.controlView2.hidden = YES;

        }

        
    }
    return self;
}


- (UIView *)lineView
{
    if (!_lineView)
    {
        CGRect rect;
        if (_type == DDGLShapeViewType_Vertical) {
            rect = CGRectMake(0, self.frame.size.height/2.0, self.frame.size.width, 1.0);
        }else
        {
            rect = CGRectMake(self.frame.size.width/2.0, 0, 1.0, self.frame.size.height);
        }
        _lineView = [[UIView alloc]initWithFrame:rect];
        _lineView.layer.shadowOffset = CGSizeMake(0, 0);
        _lineView.layer.shadowOpacity = 0.13;
        _lineView.layer.shadowRadius = 2;
        _lineView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];

    }
    return _lineView;
}


- (UIImageView *)controlView1
{
    if (!_controlView1) {
        
        CGRect rect;
        UIImage *image;
        if (_type == DDGLShapeViewType_Vertical)
        {
            image = [UIImage imageNamed:@"edit_beautify_rise_move"];
            rect = CGRectMake(0, (self.frame.size.height - image.size.height)/2.0, image.size.width, image.size.height);
        }
        else
        {
            image = [UIImage imageNamed:@"edit_beautify_slim_move"];
            rect = CGRectMake((self.frame.size.width - image.size.width)/2.0, 0, image.size.width,image.size.height);
        }
        _controlView1 = [[UIImageView alloc]initWithFrame:rect];
        _controlView1.image = image;
        [self addSubview:_controlView1];

    }
    return _controlView1;
}


- (UIImageView *)controlView2
{
    if (!_controlView2) {
        CGRect rect;
        UIImage *image;
        if (_type == DDGLShapeViewType_Vertical)
        {
            image = [UIImage imageNamed:@"edit_beautify_rise_move"];
            rect = CGRectMake(self.frame.size.width - image.size.width, (self.frame.size.height - image.size.height)/2.0, image.size.width,image.size.height);
        }
        else
        {
            image = [UIImage imageNamed:@"edit_beautify_slim_move"];
            rect = CGRectMake((self.frame.size.width - image.size.width)/2.0, self.frame.size.height-image.size.height, image.size.width,image.size.height);
        }
        _controlView2 = [[UIImageView alloc]initWithFrame:rect];
        _controlView2.image = image;
        [self addSubview:_controlView2];
    }
    return _controlView2;
}



- (void)handlePan:(UILongPressGestureRecognizer *)sender
{
    
    

}

@end
