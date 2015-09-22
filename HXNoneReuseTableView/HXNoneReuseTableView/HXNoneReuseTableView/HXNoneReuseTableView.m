//
//  HXNoneReuseTableView.m
//  HXTestWorkSpace
//
//  Created by MacBook on 15/9/16.
//  Copyright (c) 2015年 谢俊伟. All rights reserved.
//

#import "HXNoneReuseTableView.h"
#import <Masonry.h>

@interface HXNoneReuseTableView ()

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray *sectionHeaderViews;
@property (nonatomic, strong) NSMutableArray *cellViews;
@property (nonatomic, strong) NSMutableArray *sectionHeightConstraints;
@property (nonatomic, strong) NSMutableArray *cellHeightConstraints;

@property (nonatomic, strong) MASConstraint *scrollViewBottomConstraint;

@end

@implementation HXNoneReuseTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    UIScrollView *scrollView = [UIScrollView new];
    self.scrollView = scrollView;
    scrollView.clipsToBounds = YES;
    scrollView.alwaysBounceVertical = YES;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView.superview);
    }];
    
    UIView *contentView = [UIView new];
    self.contentView = contentView;
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.width.equalTo(contentView.superview);
        make.height.equalTo(contentView.superview).priority(1);
    }];

}

#pragma mark - Public Method

- (void)addSectionHeaderView:(UIView *)sectionHeaderView
               sectionHeight:(CGFloat)sectionHeight
 shouldSectionHeaderFloating:(BOOL)shouldSectionHeaderFloating
                    cellView:(UIView *)cellView
                  cellHeight:(CGFloat)cellHeight{
    
    UIView *contentView = self.contentView;
    
    UIView *lastCellView = [self.cellViews lastObject];

    sectionHeight = sectionHeight<0?0:sectionHeight;
    cellHeight = cellHeight<0?0:cellHeight;
    
    if (!sectionHeaderView) {
        sectionHeaderView = [UIView new];
        sectionHeight = 0;
    }
    
    if (!cellView) {
        cellView = [UIView new];
        cellHeight = 0;
    }
    
    [self.sectionHeaderViews addObject:sectionHeaderView];
    [self.cellViews addObject:cellView];
    
    //生成表头高度支撑视图,用于约束表头高度和更改表头高度
    UIView *sectionHeightLayoutGuide = [UIView new];
    [contentView addSubview:sectionHeightLayoutGuide];
    [sectionHeightLayoutGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastCellView?lastCellView.mas_bottom:contentView);
        make.left.equalTo(contentView);
        [self.sectionHeightConstraints addObject:make.height.equalTo(@(sectionHeight))];
        make.width.equalTo(@0);
    }];
    
    //cell内容视图
    [contentView addSubview:cellView];
    [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.lessThanOrEqualTo(sectionHeightLayoutGuide.mas_bottom);
        make.left.right.equalTo(contentView);
        [self.cellHeightConstraints addObject:make.height.equalTo(@(cellHeight))];
        make.top.equalTo(sectionHeightLayoutGuide.mas_bottom);
        [self resetScrollViewBottom:make];
    }];

    //sectionHeader视图
    [contentView addSubview:sectionHeaderView];
    [sectionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(sectionHeightLayoutGuide);
        make.left.right.equalTo(contentView);
        make.top.equalTo(sectionHeightLayoutGuide).priority(996);
        make.top.greaterThanOrEqualTo(lastCellView?lastCellView.mas_bottom:contentView.mas_top).priority(998);
        make.bottom.lessThanOrEqualTo(cellView).priority(999);
        if (shouldSectionHeaderFloating) {
            make.top.equalTo(self).priority(997);
        }
    }];
    
}

- (void)addCellView:(UIView *)cellView cellHeight:(CGFloat)cellHeight{
    [self addSectionHeaderView:nil sectionHeight:0 shouldSectionHeaderFloating:NO cellView:cellView cellHeight:cellHeight];
}

#pragma mark - Private Method

- (void)resetScrollViewBottom:(MASConstraintMaker *)make{
    if (self.scrollViewBottomConstraint) {
        [self.scrollViewBottomConstraint uninstall];
    }
    self.scrollViewBottomConstraint = make.bottom.equalTo(self.contentView);
}

#pragma mark - Lazy Property

- (NSMutableArray *)sectionHeaderViews{
    if (!_sectionHeaderViews) {
        NSMutableArray *sectionHeaderViews = [NSMutableArray new];
        _sectionHeaderViews = sectionHeaderViews;
    }
    return _sectionHeaderViews;
}

- (NSMutableArray *)cellViews{
    if (!_cellViews) {
        NSMutableArray *cellViews = [NSMutableArray new];
        _cellViews = cellViews;
    }
    return _cellViews;
}

