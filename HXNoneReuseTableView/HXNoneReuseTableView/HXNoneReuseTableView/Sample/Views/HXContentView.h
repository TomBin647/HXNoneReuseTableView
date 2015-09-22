//
//  HXSectionHeaderView.h
//  HXNoneReuseTableView
//
//  Created by MacBook on 15/9/22.
//  Copyright (c) 2015年 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXContentView : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void (^clickBlock)(HXContentView *view);

@end
