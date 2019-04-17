//
//  GLImageZoomFilter.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/16.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "GLImageZoomFilter.h"
#define kMaxResetCount 20
#define kMinResetCount 15


NSString *const kGLImageZoomFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 
 uniform float bigValue;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     
     highp vec2 uv = textureCoordinate;
     
     vec4 originColor = texture2D(inputImageTexture, uv);
     
     
     float w = bigValue ;
     float minOffset = (1.0 - w) / 2.0;
     float maxOffset = 1.0 - minOffset;
     
     //中心点放大计算方式
     if ((uv.x >= minOffset && uv.x <= maxOffset) && (uv.y >= minOffset && uv.y <= maxOffset))
     {
         uv = vec2 (uv - vec2(minOffset)) / w;
         originColor = texture2D(inputImageTexture, uv);
     }
     
     
     gl_FragColor = originColor;
     
 }
 );

@interface GLImageZoomFilter ()

@property (nonatomic, assign) NSInteger currentFrameCount;

@property (nonatomic, assign) NSInteger resetCount;

@end


@implementation GLImageZoomFilter


- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGLImageZoomFragmentShaderString];
    if (self) {
        
        self.currentFrameCount = 0;
        self.resetCount = 0;
        
        
    }
    return self;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex{
    
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
    
    self.currentFrameCount = self.currentFrameCount + 1;
    
    
    if (self.currentFrameCount == kMaxResetCount) {
        self.currentFrameCount =0;
    }
    
    if (self.currentFrameCount>=kMinResetCount) {
        self.resetCount = self.resetCount + 12;
    }else{
        self.resetCount = self.resetCount - 12;
        
        //不让缩到最小
        if (self.resetCount<0) {
            self.resetCount = 0;
        }
    }

    //这里做放大的计算
    NSInteger value = self.resetCount;
    [self updateForegroundTexture:1.0+(value/100.0)];
}


- (void)updateForegroundTexture:(float)bigValue{
    [self setFloat:bigValue forUniformName:@"bigValue"];
}



@end
