//
//  GLImageFaceChangeFilter.h
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/16.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "GPUImageFilter.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLImageFaceChangeFilter : GPUImageFilter
{
    GLint faceArrayUniform,iResolutionUniform,haveFaceUniform;
}

/** 是否检测到人脸 */
@property (nonatomic, assign) BOOL isHaveFace;
/** 瘦脸调节【-1.0 - 1.0】 */
@property (nonatomic, assign) float thinFaceParam;
/** 眼睛调节【-1.0 - 1.0】*/
@property (nonatomic, assign) float eyeParam;

- (void)setFacePointsArray:(NSArray *)pointArrays;


@end

NS_ASSUME_NONNULL_END
