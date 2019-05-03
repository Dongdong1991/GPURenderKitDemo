//
//  DDGLShapeView.m
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/5/30.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#define kVertical_h 200

#import "DDGLShapeView.h"
#import "DDGLShapeSelView.h"
#import "DDGLShapeControlView.h"

@interface DDGLShapeView ()<GLKViewDelegate>

{
    GLfloat squareVertexData[40];
}

@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic , strong) EAGLContext* mContext;
@property (nonatomic , strong) GLKBaseEffect* mEffect;

@property (nonatomic, assign) float changValue;

/** 图像宽高 */
@property (nonatomic, assign) float imageWidth;
@property (nonatomic, assign) float imageHeight;
/** 类型 */
@property (nonatomic, assign) DDGLShapeViewType  type;

@property (nonatomic, copy) NSArray *vertexArray;



@end

@implementation DDGLShapeView
- (instancetype)initWithFrame:(CGRect)frame type:(DDGLShapeViewType)type image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        //新建OpenGLES 上下文
        self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        self.glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
        [EAGLContext setCurrentContext:self.mContext];
        
        self.imageWidth = image.size.width;
        self.imageHeight = image.size.height;
        
        NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
        GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:nil];
        //着色器
        self.mEffect = [[GLKBaseEffect alloc] init];
        self.mEffect.texture2d0.enabled = GL_TRUE;
        self.mEffect.texture2d0.name = textureInfo.name;
        
    }
    return self;
}

