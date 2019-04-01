//
//  MainViewController.m
//  DDFaceKitDemo
//
//  Created by 刘海东 on 2018/9/12.
//  Copyright © 2018年 刘海东. All rights reserved.
//

#import "MainViewController.h"
#import <objc/runtime.h>
typedef NS_ENUM(NSInteger,ActionType)
{
    /** 抖音效果 */
    ActionType_DouYinEffect,
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
        NSDictionary *dic6 = [self actionDic:@"抖音效果" type:ActionType_DouYinEffect viewcontrollerName:@"GLDouYinEffectViewController"];

        _dataSource = @[dic6];
        
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
    }
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:[self createClassName:dic[@"vcName"]] animated:YES];
    
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
