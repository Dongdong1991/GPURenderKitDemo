//
//  WeSliderView.h
//  LWSliderViewDemo
//
//  Created by Leo on 2018/3/14.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeSliderView : UIControl

/** 最小值 defult 0.0 */
@property (nonatomic, assign) IBInspectable float     minmimValue;
/** 最大值 defult 1.0 */
@property (nonatomic, assign) IBInspectable float     maxmimValue;
/** defult 0.0 */
@property (nonatomic, assign) IBInspectable float     value;
/** 滑块颜色 */
@property (nonatomic, strong)  UIColor   *thumbTintColor;
/** 滑块图片 */
@property (nonatomic, strong)  UIImage   *thumbImage;
/** 轨迹颜色 */
@property (nonatomic, strong)  UIColor   *trackTintColor;
/** 进度条颜色 */
@property (nonatomic, strong)  UIColor   *progressTintColor;
/** 轨迹高度 defult 4.0 */
@property (nonatomic, assign) IBInspectable float     trackHeight;
/** 隐藏滑块 */
@property (nonatomic, assign) IBInspectable BOOL      hiddenThumb;
/** 滑块上部跟随视图 */
@property (nonatomic, strong) UIView    *followView;
/** 滑块上部跟随视图 和滑块的间隙 */
@property (nonatomic, assign) float followViewIntervalY;
/** 滑块的宽度大小 */
@property (nonatomic, assign)  float thumbWidth;

@property (nonatomic, strong) UIView *trackView;

/** 是否在value = 0.0处停顿下 defult YES 只在最小最大值异号时才起作用 */
@property (nonatomic, assign IBInspectable) BOOL      needInterruptAtZero;
@property (nonatomic, assign) float progress;

/** 回调Block */
@property (nonatomic, copy) void (^valueDidChangeHandler)(float value);
@property (nonatomic, copy) void (^touchBeginHandler)(float value);
@property (nonatomic, copy) void (^touchEndHandler)(float value);

/** 设置轨道边框 */
- (void)setTrackBorderWidth:(float)width color:(UIColor *)color;
/** 设置滑块边框 */
- (void)setThumbBorderWidth:(float)width color:(UIColor *)color;

- (void)setValue:(float)value animation:(BOOL)animation;

@end