- (GLKView *)glkView
{
    
    if(!_glkView)
    {
        _glkView = [[GLKView alloc]initWithFrame:self.bounds context:self.mContext];
        _glkView.delegate = self;
        [self addSubview:_glkView];
        
    }
    
    return _glkView;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    glClearColor(1.f, 1.f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    NSArray * array;
    
    switch (_type) {
        case DDGLShapeViewType_Vertical:
        {
            array = [self verticalConfigVertex];
            _vertexArray = array;
        }
            break;
        case DDGLShapeViewType_Horizontal:
        {
            array = [self horizontalConfigVertex];
            _vertexArray = array;
        }
            break;
        default:
            break;
    }
        
    for (int i=0; i!=array.count; i++) {
        NSNumber *value = array[i];
        squareVertexData[i] = value.floatValue;
    }
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    [self.mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 8);
}

#pragma mark 配置竖直方向上面的顶点数据
- (NSArray *)verticalConfigVertex
{
    
    float imageRatio = (float)self.imageWidth/self.imageHeight;
    float screenRatio = (float)self.frame.size.width/self.frame.size.height;
    float xfactor=1.0;
    float yfactor=1.0;
    
    
    float tempValue = self.changValue;
    //负值
    float xMinus = -xfactor;
    float yMinus = -yfactor;
    
    //正值
    float xPlus = xfactor;
    float yPlus = yfactor;
    
    
    float x1,x2,x3,x4,x5,x6,x7,x8 = 0.0;
    float y1,y2,y3,y4,y5,y6,y7,y8 = 0.0;
    float tx1,tx2,tx3,tx4,tx5,tx6,tx7,tx8 = 0.0;
    float ty1,ty2,ty3,ty4,ty5,ty6,ty7,ty8 = 0.0;
    
    
    if (imageRatio > screenRatio) {
        
        //宽顶到边
        yMinus = xMinus*screenRatio/(_imageWidth/(_imageHeight+tempValue*kVertical_h));
        yPlus = xPlus*screenRatio/(_imageWidth/(_imageHeight+tempValue*kVertical_h));
        
        //原来的比例
        float originY = xPlus*screenRatio/imageRatio;
        
        //高大于宽
        x1 = xMinus;
        y1 = yMinus;
        tx1 = 0;
        ty1 = 0;
        
        x2 = xPlus;
        y2 = yMinus;
        tx2 = 1;
        ty2 = 0;
        
        
        /** 极限值的判断处理 */
        if ((yMinus<-1.0000001 || yMinus>-0.0000001) || (yPlus>1.0000001 || yPlus<.0000001)) {
            
            //负值
            yMinus = -yfactor;
            //正值
            yPlus = yfactor;
            
            xMinus = yMinus*_imageWidth/(_imageHeight+tempValue*kVertical_h)/screenRatio;
            xPlus = xPlus*_imageWidth/(_imageHeight+tempValue*kVertical_h)/screenRatio;
            
            //原来的比例
            float originX = yMinus*imageRatio/screenRatio;
            
            x1 = xMinus;
            y1 = yMinus;
            tx1 = 0;
            ty1 = 0;
            
            x2 = xPlus;
            y2 = yMinus;
            tx2 = 1;
            ty2 = 0;
            
            //原来的高
            CGFloat h = ABS(1-2*_valueRange.max + 1) *xMinus/originX;
            
            x3 = xMinus;
            y3 = -(1.0-h);
            tx3 = 0;
            ty3 = (1-_valueRange.max);
            
            x4 = xPlus;
            y4 = -(1.0-h);
            tx4 = 1;
            ty4 = (1-_valueRange.max);
            
            
            x5 = xMinus;
            y5 = (1-2*_valueRange.min*xMinus/originX);
            tx5 = 0;
            ty5 = (1-_valueRange.min);
            
            
            x6 = xPlus;
            y6 = (1-2*_valueRange.min*xMinus/originX);
            tx6 = 1;
            ty6 = (1-_valueRange.min);
            
            x7 = xMinus;
            y7 = yPlus;
            tx7 = 0;
            ty7 = 1;
            
            x8 = xPlus;
            y8 = yPlus;
            tx8 = 1;
            ty8 = 1;
            
        }
        else
        {
            //形变
            CGFloat h = yPlus;
            CGFloat value = (h - originY);
            
            x3 = xMinus;
            y3 = (1-2*_valueRange.max)*originY-value;
            tx3 = 0;
            ty3 = (1-_valueRange.max);
            
            x4 = xPlus;
            y4 = (1-2*_valueRange.max)*originY-value;
            tx4 = 1;
            ty4 = (1-_valueRange.max);
            
            x5 = xMinus;
            y5 =  (1-2*_valueRange.min)*originY+value;
            tx5 = 0;
            ty5 = (1-_valueRange.min);
            
            x6 = xPlus;
            y6 = (1-2*_valueRange.min)*originY+value;
            tx6 = 1;
            ty6 = (1-_valueRange.min);
            
            x7 = xMinus;
            y7 = yPlus;
            tx7 = 0;
            ty7 = 1;
            
            x8 = xPlus;
            y8 = yPlus;
            tx8 = 1;
            ty8 = 1;
            
            
        }
        
        
    }
    else
    {
        
        //高顶到边
        xMinus = yMinus*_imageWidth/(_imageHeight+tempValue*kVertical_h)/screenRatio;
        xPlus = xPlus*_imageWidth/(_imageHeight+tempValue*kVertical_h)/screenRatio;
        //原来的比例
        float originX = yMinus*imageRatio/screenRatio;
        
        x1 = xMinus;
        y1 = yMinus;
        tx1 = 0;
        ty1 = 0;
        
        x2 = xPlus;
        y2 = yMinus;
        tx2 = 1;
        ty2 = 0;
        
        //原来的高
        CGFloat h = ABS(1-2*_valueRange.max + 1) *xMinus/originX;
        
        x3 = xMinus;
        y3 = -(1.0-h);
        tx3 = 0;
        ty3 = (1-_valueRange.max);
        
        
        x4 = xPlus;
        y4 = -(1.0-h);
        tx4 = 1;
        ty4 = (1-_valueRange.max);
        
        
        x5 = xMinus;
        y5 = (1-2*_valueRange.min*xMinus/originX);
        tx5 = 0;
        ty5 = (1-_valueRange.min);
        
        
        x6 = xPlus;
        y6 = (1-2*_valueRange.min*xMinus/originX);
        tx6 = 1;
        ty6 = (1-_valueRange.min);
        
        x7 = xMinus;
        y7 = yPlus;
        tx7 = 0;
        ty7 = 1;
        
        x8 = xPlus;
        y8 = yPlus;
        tx8 = 1;
        ty8 = 1;
        
        
    }
    
    NSArray *array = @[
                       //（x1,y1）
                       @(x1), @(y1), @(0),  @(tx1), @(ty1),
                       //（x2,y2）
                       @(x2), @(y2), @(0),  @(tx2), @(ty2),
                       //（x3,y3）
                       @(x3), @(y3), @(0),  @(tx3), @(ty3),
                       //（x4,y4）
                       @(x4), @(y4), @(0),  @(tx4), @(ty4),
                       //（x5,y5）
                       @(x5), @(y5), @(0),  @(tx5), @(ty5),
                       //（x6,y6）
                       @(x6), @(y6), @(0),  @(tx6), @(ty6),
                       //（x7,y7）
                       @(x7), @(y7), @(0),  @(tx7), @(ty7),
                       //（x8,y8）
                       @(x8), @(y8), @(0),  @(tx8), @(ty8),
                       ];
    
    return array;
}

#pragma mark 配置水平方向上面的顶点数据
- (NSArray *)horizontalConfigVertex
{
    float imageRatio = (float)self.imageWidth/self.imageHeight;
    float screenRatio = (float)self.frame.size.width/self.frame.size.height;
    float xfactor=1.0;
    float yfactor=1.0;
    
    float tempValue = self.changValue;
    //负值
    float xMinus = -xfactor;
    float yMinus = -yfactor;
    
    //正值
    float xPlus = xfactor;
    float yPlus = yfactor;
    
    float x1,x2,x3,x4,x5,x6,x7,x8 = 0.0;
    float y1,y2,y3,y4,y5,y6,y7,y8 = 0.0;
    float tx1,tx2,tx3,tx4,tx5,tx6,tx7,tx8 = 0.0;
    float ty1,ty2,ty3,ty4,ty5,ty6,ty7,ty8 = 0.0;
    
    //压缩最大的值域区间的80%
    float compressMaxValue = (_valueRange.max - _valueRange.min)*_imageWidth*0.8;
    
    if (imageRatio > screenRatio) {
        
        //宽顶到边
        yMinus = xMinus*screenRatio/imageRatio;
        yPlus = xPlus*screenRatio/imageRatio;
        
        //        NSLog(@"宽顶到边");
        
        //改变的比例
        float neW_xMinus = yMinus*((self.imageWidth-compressMaxValue*tempValue)/self.imageHeight)/screenRatio;
        //改变的值
        float w = ABS(xMinus - neW_xMinus);
        
        x1 = xMinus+w;
        y1 = yMinus;
        tx1 = 0;
        ty1 = 0;
        
        x2 = xMinus+w;
        y2 = yPlus;
        tx2 = 0;
        ty2 = 1;
        
        x3 = (1-2*_valueRange.min)/xMinus+w;
        y3 = yMinus;
        tx3 = _valueRange.min;
        ty3 = 0;
        
        x4 = (1-2*_valueRange.min)/xMinus+w;
        y4 = yPlus;
        tx4 = _valueRange.min;
        ty4 = 1;
        
        x5 =  (1-2*_valueRange.max)/xMinus-w;
        y5 = yMinus;
        tx5 = _valueRange.max;
        ty5 = 0;
        
        
        x6 = (1-2*_valueRange.max)/xMinus-w;
        y6 = yPlus;
        tx6 = _valueRange.max;
        ty6 = 1;
        
        x7 = xPlus-w;
        y7 = yMinus;
        tx7 = 1;
        ty7 = 0;
        
        x8 = xPlus-w;
        y8 = yPlus;
        tx8 = 1;
        ty8 = 1;
    }
    else
    {
        
        
        xMinus = yMinus*((_imageWidth+tempValue*compressMaxValue*-1)/_imageHeight)/screenRatio;
        xPlus = yPlus*((_imageWidth+tempValue*compressMaxValue*-1)/_imageHeight)/screenRatio;
        //        NSLog(@"高顶到边");
        //原来的比例
        float originX = yPlus*imageRatio/screenRatio;
        float w = originX - xPlus;
        //高大于宽
        x1 = xMinus;
        y1 = yMinus;
        tx1 = 0;
        ty1 = 0;
        
        x2 = xMinus;
        y2 = yPlus;
        tx2 = 0;
        ty2 = 1;
        
        x3 = -(1-2*_valueRange.min)*originX+w;
        y3 = yMinus;
        tx3 = _valueRange.min;
        ty3 = 0;
        
        x4 = -(1-2*_valueRange.min)*originX+w;
        y4 = yPlus;
        tx4 = _valueRange.min;
        ty4 = 1;
        
        x5 = -(1-2*_valueRange.max)*originX-w;
        y5 = yMinus;
        tx5 = _valueRange.max;
        ty5 = 0;
        
        x6 = -(1-2*_valueRange.max)*originX-w;
        y6 = yPlus;
        tx6 = _valueRange.max;
        ty6 = 1;
        
        x7 = xPlus;
        y7 = yMinus;
        tx7 = 1;
        ty7 = 0;
        
        x8 = xPlus;
        y8 = yPlus;
        tx8 = 1;
        ty8 = 1;
    }
    
    NSArray *array = @[
                       //（x1,y1）
                       @(x1), @(y1), @(0),  @(tx1), @(ty1),
                       //（x2,y2）
                       @(x2), @(y2), @(0),  @(tx2), @(ty2),
                       //（x3,y3）
                       @(x3), @(y3), @(0),  @(tx3), @(ty3),
                       //（x4,y4）
                       @(x4), @(y4), @(0),  @(tx4), @(ty4),
                       //（x5,y5）
                       @(x5), @(y5), @(0),  @(tx5), @(ty5),
                       //（x6,y6）
                       @(x6), @(y6), @(0),  @(tx6), @(ty6),
                       //（x7,y7）
                       @(x7), @(y7), @(0),  @(tx7), @(ty7),
                       //（x8,y8）
                       @(x8), @(y8), @(0),  @(tx8), @(ty8),
                       ];
    return array;
    
}

#pragma mark set
- (void)setValueRange:(DDGLNormValueRange)valueRange
{
    _valueRange = valueRange;
}

#pragma mark func

- (void)changeValue:(float)value
{
    self.changValue = value;
    [self.glkView display];
}

- (void)getOriginImageVertexConfig
{
    
    switch (_type) {
        case DDGLShapeViewType_Vertical:
        {
            
            NSNumber *yValue = _vertexArray[1];
            CGFloat y = ABS(yValue.floatValue);
            
            NSMutableArray *muarray = [NSMutableArray arrayWithArray:_vertexArray];
            for (int i=0; i!=_vertexArray.count; i++)
            {
                //处理x坐标
                if (i%5==0)
                {
                    if (i%10==0)
                    {
                        muarray[i] = @(-1.0);
                    }
                    else
                    {
                        muarray[i] = @(1.0);
                    }
                }

                if (i%5==1) {
                    NSNumber *yV = _vertexArray[i];
                    muarray[i] = @(yV.floatValue/y);
                }
            }
            
            float value=kVertical_h*self.changValue;
            if (self.delegate && [self.delegate respondsToSelector:@selector(strectchViewGetVertexArray:changeValue:)])
            {
                [self.delegate strectchViewGetVertexArray:muarray changeValue:value];
            }
            
            
        }
            break;
        case DDGLShapeViewType_Horizontal:
        {
            NSMutableArray *muarray = [NSMutableArray arrayWithArray:_vertexArray];
            
            NSNumber *xValue = _vertexArray[0];
            CGFloat x = ABS(xValue.floatValue);
            
            NSNumber *yValue = _vertexArray[1];
            CGFloat y = ABS(yValue.floatValue);
            
            for (int i=0; i!=_vertexArray.count; i++)
            {

                if (i%5==0) {
                    NSNumber *xV = _vertexArray[i];
                    muarray[i] = @(xV.floatValue/x);
                }

                if (i%5==1) {
                    NSNumber *yV = _vertexArray[i];
                    muarray[i] = @(yV.floatValue/y);
                }

            }

            float compressMaxValue = (_valueRange.max - _valueRange.min)*_imageWidth*0.8;
            float value=compressMaxValue*self.changValue;
            if (self.delegate && [self.delegate respondsToSelector:@selector(strectchViewGetVertexArray:changeValue:)])
            {
                [self.delegate strectchViewGetVertexArray:muarray changeValue:value];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)dealloc
{
    if (self.mContext) {
        _mContext = nil;
        _mEffect = nil;
        [EAGLContext setCurrentContext:nil];
    }
    NSLog(@"DDGLShapeView---dealloc");
}


@end
