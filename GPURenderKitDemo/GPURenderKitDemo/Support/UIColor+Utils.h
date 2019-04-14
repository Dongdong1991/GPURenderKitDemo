//
//  UIColor+Utils.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-19.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  颜色扩展类别
 */
@interface UIColor (Utils)

/**
 *  通过十六进制获取颜色
 *
 *  @param hexColor 十六进制
 *
 *  @return 颜色
 */
+ (UIColor *)colorForHex:(NSString *)hexColor;

+ (UIColor *)colorForHex:(NSString *)hexColor alpha:(float)alpha;

@end
