//
//  DouYinEffectTabView.h
//  WEOpenGLDemo
//
//  Created by 刘海东 on 2019/2/20.
//  Copyright © 2019 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLDouYinEffectViewController.h"
NS_ASSUME_NONNULL_BEGIN



@protocol DouYinEffectTabViewDelegate <NSObject>

- (void)didSelectEffectType:(DouYinEffectType)type;

@end




@interface DouYinEffectTabView : UIView

@property (nonatomic, weak) id<DouYinEffectTabViewDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
