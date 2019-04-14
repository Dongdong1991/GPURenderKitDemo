//
//  GLImagePickerHelper.m
//  WeGPURender
//
//  Created by LHD on 2018/2/3.
//  Copyright © 2018年 LHD. All rights reserved.
//

#import "GLImagePickerHelper.h"
#import <Photos/Photos.h>
#import "UIImage+Rotate.h"

@interface GLImagePickerHelper () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, copy) void (^completion)(UIImage *image, UIImage *thumbImage);

@end

@implementation GLImagePickerHelper

+ (id)sharedHelper
{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GLImagePickerHelper alloc] init];
    });
    
    return instance;
}

+ (void)showInController:(UIViewController *)controller completion:(void (^)(UIImage *image, UIImage *thumbImage))completion
{
    [[[self class] sharedHelper] showInController:controller completion:completion];
}

- (void)showInController:(UIViewController *)controller completion:(void (^)(UIImage *image, UIImage *thumbImage))completion
{
    self.completion = completion;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [controller presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 设置图片
    UIImage *image= info[UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
    UIImage *thumbImage = image;
    
    if (image.size.width > 1080)
    {
        float radio = image.size.height / image.size.width;
        thumbImage = [self imageByScalingAndCroppingForSize:CGSizeMake(1080, 1080 * radio) withSourceImage:image];
    }
    
    if (self.completion)
    {
        self.completion(image, thumbImage);
    }
    
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight);
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth);
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
