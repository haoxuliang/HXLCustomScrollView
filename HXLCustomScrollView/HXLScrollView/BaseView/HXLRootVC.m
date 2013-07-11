//
//  HXLRootVC.m
//  HXLPredicateTest
//
//  Created by 郝旭亮 on 13-5-31.
//  Copyright (c) 2013年 郝旭亮. All rights reserved.
//

#import "HXLRootVC.h"
#import "HXLCustomPageView.h"


@interface HXLRootVC ()<HXLCustomPageViewDelegate>

@property (nonatomic, strong) HXLCustomPageView *pageView;

@end

@implementation HXLRootVC


#pragma mark - <------ Init ------>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置标题
    self.navigationItem.title = @"无限滚动";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - <------ Supper ------>
//初始化数据源
-(void)setDataForVC
{
    
}

//设置视图
-(void)setMainView
{
    CGFloat height = 130.0;
    CGFloat width = 300.0;
    NSMutableArray *arrViews = [[NSMutableArray alloc] initWithCapacity:4];
    NSArray *arrColor = [[NSArray alloc] initWithObjects:[UIColor lightGrayColor],[UIColor redColor],[UIColor blueColor],[UIColor orangeColor], nil];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        view.backgroundColor = [arrColor objectAtIndex:i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"View %d",i];
        label.font = [UIFont boldSystemFontOfSize:25];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        [arrViews addObject:view];
    }
    _pageView = [[HXLCustomPageView alloc] initPageViewWithFrame:CGRectMake(10, 10, width, height) views:arrViews selectType:HXLCustomScrollView_SelectType_CanSelected];
    _pageView.pageViewDelegate = self;
    [_pageView setAutoFlipPageTime:2.5];
    [self.view addSubview:_pageView];
}


#pragma mark - Private




#pragma mark - HXLCustomPageViewDelegate
- (void)pageViewDidClickedWithPageNumber:(NSInteger)pageNumber{
    NSLog(@"selected pageNumber is %d",pageNumber);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"点击了第%d个view",pageNumber]
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}



@end
