//
//  ViewController.m
//  OpenGLStretchDemo
//
//  Created by 刘海东 on 2018/5/30.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#define kSW [UIScreen mainScreen].bounds.size.width
#define kSH [UIScreen mainScreen].bounds.size.height
#define kSelfSize self.frame.size


#import "DDShapeViewController.h"
#import "DDGLShapeView.h"
#import "DDGLShapeSelView.h"
#import "DDGLShapeView.h"
#import <Photos/Photos.h>
#import "ATRiseViewController.h"
@interface DDShapeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) DDGLShapeViewType type;

@end

@implementation DDShapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = [NSArray arrayWithObjects:@"长图",@"宽图",@"方图",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 30);
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    //添加到视图
    [self.view addSubview:segment];
    
    
    NSArray *array2 = [NSArray arrayWithObjects:@"增高",@"瘦身",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment2 = [[UISegmentedControl alloc]initWithItems:array2];
    //设置frame
    segment2.frame = CGRectMake(10, 200, self.view.frame.size.width-20, 30);
    [segment2 addTarget:self action:@selector(changeFunc:) forControlEvents:UIControlEventValueChanged];
    segment2.selectedSegmentIndex = 0;
    //添加到视图
    [self.view addSubview:segment2];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 50);
    [btn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    
    
    self.image = [UIImage imageNamed:@"长图.JPG"];
    self.type = 0;
    
    
}

- (void)change:(UISegmentedControl *)seg
{
    NSString* filePath = nil;
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            filePath = @"长图.JPG";
        }
            break;
        case 1:
        {
            filePath = @"宽图.JPG";
        }
            break;
        case 2:
        {
            filePath = @"方图600*600.JPG";
        }
            break;
        case 3:
        {
            filePath = @"4032*3024.JPG";
        }
            break;
            
        default:
            filePath = @"长图.JPG";
            break;
    }
    self.image = [UIImage imageNamed:filePath];
}

- (void)changeFunc:(UISegmentedControl *)seg
{
    self.type = seg.selectedSegmentIndex;
}

- (void)jumpAction:(UIButton *)btn
{
    
    ATRiseViewController *vc = [[ATRiseViewController alloc]init];
    vc.type = self.type;
    vc.previewImage = self.image;
    [self presentViewController:vc animated:YES completion:nil];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

