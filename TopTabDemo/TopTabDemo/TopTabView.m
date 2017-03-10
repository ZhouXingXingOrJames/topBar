//
//  TopTabView.m
//  TopTabDemo
//
//  Created by Mr.Zhang on 2017/3/3.
//  Copyright © 2017年 lei.Zhang. All rights reserved.
//

#import "TopTabView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define LABEL_TO_GAP 30
#define FIRST_LABEL_TO_GAP 15
@interface TopTabView()<UIScrollViewDelegate>{
    UILabel *_lastLabel;
}
@property (nonatomic,strong) UIScrollView *topScrollView;
@property (nonatomic,strong) UIScrollView *bottomScrollView;
@property (nonatomic,strong) NSArray *viewList;
@property (nonatomic,strong) NSArray *titleList;

@end
@implementation TopTabView
- (UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.delegate = self;
        _topScrollView.tag = 100;
        [self addSubview:_topScrollView];
    }
    return _topScrollView;
}
- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.bounces = NO;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.viewList.count, SCREEN_HEIGHT-64);
        _bottomScrollView.delegate = self;
        _bottomScrollView.tag = 200;
        [self addSubview:_bottomScrollView];
    }
    return _bottomScrollView;
}
- (NSArray *)viewList{
    if (!_viewList) {
        _viewList = [NSArray array];
        _viewList = @[@"",@"",@"",@"",@"",@""];
    }
    return _viewList;
}
- (NSArray *)titleList{
    if (!_titleList) {
        _titleList = [NSArray array];
        _titleList = @[@"搞笑",@"段子",@"视频",@"趣图",@"精选",@"撸段"];
    }
    return _titleList;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubLayout];
    }
    return self;
}
- (CGSize )_calTextSize:(UILabel *)label{//计算文本size
    NSDictionary *attrs=@{NSFontAttributeName:label.font};
    CGSize size=[label.text boundingRectWithSize:CGSizeMake(80, 44) options:NSStringDrawingTruncatesLastVisibleLine |
              NSStringDrawingUsesLineFragmentOrigin |
              NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    return size;
}
-(void)_addSubLayout{
    CGFloat sumWidth = 0.f;
    for (int i = 0; i < self.titleList.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.titleList[i];
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        titleLabel.frame = CGRectMake(FIRST_LABEL_TO_GAP+i*([self _calTextSize:titleLabel].width + LABEL_TO_GAP), 0, [self _calTextSize:titleLabel].width, 44);
        titleLabel.tag = 1000+i;
        if (i == 0) {
            titleLabel.textColor = [UIColor orangeColor];
            _lastLabel = titleLabel;
        }
        titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTabAction:)];
        [titleLabel addGestureRecognizer:tap];
        [self.topScrollView addSubview:titleLabel];
        sumWidth+=([self _calTextSize:titleLabel].width + LABEL_TO_GAP);
    }
    self.topScrollView.contentSize = CGSizeMake(sumWidth, 44);
    for (int i = 0; i < self.viewList.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.bottomScrollView.bounds.size.height)];
        if (i == 0) {
            view.backgroundColor = [UIColor redColor];
        }else if (i == 1){
            view.backgroundColor = [UIColor orangeColor];
        }else if(i==2){
            view.backgroundColor = [UIColor purpleColor];
        }else if (i==3){
            view.backgroundColor = [UIColor blueColor];
        }else{
            view.backgroundColor = [UIColor brownColor];
        }
        [self.bottomScrollView addSubview:view];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.bottomScrollView) {
        
        NSInteger page = self.bottomScrollView.contentOffset.x / SCREEN_WIDTH;
        for (UILabel *label in self.topScrollView.subviews) {
            if (label.tag-1000==page && label!=_lastLabel) {
                label.textColor = [UIColor orangeColor];
                _lastLabel.textColor = [UIColor blackColor];
                _lastLabel = label;
                [self _calForPage:label];
            }
        }
        if (page==0) {
            [UIView animateWithDuration:.3 animations:^{
                self.topScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
        
        [self _judgeForLabelCenter:page];
    }
    
    
}
- (void)topTabAction:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    NSInteger page = label.tag-1000;
    if (label!=_lastLabel) {
        label.textColor = [UIColor orangeColor];
        _lastLabel.textColor = [UIColor blackColor];
        _lastLabel = label;
        self.bottomScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * page, 0);
        [self _calForPage:label];
        if(label.tag-1000==0){
            [UIView animateWithDuration:.3 animations:^{
                
                self.topScrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
    [self _judgeForLabelCenter:page];
}
- (void)_calForPage:(UILabel *)label{
    CGFloat offset = label.frame.origin.x+label.frame.size.width;
    if( offset > SCREEN_WIDTH){
        [UIView animateWithDuration:.3 animations:^{
            
            self.topScrollView.contentOffset = CGPointMake(self.topScrollView.contentOffset.x+label.frame.size.width, 0);
        }];
    }
}
- (void)_judgeForLabelCenter:(NSInteger)page{
    
    // 让对应的顶部标题居中显示
    UILabel *label = self.topScrollView.subviews[page];
    CGPoint titleOffsetX = self.topScrollView.contentOffset;
    titleOffsetX.x = label.center.x - SCREEN_WIDTH/2;
    // 左边偏移量边界
    if(titleOffsetX.x < 0) {
        titleOffsetX.x = 0;
    }
    
    CGFloat maxOffsetX = self.topScrollView.contentSize.width - SCREEN_WIDTH;
    // 右边偏移量边界
    if(titleOffsetX.x > maxOffsetX) {
        titleOffsetX.x = maxOffsetX;
    }
    [UIView animateWithDuration:.3 animations:^{
        
        // 修改偏移量
        self.topScrollView.contentOffset = titleOffsetX;
    }];

}
@end
