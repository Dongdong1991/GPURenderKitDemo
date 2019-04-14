//
//  UIImage+Utils.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-18.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIImage扩展类别
 */
@interface UIImage (Utils)

/**
 *  截图部分图片
 *
 *  @param rect 截取区域
 *
 *  @return 结果图片
 */
- (UIImage *)subImageAtRect:(CGRect)rect;

/**
 *  沿着一定弧度旋转
 *
 *  @param radians 旋转的弧度
 *
 *  @return 结果图片
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/**
 *  沿着一定的角度旋转
 *
 *  @param degrees 旋转的角度
 *
 *  @return 结果图片
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  等比例压缩图片
 *
 *  @param size 压缩到的大小
 *
 *  @return 结果图片
 */
- (UIImage *)imageScaledToSize:(CGSize)size;


/**
 *  合并图片
 *
 *  @param image2 <#image2 description#>
 *
 *  @return 合并后的image
 */
- (UIImage *)addImagetoImage:(UIImage *)image2;


/**
 *  图片对调
 *
 *  @param imageSource <#imageSource description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)imageMirror;


- (UIImage *)addImagetoImage:(UIImage *)image2 image1Frame:(CGRect)image1Frame image2Frame:(CGRect)image2Frame;

//view转image
- (UIImage *)getImageFromView:(UIView *)theView;


/**
 *  拍照后图片  调整位置
 *

 *  @return <#return value description#>
 */
- (UIImage *)fixTakePictureOrientation;

/**
 *  从视频中获取一张缩略图，
 *
    videoURL 本地路径；
    second 截图的时间 秒
 
 *  @return 一张截图
 
 示例：
 
 NSString *videoURL =[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
 UIImage *thumImg = [UIImage assetGetVideoThumImage:videoURL thumSecond:11];
 self.showImageView.image = thumImg;

 */

+ (UIImage *)assetGetVideoThumImage:(NSString *)videoURL thumSecond:(CGFloat)second;

/**
 *  UIColor 转 UIImage
 */

+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat)maxSize;

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
