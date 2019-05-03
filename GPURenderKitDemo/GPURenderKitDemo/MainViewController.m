//
//  MainViewController.m
//  DDFaceKitDemo
//
//  Created by 刘海东 on 2018/9/12.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#import "MainViewController.h"
#import "BaseViewController.h"
#import <objc/runtime.h>
typedef NS_ENUM(NSInteger,ActionType)
{
    /** 抖音效果 */
    ActionType_DouYinEffect,
    /** GPUimage+背景音乐一步合成 */
    ActionType_GLImageMovieUse,
    /** GLImageFilter */
    ActionType_FilterList,
    /** Face */
    ActionType_Face_Fragment,
    /** videoEcode */
    ActionType_VideoEcode,
    /** 增高瘦身 */
    ActionType_Shape,
    /** 未实现 */
    ActionType_Empty,


};


@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tab;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tab];
    
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        NSDictionary *dic1 = [self actionDic:@"抖音效果" type:ActionType_DouYinEffect viewcontrollerName:@"GLDouYinEffectViewController"];
        NSDictionary *dic2 = [self actionDic:@"GPUiamge+混音保存" type:ActionType_GLImageMovieUse viewcontrollerName:@"GLImageMovieUseViewController"];
        NSDictionary *dic3 = [self actionDic:@"FilterShow" type:ActionType_FilterList viewcontrollerName:@"GLImageFilterListViewController"];
        NSDictionary *dic4 = [self actionDic:@"美颜,脸，鼻，眼调节（基于FragmentShader调节--已实现）" type:ActionType_Face_Fragment viewcontrollerName:@"FaceViewController"];
        NSDictionary *dic5 = [self actionDic:@"美颜,瘦脸,大眼（基于VertexShader调节--未实现）" type:ActionType_Empty viewcontrollerName:@""];
        NSDictionary *dic6 = [self actionDic:@"增高，瘦身效果调节" type:ActionType_Shape viewcontrollerName:@"DDShapeViewController"];
        
        _dataSource = @[dic1,dic2,dic3,dic4,dic5,dic6];
        
    }
    return _dataSource;
}

- (NSDictionary *)actionDic:(NSString *)title type:(ActionType)type viewcontrollerName:(NSString *)vcName
{
    return @{@"title":title,
             @"type":@(type),
             @"vcName":vcName
             };
}

- (UITableView *)tab
{
    if (!_tab) {
        
        _tab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tab.delegate = self;
        _tab.dataSource = self;
        [self.view addSubview:_tab];
        [_tab reloadData];
    }
    return _tab;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    ActionType type = [dic[@"type"] integerValue];
    if (type == ActionType_Empty) {
        NSLog(@"未实现---");
        return;
    }
    
    BaseViewController *vc = (BaseViewController *)[self createClassName:dic[@"vcName"]];
    vc.title = dic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)createClassName:(NSString *)classString
{
    const char *className = [classString cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
    }
    id instance = [[newClass alloc] init];
    return (UIViewController *)instance;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
