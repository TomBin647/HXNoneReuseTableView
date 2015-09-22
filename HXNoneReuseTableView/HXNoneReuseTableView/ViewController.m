//
//  ViewController.m
//  HXNoneReuseTableView
//
//  Created by MacBook on 15/9/22.
//  Copyright (c) 2015年 MacBook. All rights reserved.
//

#import "ViewController.h"
#import "SampleViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)Sample:(id)sender {
    SampleViewController *vc = [SampleViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
