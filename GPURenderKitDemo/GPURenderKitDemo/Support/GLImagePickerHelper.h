//
//  GLImagePickerHelper.h
//  WeGPURender
//
//  Created by LHD on 2018/2/3.
//  Copyright © 2018年 LHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GLImagePickerHelper : NSObject

+ (void)showInController:(UIViewController *)controller completion:(void (^)(UIImage *image, UIImage *thumbImage))completion;

@end
