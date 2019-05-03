//
//  GLFilterInfoView.m
//  GLImageDemo
//
//  Created by LEO on 2018/3/14.
//  Copyright © 2018年 LEO. All rights reserved.
//

#import "GLFilterInfoView.h"

@interface GLFilterInfoView ()

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIView        *backgroundView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *degreeLabel;

@end

@implementation GLFilterInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.backgroundView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = RGB(133, 136, 150);
    self.titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
    
    self.degreeLabel = [[UILabel alloc] init];
    self.degreeLabel.font = [UIFont systemFontOfSize:40];
    self.degreeLabel.textAlignment = NSTextAlignmentCenter;
    self.degreeLabel.textColor = [UIColor whiteColor];
    self.degreeLabel.minimumScaleFactor = 0.8;
    self.degreeLabel.adjustsFontSizeToFitWidth = YES;
    self.degreeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.degreeLabel];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel(24)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_degreeLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_degreeLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel][_degreeLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_titleLabel, _degreeLabel)]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureActionHandler:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGestureActionHandler:(UITapGestureRecognizer *)gesture
{
    self.selected = YES;
    
    if (self.selectedBlock)
    {
        self.selectedBlock(self, self.selected);
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.degreeLabel.text = text;
}

- (void)setDegree:(float)degree
{
    _degree = degree;
    self.degreeLabel.text = [NSString stringWithFormat:@"%.2f", degree];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected)
    {
        self.backgroundView.backgroundColor = RGBA(48, 109, 215, 0.2);
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.degreeLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = RGB(133, 136, 150);
        self.titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.degreeLabel.textColor = RGB(133, 136, 150);
    }
}

@end
