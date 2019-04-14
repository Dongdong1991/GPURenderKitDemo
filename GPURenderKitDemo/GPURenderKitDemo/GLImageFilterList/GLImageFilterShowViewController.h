//
//  GLImageFilterShowViewController.h
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/4/13.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLImageFilterShowViewController : BaseViewController

- (id)initWithFilterType:(GLIMAGE_FILTER_TYPE)filterType;

@property (nonatomic, assign) GL_INPUT_SOURCE_TYPE inputSourceType;

@end

NS_ASSUME_NONNULL_END
