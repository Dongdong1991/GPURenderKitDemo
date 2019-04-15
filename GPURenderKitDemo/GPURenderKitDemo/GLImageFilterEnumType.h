//
//  GLImageFilterEnumType.h
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/13.
//  Copyright © 2019 刘海东. All rights reserved.
//

#ifndef GLImageFilterEnumType_h
#define GLImageFilterEnumType_h
#import <UIKit/UIKit.h>




typedef NS_ENUM(NSInteger, GLIMAGE_FILTER_TYPE)
{
    GLIMAGE_LUT,
    GL_IMAGE_ADDSTICKER,
    GLIMAGE_NUMBEROFFILTER,
};

static inline NSString *GetFilterNameWithType(GLIMAGE_FILTER_TYPE type)
{
    NSString *text;
    switch (type)
    {
        case GLIMAGE_LUT: text = @"Lookup Table （lut图）"; break;
        case GL_IMAGE_ADDSTICKER: text = @"贴纸,水印"; break;
        default: break;
    }
    
    return text;
}



typedef NS_ENUM(NSInteger, GL_INPUT_SOURCE_TYPE)
{
    GL_INPUT_SOURCE_CAMERA,
    GL_INPUT_SOURCE_IMAGE,
    GL_INPUT_SOURCE_MOVIE,
};


#endif /* GLImageFilterEnumType_h */
