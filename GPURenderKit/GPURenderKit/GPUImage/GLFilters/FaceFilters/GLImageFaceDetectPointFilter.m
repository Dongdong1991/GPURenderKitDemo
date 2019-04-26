//
//  GLImageFaceDetectPointFilter.m
//  GPURenderKit
//
//  Created by 刘海东 on 2019/4/25.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "GLImageFaceDetectPointFilter.h"

NSString *const kGLImageFaceDetectPointFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     
     highp vec2 uv = textureCoordinate;     
     gl_FragColor = vec4(0.2, 0.709803922, 0.898039216, 1.0);
 }
 );

NSString *const kGLImageFaceDetectPointVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     gl_PointSize = 8.0;
     textureCoordinate = inputTextureCoordinate.xy;
 }
 );

@interface GLImageFaceDetectPointFilter ()

@property (nonatomic, strong) NSArray *pointArrays;

@property (nonatomic, assign) GLfloat videoFrameW;
@property (nonatomic, assign) GLfloat videoFrameH;

@end


@implementation GLImageFaceDetectPointFilter

- (instancetype)init
{
    self = [super initWithVertexShaderFromString:kGLImageFaceDetectPointVertexShaderString fragmentShaderFromString:kGLImageFaceDetectPointFragmentShaderString];
    if (self) {
        self.isShowFaceDetectPointBool = YES;
    }
    return self;
}

- (void)setFacePointsArray:(NSArray *)pointArrays{
    _pointArrays = pointArrays;    
}

- (void)setIsShowFaceDetectPointBool:(BOOL)isShowFaceDetectPointBool{
    _isShowFaceDetectPointBool = isShowFaceDetectPointBool;
}


- (void)setupFilterForSize:(CGSize)filterFrameSize
{
    self.videoFrameW = filterFrameSize.width;
    self.videoFrameH = filterFrameSize.height;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates{
    
    
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex
{
    //是否开启人脸监测点
    if (!_isShowFaceDetectPointBool) {
        [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
        return;
    }
    
    if (self.pointArrays.count==0) {
        [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
        return;
    }

    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        return;
    }
    
    [GPUImageContext setActiveShaderProgram:filterProgram];
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    
    [self setUniformsForProgramAtIndex:0];
    
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }
    
    glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [firstInputFramebuffer texture]);
    glUniform1i(filterInputTextureUniform, 2);
    
    const GLsizei pointCount = (GLsizei)self.pointArrays.count;
    GLfloat tempPoint[pointCount * 3];
    GLubyte indices[pointCount];
    
    for (int i = 0; i < self.pointArrays.count; i ++) {
        CGPoint pointer = [self.pointArrays[i] CGPointValue];
        
        GLfloat top = [self changeToGLPointT:pointer.y];
        GLfloat left = [self changeToGLPointL:pointer.x];
        
        tempPoint[i*3+0]=top;
        tempPoint[i*3+1]=left;
        tempPoint[i*3+2]=0.0f;
        indices[i]=i;
    }
    
    glVertexAttribPointer( 0, 3, GL_FLOAT, GL_TRUE, 0, tempPoint);
    glEnableVertexAttribArray(GL_VERTEX_ATTRIB_ARRAY_POINTER);
    glDrawElements(GL_POINTS, (GLsizei)sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
    
    [self informTargetsAboutNewFrameAtTime:frameTime];
    [firstInputFramebuffer unlock];
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }

}

- (GLfloat)changeToGLPointT:(CGFloat)x{
    GLfloat tempX = (x - self.videoFrameW/2) / (self.videoFrameW/2);
    return tempX;
}
- (GLfloat)changeToGLPointL:(CGFloat)y{
    GLfloat tempY = (self.videoFrameH/2 - (self.videoFrameH - y)) / (self.videoFrameH/2);
    return tempY;
}
- (GLfloat)changeToGLPointR:(CGFloat)y{
    GLfloat tempR = (self.videoFrameH/2 - y) / (self.videoFrameH/2);
    return tempR;
}
- (GLfloat)changeToGLPointB:(CGFloat)y{
    GLfloat tempB = (y - self.videoFrameW/2) / (self.videoFrameW/2);
    return tempB;
}


@end
