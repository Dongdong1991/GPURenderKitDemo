//
//  FaceSliderView.h
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/16.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FaceSliderViewValueChangeBlock)(float value);

@interface FaceSliderView : UIView

@property (nonatomic, assign) float minimumValue;

@property (nonatomic, assign) float maximumValue;

@property (nonatomic, copy) FaceSliderViewValueChangeBlock valueChangeBlock;

@property (nonatomic, strong) NSString *title;


@end

NS_ASSUME_NONNULL_END
