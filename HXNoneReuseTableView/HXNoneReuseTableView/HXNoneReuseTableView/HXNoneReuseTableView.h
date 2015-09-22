//
//  HXNoneReuseTableView.h
//  HXTestWorkSpace
//
//  Created by MacBook on 15/9/16.
//  Copyright (c) 2015年 谢俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  无须重用的TabelView,对于一些无须重用cell的列表视图,适合使用该View,可以避免在didSelectRowAtIndexPath中写大量的 if else 来跳转,便于管理.也避免了UITableView复杂的使用步骤,例如注册cell重用,实现代理等.
 */

@interface HXNoneReuseTableView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;

/**
 *  向视图中添加元素,每个单元可以包含一个单元头视图'sectionHeaderView'和一个单元内容视图'cellView'
 *
 *  @param sectionHeaderView           单元头视图,可以为nil,为nil时,高度无效,高度将被置为0
 *  @param sectionHeight               单元头高度
 *  @param shouldSectionHeaderFloating 是否需要浮动,表现类似与UITableView的单元头
 *  @param cellView                    单元格,可以为nil,为nil时,高度无效,高度将被置为0
 *  @param cellHeight                  单元格高度
 */
- (void)addSectionHeaderView:(UIView *)sectionHeaderView
               sectionHeight:(CGFloat)sectionHeight
 shouldSectionHeaderFloating:(BOOL)shouldSectionHeaderFloating
                    cellView:(UIView *)cellView
                  cellHeight:(CGFloat)cellHeight;

/**
 *  向视图中添加不含单元头的单元格
 *
 *  @param cellView   单元格视图
 *  @param cellHeight 单元格高度
 */
- (void)addCellView:(UIView *)cellView
         cellHeight:(CGFloat)cellHeight;

@end

@interface HXNoneReuseTableView (ResetHeight)

- (BOOL)resetSectionHeaderHeight:(CGFloat)height atSection:(NSInteger)section animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition;

- (BOOL)resetCellHeight:(CGFloat)height atSection:(NSInteger)section animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition;

- (BOOL)resetHeightOfSectionHeaderView:(UIView *)sectionHeaderView withHeight:(CGFloat)height animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition;

- (BOOL)resetHeightOfCellView:(UIView *)cellView withHeight:(CGFloat)height animated:(BOOL)animated atScrollPosition:(UITableViewScrollPosition)scrollPosition;

@end