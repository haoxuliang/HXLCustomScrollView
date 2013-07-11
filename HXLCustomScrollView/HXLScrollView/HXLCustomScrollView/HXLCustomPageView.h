//
//  HXLCustomPageView.h
//  HXLScrollView
//
//  Created by 郝旭亮 on 13-7-8.
//  Copyright (c) 2013年 郝旭亮. All rights reserved.
//

typedef enum{
    HXLCustomScrollView_SelectType_None = 1000,
    HXLCustomScrollView_SelectType_CanSelected
}HXLCustomScrollView_SelectType;

@protocol HXLCustomPageViewDelegate;

@interface HXLCustomPageView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSObject<HXLCustomPageViewDelegate> *pageViewDelegate;

/**
 //便利构造器
 
 @property frame       为本视图设置边界以及位置
 @property views       组成可翻页的每一页的view
 @property selectType  设置视图是否可以点击
 */
- (id)initPageViewWithFrame:(CGRect)frame views:(NSArray *)views selectType:(HXLCustomScrollView_SelectType)selectType;

//设置自动翻页时间
- (void)setAutoFlipPageTime:(CGFloat)time;


//停止自动翻页
- (void)stopAutoFlipPage;

@end


@protocol HXLCustomPageViewDelegate <NSObject>

@optional
- (void)pageViewDidClickedWithPageNumber:(NSInteger)pageNumber;

@end