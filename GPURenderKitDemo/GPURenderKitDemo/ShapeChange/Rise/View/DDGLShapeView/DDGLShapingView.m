//
//  DDGLShapingView.m
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/6/12.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#import "DDGLShapingView.h"
#import "DDGLShapeSelView.h"
#import <GPURenderKit/GPURenderKit.h>



@interface DDGLShapingView ()<DDGLShapeSelViewDelegate>

/** 选择区域 */
@property (nonatomic, strong) DDGLShapeSelView *strectchSelView;

/** 图像宽高 */
@property (nonatomic, assign) float imageWidth;
@property (nonatomic, assign) float imageHeight;
/** 类型 */
@property (nonatomic, assign) DDGLShapeViewType  type;
@property (nonatomic, assign) DDGLNormValueRange range;

/** 滑动中 */
@property (nonatomic, assign) BOOL swipingBool;

@property (nonatomic, strong) GPUImageView     *glPreview;
@property (nonatomic, strong) GLImageShapeFilter *glShapeFilter;
@property (nonatomic, strong) GPUImagePicture *glImagePicture;
@property (nonatomic, copy) UIImage *image;


@end

@implementation DDGLShapingView

- (instancetype)initWithFrame:(CGRect)frame type:(DDGLShapeViewType)type image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = type;
        self.userInteractionEnabled = YES;
        //默认的值
        DDGLNormValueRange range = {0,0};
        range.max = 75/100.0;
        range.min = 25/100.0;
        _range = range;
        
        _imageWidth = image.size.width;
        _imageHeight = image.size.height;
        
        _image = image;
        
        self.glImagePicture = [[GPUImagePicture alloc]initWithImage:image];
        [self.glImagePicture addTarget:self.glShapeFilter];
        [self.glShapeFilter addTarget:self.glPreview];
        [self.glImagePicture processImage];
        [self strectchSelView];
        
    
    }
    return self;
}



- (GLImageShapeFilter *)glShapeFilter
{
    
    if (!_glShapeFilter) {
        _glShapeFilter = [[GLImageShapeFilter alloc] init];
        _glShapeFilter.screenRatio = self.frame.size.width/self.frame.size.height;
        _glShapeFilter.imageWidth = _imageWidth;
        _glShapeFilter.imageHeight = _imageHeight;
        _glShapeFilter.minValue = _range.min;
        _glShapeFilter.maxValue = _range.max;
        _glShapeFilter.type = _type;
        [_glShapeFilter changeValue:0.0];
        [_glShapeFilter forceProcessingAtSize:CGSizeMake(self.frame.size.width*[UIScreen mainScreen].scale, self.frame.size.height*[UIScreen mainScreen].scale)];
    }
    return _glShapeFilter;
}


- (GPUImageView *)glPreview
{
    if (!_glPreview) {
        _glPreview = [[GPUImageView alloc] initWithFrame:self.bounds];
        [_glPreview setBackgroundColorRed:0.0 green:0.0 blue:0 alpha:1.0];
        _glPreview.backgroundColor = [UIColor blackColor];
        [self addSubview:_glPreview];
    }
    return _glPreview;
}


- (DDGLShapeSelView *)strectchSelView
{
    if (!_strectchSelView)
    {
        float imageRatio = (float)_imageWidth/_imageHeight;
        float screenRatio = (float)self.frame.size.width/self.frame.size.height;
        float originX;
        float originY;
        
        CGRect rect;
        
        if (_type == DDGLShapeViewType_Vertical) {
            if (imageRatio > screenRatio) {
                originY = 1.0*screenRatio/imageRatio;
            }else
            {
                originY = 1.0;
            }
            rect = CGRectMake(0, (1-originY)/2.0*self.frame.size.height, self.frame.size.width, self.frame.size.height*originY);
        }
        else
        {
            
            if (imageRatio > screenRatio) {
                originX = 1.0;
                originY = 1.0;
            }else
            {
                originX = 1.0*imageRatio/screenRatio;
                originY = 1.0;
            }
            rect = CGRectMake((1-originX)/2.0*self.frame.size.width, (1-originY)/2.0*self.frame.size.height, self.frame.size.width*originX, self.frame.size.height*originY);
        }
        
        CGSize superSize = self.glPreview.frame.size;
        CGSize fitSize = [self fitSizeWithImage:self.image superSize:superSize];
        CGRect subFrame = CGRectMake((superSize.width - fitSize.width) / 2.0, (superSize.height - fitSize.height) / 2.0, fitSize.width, fitSize.height);

        
        _strectchSelView = [[DDGLShapeSelView alloc]initWithFrame:rect type:_type subFrame:subFrame];
        _strectchSelView.valueRange = _range;
        _strectchSelView.delegate = self;
        [self addSubview:_strectchSelView];
        
    }
    return _strectchSelView;
}

