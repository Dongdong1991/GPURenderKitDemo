//
//  GLFilterInfoView.h
//  GLImageDemo
//
//  Created by LHD on 2018/3/14.
//  Copyright © 2018年 LHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLFilterInfoView : UIView

@property (nonatomic, assign) BOOL      selected;
@property (nonatomic, assign) float     degree;
@property (nonatomic, strong) NSString  *text;
@property (nonatomic, assign) NSString  *title;
@property (nonatomic, strong) UIImage   *backgroundImage;
@property (nonatomic,   copy) void (^selectedBlock)(GLFilterInfoView *filterInfoView, BOOL selected);

- (void)setSelected:(BOOL)selected;

@end
