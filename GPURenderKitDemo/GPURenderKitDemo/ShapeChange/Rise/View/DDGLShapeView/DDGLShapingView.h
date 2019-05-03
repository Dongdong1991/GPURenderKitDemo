//
//  DDGLShapingView.h
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/6/12.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDGLShapeView.h"


@protocol DDGLShapingViewDelegate <NSObject>
@optional
/** 选择区域拖拽中 */
- (void)shapingViewSwiping;
- (void)shapingViewGetVertexArray:(NSArray *)vertexArray textureCoordinateArray:(NSArray *)textureCoordinateArray changeValue:(float)changeValue type:(DDGLShapeViewType)type;
- (void)shapingViewSwipEndMaxValue:(float)max minValue:(float)min;

@end


@interface DDGLShapingView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(DDGLShapeViewType)type image:(UIImage *)image;
@property (nonatomic, weak) id<DDGLShapingViewDelegate> delegate;

- (DDGLNormValueRange)getRange;

/** 改变值 */
- (void)changeValue:(float)value;

/** 改变选择的区域 */
- (void)changeRange:(DDGLNormValueRange)range;

/** 获取配置 */
- (void)getOriginImageVertexConfig;

/** 隐藏选择区域的UI */
- (void)hideStrectchSelView;

/** 显示选择区域的UI */
- (void)showStrectchSelView;

- (UIImage *)getProcessImage;





@end
