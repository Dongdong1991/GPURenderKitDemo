//
//  BaseViewController.m
//  GPURenderKitDemo
//
//  Created by 刘海东 on 2019/2/23.
//  Copyright © 2019 刘海东. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)dealloc
{
    NSLog(@"dealloc---->%@",[self class]);
}
@end
