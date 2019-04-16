//
//  FaceSliderView.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/16.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "FaceSliderView.h"

@interface FaceSliderView ()

@property (nonatomic, strong) UISlider *sliderView;
@property (nonatomic, strong) UILabel *titleLab;


@end


@implementation FaceSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.frame = CGRectMake(0, 0, self.frame.size.width, 20);
        self.titleLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleLab];
        
        
        self.sliderView = [[UISlider alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 30)];
        [self.sliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.sliderView];
        
    }
    return self;
}

- (void)setMinimumValue:(float)minimumValue{
    self.sliderView.minimumValue = minimumValue;
}

- (void)setMaximumValue:(float)maximumValue{
    self.sliderView.maximumValue = maximumValue;
}

- (void)sliderValueChange:(UISlider *)slider{
    
    if (self.valueChangeBlock) {
        self.titleLab.text = [NSString stringWithFormat:@"%@:%.2f",_title,slider.value];
        self.valueChangeBlock(slider.value);
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = [NSString stringWithFormat:@"%@:%.2f",title,self.sliderView.value];
}


@end