- (CGSize)fitSizeWithImage:(UIImage *)image superSize:(CGSize)superSize
{
    float imageRatio = image.size.width / image.size.height;
    float superRatio = superSize.width / superSize.height;
    CGSize size = superSize;
    
    if (superRatio > imageRatio)
    {
        size.height = superSize.height;
        size.width = superSize.height * imageRatio;
    }
    else
    {
        size.width = superSize.width;
        size.height = superSize.width / imageRatio;
    }
    
    return size;
}



- (void)changeValue:(float)value
{
    [self.glShapeFilter changeValue:value];
    [self.glImagePicture processImage];
    
    
}

- (void)changeRange:(DDGLNormValueRange)range
{
    _range = range;
    _strectchSelView.valueRange = _range;
    self.glShapeFilter.minValue = _range.min;
    self.glShapeFilter.maxValue = _range.max;

}


- (DDGLNormValueRange)getRange
{
    return _range;
}


#pragma mark DDGLShapeSelViewDelegate
- (void)strectchSelViewSwiping
{
    //滚动中
    if (self.delegate && [self.delegate respondsToSelector:@selector(shapingViewSwiping)]) {
        if (!self.swipingBool) {
            [self.glShapeFilter changeValue:0];
            [self.glImagePicture processImage];
            [self.delegate shapingViewSwiping];
        }
        self.swipingBool = YES;
    }
}

#pragma mark 重写点击区域
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil)
    {
        for (UIView*subView in self.subviews)
        {
            if ([subView isKindOfClass:[DDGLShapeSelView class]])
            {
                CGPoint lowLeftPoint = [subView convertPoint:point fromView:self];
                view = [subView hitTest:lowLeftPoint withEvent:event];
            }
        }
    }
    return view;
}

- (void)strectchSelViewSwipEndMaxValue:(float)max minValue:(float)min
{
    _range.max = max;
    _range.min = min;
    self.swipingBool = NO;
    self.glShapeFilter.minValue = _range.min;
    self.glShapeFilter.maxValue = _range.max;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shapingViewSwipEndMaxValue:minValue:)]) {
        [self.delegate shapingViewSwipEndMaxValue:max minValue:min];
    }
}


- (void)getOriginImageVertexConfig
{

    __weak typeof(self) weakSelf = self;
    
    [self.glShapeFilter getVerticesAndTextureCoordinatesHandle:^(NSArray *squareVertexes, NSArray *textureCoordinates, float changeValue,NSInteger type){
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shapingViewGetVertexArray:textureCoordinateArray:changeValue:type:)])
        {
            [weakSelf.delegate shapingViewGetVertexArray:squareVertexes textureCoordinateArray:textureCoordinates changeValue:changeValue type:type];
        }
        
    }];

}

/** 隐藏选择区域的UI */
- (void)hideStrectchSelView
{
    self.strectchSelView.hidden = YES;
}

/** 显示选择区域的UI */
- (void)showStrectchSelView
{
    self.strectchSelView.hidden = NO;
}

- (UIImage *)getProcessImage
{
    [self.glImagePicture processImage];
    [self.glShapeFilter useNextFrameForImageCapture];
    return [self.glShapeFilter imageFromCurrentFramebuffer];
}




@end
