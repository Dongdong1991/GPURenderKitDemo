//
//  ATSelectBarView.m
//  Artist
//
//  Created by huangjinwen on 2018/6/21.
//  Copyright © 2018年 wecut. All rights reserved.
//

#import "ATSelectBarView.h"
#import "UIView+Xib.h"

@interface ATSelectBarView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@end


@implementation ATSelectBarView


- (void)awakeFromNib
{
    [super awakeFromNib];
    //加载同名xib并添加到self
    [self setupSelfNameXibOnSelf];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] firstObject];
        self.frame = frame;
        view.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:view];
        
    }
    return self;
}


#pragma mark - setter

-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


#pragma mark - button event

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.selectBlock) {
        if (self.cancelButton == sender) {
            self.selectBlock(0);
        } else if (self.okButton == sender) {
            self.selectBlock(2);
        } else if (self.helpButton == sender) {
            self.selectBlock(1);
        }
    }
}

-(void)setHideHelpButton:(BOOL)hideHelpButton {
    _hideHelpButton = hideHelpButton;
    self.helpButton.hidden = hideHelpButton;
}






@end
