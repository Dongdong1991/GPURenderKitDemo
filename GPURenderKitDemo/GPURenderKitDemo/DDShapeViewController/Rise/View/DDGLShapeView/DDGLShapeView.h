//
//  DDGLShapeView.h
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/5/30.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

/** 归一化的 0.0-1.0*/
struct DDGLNormValueRange{
    /** 最大值 */
    float max;
    /** 最小值 */
    float min;
};
typedef struct DDGLNormValueRange DDGLNormValueRange;


/** 拉伸图的类型 */
typedef NS_ENUM(NSInteger,DDGLShapeViewType)
{
    /** 竖直方向 */
    DDGLShapeViewType_Vertical = 0,
    /** 水平方向 */
    DDGLShapeViewType_Horizontal,
};

@protocol DDGLShapeViewDelegate <NSObject>

- (void)strectchViewGetVertexArray:(NSArray *)vertexArray changeValue:(float)changeValue;

@end

@interface DDGLShapeView : UIView

@property (nonatomic, weak) id<DDGLShapeViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame type:(DDGLShapeViewType)type image:(UIImage *)image;

@property (nonatomic, assign) DDGLNormValueRange valueRange;
- (void)getOriginImageVertexConfig;
- (void)changeValue:(float)value;

@end
