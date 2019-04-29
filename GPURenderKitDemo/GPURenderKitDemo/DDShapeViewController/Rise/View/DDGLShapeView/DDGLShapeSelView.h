//
//  DDGLShapeSelView.h
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/6/6.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDGLShapeView.h"


@protocol DDGLShapeSelViewDelegate <NSObject>

/** 滑动选择区域中 */
- (void)strectchSelViewSwiping;

/** 滑动结束 */
- (void)strectchSelViewSwipEndMaxValue:(float)max minValue:(float)min;

@end

@interface DDGLShapeSelView : UIView



- (instancetype)initWithFrame:(CGRect)frame type:(DDGLShapeViewType)type subFrame:(CGRect)subFrame;
@property (nonatomic, assign) DDGLNormValueRange valueRange;

@property (nonatomic, weak) id<DDGLShapeSelViewDelegate> delegate;


@end
