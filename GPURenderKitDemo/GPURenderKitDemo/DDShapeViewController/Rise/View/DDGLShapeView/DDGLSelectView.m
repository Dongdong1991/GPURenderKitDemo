//
//  DDGLSelectView.m
//  Artist
//
//  Created by 刘海东 on 2018/7/11.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import "DDGLSelectView.h"


@interface DDGLSelectView ()

@property (nonatomic, strong) UILabel *contentLab;

@end


@implementation DDGLSelectView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_type == DDGLShapeViewType_Vertical)
    {
        float w = self.frame.size.width;
        float h = 30;
        float y = (self.frame.size.height - h)/2.0;
        if (self.frame.size.height<=h+10)
        {
            self.contentLab.hidden = YES;
        }
        else
        {
            self.contentLab.hidden = NO;
        }
        self.contentLab.frame = CGRectMake(0, y, w, h);
    }
    else
    {
        float w = 150;
        float h = 60;
        float y = (self.frame.size.height - h)/2.0;
        float x = (self.frame.size.width - w)/2.0;
        if (self.frame.size.width<=w+10)
        {
            self.contentLab.hidden = YES;
        }
        else
        {
            self.contentLab.hidden = NO;
        }
        self.contentLab.frame = CGRectMake(x, y, w, h);
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}


- (UILabel *)contentLab
{
    if (!_contentLab)
    {
        _contentLab = [[UILabel alloc]init];
        _contentLab.font = [UIFont fontWithName:@"SFUIText-Semibold" size:14];
        _contentLab.textColor = [UIColor whiteColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLab];
    }
    return _contentLab;
}


- (void)setType:(DDGLShapeViewType)type
{
    _type = type;
    if (_type == DDGLShapeViewType_Vertical)
    {
        self.contentLab.text = @"Drag the line to select the area";
    }
    else
    {
        self.contentLab.text = @"Drag the line to select the area";
        self.contentLab.numberOfLines = 2;
    }
}

@end
