//
//  UIView+Xib.h
//  MLProject
//
//  Created by 妙龙赖 on 15/11/22.
//  Copyright © 2015年 妙龙赖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Xib)
@property (nonatomic, strong, readonly) id containerView;
/**
 *  生成与自身类同名的xibView,且约束与自己相同大小
 同时将自己设置为FileOwner

 */
- (void)setupSelfNameXibOnSelf;
- (void)setupSelfNameXibOnSelfWithSerialNumber:(NSInteger)number;
- (instancetype)loadSelfXibWithFileOwner:(id)fileOwner;
- (instancetype)loadSelfXibWithFileOwner:(id)fileOwner serialNumber:(NSInteger)number;

- (void)setupXibWithName:(NSString *)name;
- (instancetype)loadXibWithName:(NSString *)name;
- (instancetype)loadXibWithName:(NSString *)name serialNumber:(NSInteger)number;

- (instancetype)loadXibWithName:(NSString *)name  FileOwner:(id)fileOwner serialNumber:(NSInteger)number;

@end
