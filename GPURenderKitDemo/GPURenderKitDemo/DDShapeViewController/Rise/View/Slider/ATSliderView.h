//
//  ATSliderView.h
//  Artist
//
//  Created by 刘海东 on 2018/6/30.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import "WeSliderView.h"

@interface ATSliderView : WeSliderView

@property (nonatomic, copy) NSString *topLabValue;

/** 默认显示 */
@property (nonatomic, assign) BOOL hideTopLab;


/** 自动显示 默认不显示 */
@property (nonatomic, assign)IBInspectable BOOL autoTopLab;
/** 滑块的宽度大小 */
@property (nonatomic, assign)IBInspectable  float thumbSize;


-(void)configBigFollowView;

-(void)configSmallFollowView;

/**滑动球的默认大小：26 */
-(void)configDefaultThumbWidth;

/**滑动球的默认大小：20 */
-(void)configSmallThumbWidth;





@end
