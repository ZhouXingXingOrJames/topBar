//
//  VideoListVide.m
//  TopTabDemo
//
//  Created by Mr.Zhang on 2017/3/9.
//  Copyright © 2017年 lei.Zhang. All rights reserved.
//

#import "VideoListView.h"
@interface VideoListView()
@property (nonatomic,strong) UITableView *listView;
@end
@implementation VideoListView
- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        [self addSubview:_listView];
    }
    return _listView;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
