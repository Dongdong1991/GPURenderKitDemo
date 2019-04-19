//
//  GLImageBlurSnapViewFilter.m
//  GPURenderKit
//
//  Created by 刘海东 on 2019/4/19.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "GLImageBlurSnapViewFilter.h"

NSString *const kGLImageBlurSnapViewFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying vec2 textureCoordinate;
 uniform float blurOffsetY;
 uniform float blurTextureScal;

 
 uniform sampler2D inputImageTexture; //视频
 uniform sampler2D inputImageTexture2; //模糊视频

 
 void main()
 {
     
     highp vec2 uv = textureCoordinate;
     
     vec4 outPutcolor = vec4(0.0,0.0,0.0,1.0);
     
     if (uv.y >= blurOffsetY && uv.y <= 1.0 - blurOffsetY) {
         //原视频
         outPutcolor = texture2D(inputImageTexture, uv);
         
     } else {
         
         //中心点偏移到中心点
         vec2 center = vec2(0.5, 0.5);
         uv = uv -  center;
         //纹理放大缩小
         uv = uv / blurTextureScal;
         uv = uv + center;
         outPutcolor = texture2D(inputImageTexture2, uv);
     }     
     
     gl_FragColor = outPutcolor;
 }
 );



@interface GLImageBlurSnapViewFilter ()

@end

@implementation GLImageBlurSnapViewFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGLImageBlurSnapViewFragmentShaderString];
    if (self) {
        
        
        blurOffsetYUniform = [filterProgram uniformIndex:@"blurOffsetY"];
        blurTextureScalUniform = [filterProgram uniformIndex:@"blurTextureScal"];

        self.blurOffsetY = 0.25;
        self.blurTextureScal = 2.0;

    }
    return self;
}

- (void)setBlurOffsetY:(float)blurOffsetY{
    
    _blurOffsetY = blurOffsetY;
    if (blurOffsetY<0.0 || blurOffsetY>0.5) {
        _blurOffsetY = 0.25;
    }
    [self setFloat:_blurOffsetY forUniform:blurOffsetYUniform program:filterProgram];
}

- (void)setBlurTextureScal:(float)blurTextureScal{
    
    _blurTextureScal = blurTextureScal;
    if (blurTextureScal<1.0 || blurTextureScal>5.0) {
        _blurTextureScal = 2.0;
    }
    [self setFloat:_blurTextureScal forUniform:blurTextureScalUniform program:filterProgram];
}


@end