- (NSMutableArray *)sectionHeightConstraints{
    if (!_sectionHeightConstraints) {
        NSMutableArray *sectionHeightConstraints = [NSMutableArray new];
        _sectionHeightConstraints = sectionHeightConstraints;
    }
    return _sectionHeightConstraints;
}

- (NSMutableArray *)cellHeightConstraints{
    if (!_cellHeightConstraints) {
        NSMutableArray *cellHeightConstraints = [NSMutableArray new];
        _cellHeightConstraints = cellHeightConstraints;
    }
    return _cellHeightConstraints;
}

#pragma mark - Debug

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end

@implementation HXNoneReuseTableView (ResetHeight)

- (BOOL)resetHeightOfSectionHeaderView:(UIView *)sectionHeaderView withHeight:(CGFloat)height animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition{
    NSInteger index = [self.sectionHeaderViews indexOfObject:sectionHeaderView];
    if (index == NSNotFound) {
        //NSLog(@"sectionHeaderView未找到");
        return NO;
    }
    return [self resetSectionHeaderHeight:height atSection:index animated:animated atScrollPosition:scrollPosition];
}

- (BOOL)resetHeightOfCellView:(UIView *)cellView withHeight:(CGFloat)height animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition{
    NSInteger index = [self.cellViews indexOfObject:cellView];
    if (index == NSNotFound) {
        //NSLog(@"cellView未找到");
        return NO;
    }
    return [self resetCellHeight:height atSection:index animated:animated atScrollPosition:scrollPosition];
}

- (BOOL)resetSectionHeaderHeight:(CGFloat)height atSection:(NSInteger)section animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition{
    
    if (section < 0 || section > self.sectionHeightConstraints.count) {
        return NO;
    }
    
    id obj = self.sectionHeightConstraints[section];
    if ([obj isKindOfClass:[MASConstraint class]]) {
        MASConstraint *heightConstraint = (MASConstraint *)obj;
        heightConstraint.equalTo(@(height));
        if (animated) {
            [UIView animateWithDuration:0.2 animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                ;
            }];
        }
        return YES;
    }
    return NO;
}

- (BOOL)resetCellHeight:(CGFloat)height atSection:(NSInteger)section animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition{
    if (section < 0 || section > self.cellHeightConstraints.count) {
        return NO;
    }
    id obj = self.cellHeightConstraints[section];
    if ([obj isKindOfClass:[MASConstraint class]]) {
        MASConstraint *heightConstraint = (MASConstraint *)obj;
        
        UIView *sectionView = self.sectionHeaderViews[section];
        UIView *cellView = self.cellViews[section];
        //视图高度
        CGFloat scrollViewHeight = self.scrollView.frame.size.height;
        //内容高度
        CGFloat contentHeight = self.scrollView.contentSize.height;
        //表头坐标
        CGRect sectionFrame = sectionView.frame;
        //表头高度
        CGFloat sectionHeight = sectionFrame.size.height;
        //原始Cell坐标
        CGRect cellFrame = cellView.frame;
        //原始cell高度
        CGFloat cellHeight = cellFrame.size.height;
        //原Cell的y点
        CGFloat Y = cellFrame.origin.y;
        //原Cell应在Y点(需要减去表头高度)
        CGFloat shouldY = Y - sectionHeight;
        //新内容长度
        CGFloat newContentHeight = contentHeight - cellHeight + height;
        //新Cell距离底部距离
        CGFloat newCellToBottom = newContentHeight - shouldY;
        //新偏移
        CGPoint newOffset = self.scrollView.contentOffset;
        
        switch (scrollPosition) {
            case UITableViewScrollPositionMiddle:
            case UITableViewScrollPositionNone: {
                //内容偏移
                CGFloat contentViewOffsetY = self.scrollView.contentOffset.y;
                if (shouldY < contentViewOffsetY) {
                    newOffset = CGPointMake(0, shouldY);
                }
                break;
            }
            case UITableViewScrollPositionTop: {
                if (newCellToBottom > scrollViewHeight) {
                    newOffset = CGPointMake(0, shouldY);
                }
                else{
                    newOffset = CGPointMake(0, newContentHeight - scrollViewHeight);
                }
                break;
            }
            case UITableViewScrollPositionBottom: {
                //表头bottom
                CGFloat sectionBottom = Y + sectionHeight;
                if (sectionBottom > scrollViewHeight) {
                    newOffset = CGPointMake(0, Y - scrollViewHeight);
                }
                break;
            }
        }
        
        if (animated) {
            heightConstraint.equalTo(@(height));
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = newOffset;
                [self layoutIfNeeded];
            } completion:NULL];
        }
        else{
            heightConstraint.equalTo(@(height));
            self.scrollView.contentOffset = newOffset;
        }
        return YES;
    }
    return NO;
}

@end