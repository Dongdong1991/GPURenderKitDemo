//
//  UIView+Xib.m
//  MLProject
//
//  Created by 妙龙赖 on 15/11/22.
//  Copyright © 2015年 妙龙赖. All rights reserved.
//

#import "UIView+Xib.h"
#import <objc/runtime.h>

@implementation UIView (Xib)
- (void)setupSelfNameXibOnSelf
{
   
    [self setupSelfNameXibOnSelfWithSerialNumber:0];
}

- (void)setupSelfNameXibOnSelfWithSerialNumber:(NSInteger)number
{
    UIView *containerView = [self loadSelfXibWithFileOwner:self serialNumber:number];
    [self addSubview:containerView];
}
- (instancetype)loadSelfXibWithFileOwner:(id)fileOwner
{
    
   return [self loadSelfXibWithFileOwner:fileOwner serialNumber:0];
}

- (instancetype)loadSelfXibWithFileOwner:(id)fileOwner serialNumber:(NSInteger)number
{
    
    UIView *containerView = [self loadXibWithName:NSStringFromClass([self class]) FileOwner:self serialNumber:0];
    return containerView;
}


- (void)setupXibWithName:(NSString *)name
{
    UIView *contianerView = [self loadXibWithName:name];
    [self addSubview:contianerView];
  
}
- (instancetype)loadXibWithName:(NSString *)name
{
    return [self loadXibWithName:name serialNumber:0];
}
- (instancetype)loadXibWithName:(NSString *)name serialNumber:(NSInteger)number
{
    return [self loadXibWithName:name FileOwner:self serialNumber:number];
}
- (instancetype)loadXibWithName:(NSString *)name  FileOwner:(id)fileOwner serialNumber:(NSInteger)number
{
    UIView *containerView = [[NSBundle mainBundle] loadNibNamed:name owner:fileOwner options:nil][number];
    containerView.frame = self.bounds;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    objc_setAssociatedObject(fileOwner, @selector(containerView), containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return containerView;
}


#pragma mark - ========= Setter & Getter =========
- (id)containerView
{
    return objc_getAssociatedObject(self, @selector(containerView));
}
@end
