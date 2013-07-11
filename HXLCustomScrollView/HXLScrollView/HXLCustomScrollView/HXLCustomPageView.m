//
//  HXLCustomPageView.m
//  HXLScrollView
//
//  Created by 郝旭亮 on 13-7-8.
//  Copyright (c) 2013年 郝旭亮. All rights reserved.
//

#import "HXLCustomPageView.h"

@interface HXLCustomPageView (){
    NSInteger _pageCount;
    NSInteger _currentPageNumber;
    NSInteger _autoFlipTime;
    CGFloat _move_x;
    HXLCustomScrollView_SelectType _selectType;
    BOOL isTouchesBegin;
}
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, strong, readonly) NSArray *arrViews;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation HXLCustomPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 //便利构造器
 
 @property frame       为本视图设置边界以及位置
 @property views       组成可翻页的每一页的view
 @property selectType  设置视图是否可以点击
 */
- (id)initPageViewWithFrame:(CGRect)frame
                      views:(NSArray *)views
                 selectType:(HXLCustomScrollView_SelectType)selectType{
    self = [super initWithFrame:frame];
    if (self) {
        _selectType = selectType;
        _arrViews = views;
        _pageCount = views.count;
        _currentPageNumber = 0;
        _move_x = 0.0;
        _autoFlipTime = 3.0;
        self.userInteractionEnabled = YES;
        [self setMainView];
    }
    return self;
}

- (void)setMainView{
    UIView *viewBG = [[UIView alloc] initWithFrame:self.bounds];
    viewBG.backgroundColor = [UIColor blackColor];
    viewBG.alpha = 0.3;
    [self addSubview:viewBG];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    if (_pageCount > 1) {
        [_scrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        _move_x = self.frame.size.width;
    }else{
        [_scrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    }
    
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 20, self.frame.size.width - 20, 20)];
    [_pageControl setNumberOfPages: _pageCount];
    [_pageControl addTarget:self action:@selector(pageNumberChanged:) forControlEvents:UIControlEventValueChanged];
    [_pageControl setCurrentPage:_currentPageNumber];
    [self addSubview:_pageControl];
    
    if (_pageCount > 1) {
        [self reSetScrollViewOffSet];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    [self startAutoFlipPage];
}

//设置自动翻页时间
- (void)setAutoFlipPageTime:(CGFloat)time{
    _autoFlipTime = time;
}

//开始自动翻页
- (void)startAutoFlipPage{
    if (_pageCount > 1) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollViewAutoFlipPage) userInfo:nil repeats:YES];
    }
}

//停止自动翻页
- (void)stopAutoFlipPage{
    [_timer invalidate];
    _timer = nil;
}


- (void)reSetScrollViewOffSet{    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat left = 0;
    for (NSInteger i = _currentPageNumber - 1 ; i < _currentPageNumber + 2; i++) {
        NSInteger index = i;
        if (index < 0) {
            index = _pageCount - 1;
        }
        
        if (index == _pageCount) {
            index = 0;
        }
        
        UIView *view = [_arrViews objectAtIndex:index];
        [view setFrame:CGRectMake(left, 0, self.frame.size.width, self.frame.size.height)];
        [_scrollView addSubview:view];
        left += self.frame.size.width;
    }
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
}

- (void)scrollViewAutoFlipPage{
    [_scrollView setContentOffset: CGPointMake(self.frame.size.width * 2, 0.0f) animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:_scrollView afterDelay:0.5];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ( scrollView.contentOffset.x != _move_x && (scrollView.contentOffset.x == self.frame.size.width*2 || scrollView.contentOffset.x == 0)) {
        if (scrollView.contentOffset.x == 0) {
            _currentPageNumber--;
        }else{
            _currentPageNumber++;
        }
        
        if (_currentPageNumber == _pageCount) {
            _currentPageNumber = 0;
        }
        
        if (_currentPageNumber == -1) {
            _currentPageNumber = _pageCount -1;
        }
        
        [_pageControl setCurrentPage:_currentPageNumber];
        
        
        [self reSetScrollViewOffSet];
    }
}

- (void)pageNumberChanged:(UIPageControl *)pageControl{
    if (pageControl.currentPage > _currentPageNumber) {
        [_scrollView setContentOffset: CGPointMake(self.frame.size.width * 2, 0.0f) animated:YES];
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:_scrollView afterDelay:0.5];
    }else if (pageControl.currentPage < _currentPageNumber){
        [_scrollView setContentOffset: CGPointMake(0.0f, 0.0f) animated:YES];
        [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:_scrollView afterDelay:0.5];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tapGesture{
    if (_selectType != HXLCustomScrollView_SelectType_CanSelected) {
        return;
    }
    
    if (_pageViewDelegate && [_pageViewDelegate respondsToSelector:@selector(pageViewDidClickedWithPageNumber:)]) {
        [_pageViewDelegate pageViewDidClickedWithPageNumber:_currentPageNumber];
    }
}


@end
