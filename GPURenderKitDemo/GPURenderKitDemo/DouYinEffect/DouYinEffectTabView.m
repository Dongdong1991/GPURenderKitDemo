//
//  DouYinEffectTabView.m
//  WEOpenGLDemo
//
//  Created by 刘海东 on 2019/2/20.
//  Copyright © 2019 Leo. All rights reserved.
//

#import "DouYinEffectTabView.h"

@interface DouYinEffectTabView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) NSMutableArray *tabViewData;

@end


static const NSString *kEffectName = @"effectName";
static const NSString *kEffectType = @"effectType";


@implementation DouYinEffectTabView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tabView];
    }
    return self;
}

- (UITableView *)tabView
{
    if (!_tabView) {
        [self configTableViewData];
        _tabView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tabView];
    }
    return _tabView;
}

- (void)configTableViewData
{
    
    self.tabViewData = [NSMutableArray array];
    NSDictionary *dic1 = [self createDicEffectName:@"三屏带滤镜" effectType:DouYinEffectType_GLImageThreePartition];
    NSDictionary *dic2 = [self createDicEffectName:@"四屏" effectType:DouYinEffectType_GLImageFourPointsMirrorFilter];
    NSDictionary *dic3 = [self createDicEffectName:@"电流" effectType:DouYinEffectType_GLImageGlitchEffectLineFilter];
    NSDictionary *dic4 = [self createDicEffectName:@"格子故障" effectType:DouYinEffectType_GLImageGlitchEffectGridFilter];
    NSDictionary *dic5 = [self createDicEffectName:@"灵魂出窍" effectType:DouYinEffectType_GLImageSoulOutFilter];

    [self.tabViewData addObject:dic1];
    [self.tabViewData addObject:dic2];
    [self.tabViewData addObject:dic3];
    [self.tabViewData addObject:dic4];
    [self.tabViewData addObject:dic5];


}

- (NSDictionary *)createDicEffectName:(NSString *)effectName effectType:(DouYinEffectType)effectType
{
    return @{kEffectName:effectName,
             kEffectType:@(effectType)
             };
}

#pragma mark ------------------------------------------------------ ttabDelete ------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabViewData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.tabViewData[indexPath.row];
    cell.textLabel.text = dic[kEffectName];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blueColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.tabViewData[indexPath.row];
    
    DouYinEffectType type = [dic[kEffectType] integerValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectEffectType:)]) {
        [self.delegate didSelectEffectType:type];
    }
    
    
}



@end
