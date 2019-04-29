//
//  ATSliderView.m
//  Artist
//
//  Created by 刘海东 on 2018/6/30.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import "ATSliderView.h"

@interface ATSliderView ()
@property (nonatomic, strong) UILabel *topLab;
@property (nonatomic, assign) float topLabW;

@end

@implementation ATSliderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configBigFollowView];
}


-(void)configSmallFollowView
{
    self.topLabW = 40;
    [self configUI];
    self.thumbWidth = 20;
}



- (void)setThumbSize:(float)thumbSize
{
    _thumbSize = thumbSize;
    self.thumbWidth = _thumbSize;
}

-(void)configBigFollowView
{
    self.topLabW = 50;
    self.thumbWidth = 26;
    [self configUI];
}

-(void)configDefaultThumbWidth {
    self.thumbWidth = 26;
}

-(void)configSmallThumbWidth {
    self.thumbWidth = 20;
}

- (void)configUI
{

    self.topLab.frame = CGRectMake(0, 0, self.topLabW, self.topLabW);

    self.followView = self.topLab;

    self.followViewIntervalY = 18;
    self.minmimValue = 0.0;
    self.maxmimValue = 1.0;
    self.thumbTintColor = [UIColor whiteColor];
    self.trackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    self.trackHeight = 2.0;
    self.progressTintColor = [UIColor whiteColor];
    WEAKSELF
    self.touchBeginHandler = ^(float value)
    {
        weakSelf.progress = value;
    };
    if (_thumbSize) {
        self.thumbWidth = _thumbSize;
    }

}


- (UILabel *)topLab
{
    if (!_topLab) {
        
        _topLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.topLabW, self.topLabW)];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.font = [UIFont boldSystemFontOfSize:16.f];
        _topLab.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        _topLab.layer.cornerRadius = self.topLabW/2.0;
        _topLab.layer.masksToBounds = YES;
        _topLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.95];
    }
    return _topLab;
}

- (void)setTopLabValue:(NSString *)topLabValue
{
    if (![self.topLab.text isEqualToString:topLabValue] && ([topLabValue isEqualToString:@"-100"] || [topLabValue isEqualToString:@"0"] || [topLabValue isEqualToString:@"100"])) {
    }
    self.topLab.text = topLabValue;
}

- (void)setHideTopLab:(BOOL)hideTopLab
{
    _hideTopLab = hideTopLab;
    self.topLab.hidden = hideTopLab;
}

- (void)setProgress:(float)progress
{
    [super setProgress:progress];
    if (_autoTopLab) {
        self.topLabValue = [NSString stringWithFormat:@"%.0f",MIN(progress*100, 100)];
    }
}

@end
