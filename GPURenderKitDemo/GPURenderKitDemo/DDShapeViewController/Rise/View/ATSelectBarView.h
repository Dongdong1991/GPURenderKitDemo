//
//  ATSelectBarView.h
//  Artist
//
//  Created by huangjinwen on 2018/6/21.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import <UIKit/UIKit.h>

//传0是点了左边button  1是中间button   2是右边button
typedef void(^SelectBlock)(NSInteger index);

@interface ATSelectBarView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) SelectBlock selectBlock;
//是否显示中间帮助button
@property (nonatomic, assign) BOOL hideHelpButton;

@end
