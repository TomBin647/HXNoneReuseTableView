//
//  SampleViewController.m
//  HXNoneReuseTableView
//
//  Created by MacBook on 15/9/22.
//  Copyright (c) 2015年 MacBook. All rights reserved.
//

#import "SampleViewController.h"
#import "HXNoneReuseTableView.h"
#import "HXContentView.h"

#import <Masonry.h>

@interface SampleViewController ()

@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupViews];
}

- (void)setupViews{
    
    HXNoneReuseTableView *tableView = [HXNoneReuseTableView new];
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(16, 16, 16, 16));
    }];

    NSArray *shouldFloatingTypes = @[ @YES ,@NO];
    NSArray *shouldAnimetedTypes = @[ @YES ,@NO];
    NSArray *scrollPositions = @[ @(UITableViewScrollPositionNone),@(UITableViewScrollPositionTop),@(UITableViewScrollPositionBottom)];
    
    NSInteger sectionCount = 0;
    
    for (NSNumber *scrollType in scrollPositions) {
        UITableViewScrollPosition scrolltype = scrollType.integerValue;
        for (NSNumber *shouldFloating in shouldFloatingTypes) {
            BOOL shouldfloating = shouldFloating.boolValue;
            for (NSNumber *shouldAnimeted in shouldAnimetedTypes) {
                BOOL shouldanimated = shouldAnimeted.boolValue;
                
                NSString *scrollTypeDesc;//滚动类型描述
                
                switch (scrolltype) {
                    case UITableViewScrollPositionNone: {
                        scrollTypeDesc = @"单元头不动";
                        break;
                    }
                    case UITableViewScrollPositionTop: {
                        scrollTypeDesc = @"单元头滚动到顶";
                        break;
                    }
                    case UITableViewScrollPositionMiddle: {
                        scrollTypeDesc = @"单元头不动";
                        break;
                    }
                    case UITableViewScrollPositionBottom: {
                        scrollTypeDesc = @"单元头滚动到底";
                        break;
                    }
                }
                
                NSString *shouldFloatDesc = shouldfloating?@"是":@"不";
                NSString *shouldAnimatedeDesc = shouldanimated?@"有":@"无";
                
                NSString *sectionHeaderTitle = [NSString stringWithFormat:@"单元头%@. %@浮动 %@动画",@(sectionCount),shouldFloatDesc,shouldAnimatedeDesc];
                NSString *cellTitle = [NSString stringWithFormat:@"内容%@.高度变化时:%@ %@浮动 %@动画",@(sectionCount),scrollTypeDesc,shouldFloatDesc,shouldAnimatedeDesc];
                
                HXContentView *sectionHeaderView = [[HXContentView alloc] initWithTitle:sectionHeaderTitle];
                HXContentView *cellView = [[HXContentView alloc] initWithTitle:cellTitle];
                
                __weak __typeof(tableView)weakTableView = tableView;
                
                [sectionHeaderView setClickBlock:^(HXContentView *view) {
                    int height = arc4random() % 40 + 10;
                    __strong __typeof(weakTableView)strongTableView = weakTableView;
                    /**
                     *  WARNING:循环引用注意
                     */
                    [strongTableView resetHeightOfSectionHeaderView:view withHeight:height animated:shouldanimated atScrollPosition:scrolltype];
                }];
                
                [cellView setClickBlock:^(HXContentView *view) {
                    int height = arc4random() % 400 + 100;
                    __strong __typeof(weakTableView)strongTableView = weakTableView;
                    [strongTableView resetHeightOfCellView:view withHeight:height animated:shouldanimated atScrollPosition:scrolltype];
                }];
                
                sectionCount ++;
                
                [tableView addSectionHeaderView:sectionHeaderView sectionHeight:44 shouldSectionHeaderFloating:shouldfloating cellView:cellView cellHeight:100];
            }
        }
    }
}

- (void)addText:(NSString *)text ToView:(UIView *)view{
    view.layer.borderWidth = 1;
    UILabel *textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    [view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Debug

- (void)dealloc{
    NSLog(@"%s",__func__);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
