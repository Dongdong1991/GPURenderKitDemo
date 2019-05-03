//
//  ATRiseMenuView.h
//  Artist
//
//  Created by 刘海东 on 2018/6/21.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ATRiseMenuViewActionType) {
    
    /** 关闭 */
    ATRiseMenuViewActionType_Close = 0,
    /** course教程 */
    ATRiseMenuViewActionType_Course,
    /** 确认 */
    ATRiseMenuViewActionType_Enter,
    
};

@interface ATRiseMenuView : UIView


@property (nonatomic, copy) void (^valueDidChangeHandler)(float value);
@property (nonatomic, copy) void (^touchBeginHandler)(float value);
@property (nonatomic, copy) void (^touchEndHandler)(float value);

/** 点击事件 */
@property (nonatomic, copy) void (^clickActionHandler)(ATRiseMenuViewActionType type);

- (void)hideHelpButton:(BOOL)state;

- (float)getValue;

- (void)setValue:(float)value;

- (void)setTitle:(NSString *)tit;

- (void)minmimValue:(float)value;
- (void)maxmimValue:(float)value;


@end
