//
//  ViewController.m
//  TopTabDemo
//
//  Created by Mr.Zhang on 2017/3/3.
//  Copyright © 2017年 lei.Zhang. All rights reserved.
//

#import "ViewController.h"
#import "TopTabView.h"
@interface ViewController ()
@property (nonatomic,strong) TopTabView *tabView;
@end

@implementation ViewController
- (TopTabView *)tabView{
    if (!_tabView) {
        _tabView = [[TopTabView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:_tabView];
    }
    return _tabView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabView.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
