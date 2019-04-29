//
//  ATRiseMenuView.m
//  Artist
//
//  Created by 刘海东 on 2018/6/21.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import "ATRiseMenuView.h"
#import "ATSelectBarView.h"
#import "ATSliderView.h"
#define kSliderView_h 26
#define kSelectBarView_h 48

@interface ATRiseMenuView ()
@property (nonatomic, strong) ATSelectBarView *selectBarView;
@property (nonatomic, strong) ATSliderView *sliderView;

@end

@implementation ATRiseMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [self selectBarView];
        [self sliderView];
    }
    return self;
}


- (ATSelectBarView *)selectBarView
{
    if (!_selectBarView) {
        _selectBarView = [[ATSelectBarView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-kSelectBarView_h, kScreen_W, kSelectBarView_h)];
        _selectBarView.hideHelpButton = NO;
        kWeakeSelf;
        _selectBarView.selectBlock = ^(NSInteger index) {
            kStrongSelf;
            if (strongSelf.clickActionHandler) {
                strongSelf.clickActionHandler(index);
            }
        };
        
        
        
        [self addSubview:_selectBarView];
    }
    return _selectBarView;
}

- (ATSliderView *)sliderView
{
    if (!_sliderView) {
        
        _sliderView = [[ATSliderView alloc]initWithFrame:CGRectMake(20, 47, kScreen_W - 40, kSliderView_h)];
        [_sliderView configBigFollowView];
        [self addSubview:_sliderView];
        kWeakeSelf;
        
        _sliderView.valueDidChangeHandler = ^(float value) {
            kStrongSelf;
            strongSelf.sliderView.topLabValue = [NSString stringWithFormat:@"%.0f",value*100];
            if (strongSelf.valueDidChangeHandler) {
                strongSelf.valueDidChangeHandler(value);
            }
        };
        
        _sliderView.touchBeginHandler = ^(float value) {
            kStrongSelf;
            strongSelf.sliderView.topLabValue = [NSString stringWithFormat:@"%.0f",value*100];
            if (strongSelf.touchBeginHandler) {
                strongSelf.touchBeginHandler(value);
            }
        };
        
        _sliderView.touchEndHandler = ^(float value) {
            kStrongSelf;
            strongSelf.sliderView.topLabValue = [NSString stringWithFormat:@"%.0f",value*100];
            if (strongSelf.touchEndHandler) {
                strongSelf.touchEndHandler(value);
            }
        };
        
    }
    return _sliderView;
}

- (float)getValue
{
    return self.sliderView.value;
}


- (void)setValue:(float)value
{
    self.sliderView.value = value;
    
}

- (void)setTitle:(NSString *)tit
{
    self.selectBarView.title = tit;
    
}

- (void)minmimValue:(float)value
{
    self.sliderView.minmimValue = value;
}
- (void)maxmimValue:(float)value
{
    self.sliderView.maxmimValue = value;
}

- (void)hideHelpButton:(BOOL)state
{
    _selectBarView.hideHelpButton = state;
}





@end
