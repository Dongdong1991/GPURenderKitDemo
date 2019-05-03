//
//  GLSliderView.h
//  GLImageDemo
//
//  Created by LEO on 2018/3/12.
//  Copyright © 2018年 LEO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLSliderView : UIView

@property (nonatomic, assign) float value;
@property (nonatomic, assign) float minimumValue;
@property (nonatomic, assign) float maximumValue;
@property (nonatomic,   copy) void (^sliderViewValueDidChangeHandler)(float value);

- (void)addTarget:(id)target action:(SEL)action;

@end
