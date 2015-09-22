//
//  HXSectionHeaderView.m
//  HXNoneReuseTableView
//
//  Created by MacBook on 15/9/22.
//  Copyright (c) 2015年 MacBook. All rights reserved.
//

#import "HXContentView.h"
#import <Masonry.h>
#import "UIColor+HXRandomColor.h"

@interface HXContentView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HXContentView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        [self setupViews];
        self.title = title;
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = [UIColor randomColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:10];
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
    }];
    
    UIButton *button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)buttonDidClicked{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Debug

- (void)dealloc{
    NSLog(@"%s",__func__);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
