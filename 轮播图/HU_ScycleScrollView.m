//
//  HU_ScycleScrollView.m
//  轮播图
//
//  Created by huhang on 15/11/4.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "HU_ScycleScrollView.h"
#import "UIImageView+WebCache.h"
#define SCYLE_WIDTH CGRectGetWidth(self.frame)
#define SCYLE_HEIGHT CGRectGetHeight(self.frame)

@interface HU_ScycleScrollView()<UIScrollViewDelegate>

{
    UIScrollView *_scrollView;                //滑动视图
    UIPageControl *_pageControl;              //小圆点控制器
    
    NSTimer *_timer;                          //延时器
    
    UIColor *_currentPageIndicatorTintColor;  //目前页时小圆点显示的颜色
    UIColor *_pageIndicatorTintColor;         //小圆点正常时候的颜色
    
    UILabel *_titleLb;                        //标题
    UIImage *_placeHolderImg;                 //占位图
    UIImageView *_beforeImageView;            //上一张图片
    UIImageView *_currentImageView;           //目前这张图片
    UIImageView *_nextImageView;              //下一张图片
}

@property (nonatomic,strong)NSArray *images;  //图片数组
@property (nonatomic,strong)NSArray *titles;  //标题数组
@property (nonatomic,assign)NSTimeInterval interval; //延迟多长时间
@property (nonatomic,assign)pageControlAligment pageControlAligment; //小圆点是否居中

@property (nonatomic,assign)NSUInteger beforeImgIndex; //上一张图片位置
@property (nonatomic,assign)NSInteger currentImgIndex; //目前图片位置
@property (nonatomic,assign)NSInteger nextImgIndex;    //下一张图片的位置

@end

@implementation HU_ScycleScrollView

//get方法
- (NSUInteger)beforeImgIndex{
 
    if (self.currentImgIndex == 0) {
        return self.images.count - 1;
    }else{
        return self.currentImgIndex - 1;
    }
}

- (NSInteger)nextImgIndex{
 
    if (self.currentImgIndex < (self.images.count - 1)) {
        return self.currentImgIndex + 1;
    }else{
        return 0;
    }
}

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame placeHolderImg:(NSString *)placeHolder interval:(NSTimeInterval)interval imageArrs:(NSArray *)imageArrs titleArrs:(NSArray *)titleArrs{

    if (self = [super initWithFrame:frame]) {
        self.interval = 3.0; //延迟时间
        self.images = imageArrs; //图片数组
        self.titles = titleArrs; //字符串数组
        self.currentImgIndex = 0; //目前图片位置
        self.pageControlAligment = pageControlAligmentLeft;
        _currentPageIndicatorTintColor = nil;
        _pageIndicatorTintColor = nil;
        _placeHolderImg = [UIImage imageNamed:placeHolder]; //占位图片
        [self setupScycleView];
    }
    return self;
}

#pragma mark 创建视图
- (void)setupScycleView{
 
    //添加scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCYLE_WIDTH, SCYLE_HEIGHT)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor cyanColor];
    _scrollView.contentSize = CGSizeMake(SCYLE_WIDTH * 3, SCYLE_HEIGHT);
    _scrollView.contentOffset = CGPointMake(SCYLE_WIDTH, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    //上一张图片
    _beforeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCYLE_WIDTH, SCYLE_WIDTH)];
    [_scrollView addSubview:_beforeImageView];
    
    //目前图片
    _currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCYLE_WIDTH , 0, SCYLE_WIDTH, SCYLE_HEIGHT)];
    _currentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTheCurrentImgAction:)];
    [_currentImageView addGestureRecognizer:tap];
    [_scrollView addSubview:_currentImageView];
    
    //下一张图片
    _nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCYLE_WIDTH * 2, 0, SCYLE_WIDTH, SCYLE_HEIGHT)];
    [_scrollView addSubview:_nextImageView];
    
    //设置占位图片
    if (_placeHolderImg) {
        _beforeImageView.image = _placeHolderImg;
        _currentImageView.image = _placeHolderImg;
        _nextImageView.image = _placeHolderImg;
    }
    
    //添加标题
    if (self.titles) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCYLE_HEIGHT - 24, SCYLE_WIDTH, 24)];
        view.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.25];
        [self addSubview:view];
        
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCYLE_WIDTH - 20 * self.images.count, 24)];
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.font = [UIFont systemFontOfSize:12.0];
        [view addSubview:_titleLb];
    }
  
    //创建pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCYLE_WIDTH - 20 * self.images.count, SCYLE_HEIGHT - 24, 20 * self.images.count, 24)];
    if (self.pageControlAligment == pageControlAligmentCenter) {
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
    }
    _pageControl.currentPage = self.currentImgIndex;
    _pageControl.numberOfPages = self.images.count;
    _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    [self addSubview:_pageControl];
    
    //添加延迟器
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(useTimerIntervalUpdateScrollViewContentOffSet:) userInfo:nil repeats:YES];
    
    [self updateScycelScrollViewImageIndex];
}

#pragma mark 更新图片位置
- (void)updateScycelScrollViewImageIndex{
 
    [self addTheImageUrlStr:self.images[self.beforeImgIndex] ImgView:_beforeImageView];
    [self addTheImageUrlStr:self.images[self.currentImgIndex] ImgView:_currentImageView];
    [self addTheImageUrlStr:self.images[self.nextImgIndex] ImgView:_nextImageView];
    
    if (self.titles) {
        _titleLb.text = self.titles[_currentImgIndex];
    }
    _pageControl.currentPage = _currentImgIndex;
}

#pragma mark 延时器执行方法
- (void)useTimerIntervalUpdateScrollViewContentOffSet:(NSTimer *)timer{
    
    [_scrollView setContentOffset:CGPointMake(SCYLE_WIDTH * 2, 0) animated:YES];
}
#pragma mark 点击图片执行方法
- (void)clickTheCurrentImgAction:(UITapGestureRecognizer *)tap{
    self.clickCurrentImgBlock(_currentImgIndex);
}


#pragma mark 解析图片并添加到imageView上
- (void)addTheImageUrlStr:(NSString *)urlStr ImgView:(UIImageView *)imgView{

    NSURL *url = [NSURL URLWithString:urlStr];
    [imgView sd_setImageWithURL:url placeholderImage:_placeHolderImg];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [_timer invalidate];
    _timer = nil;
}

//减速滑动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    int offSet = floor(scrollView.contentOffset.x);
    if (offSet == 0) {
        self.currentImgIndex = self.beforeImgIndex;
    }else if (offSet == SCYLE_WIDTH * 2){
        self.currentImgIndex = self.nextImgIndex;
    }
    //更新图片位置
    [self updateScycelScrollViewImageIndex];
    //设置偏移量
    scrollView.contentOffset = CGPointMake(SCYLE_WIDTH, 0);
    //重新设置延时器
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(useTimerIntervalUpdateScrollViewContentOffSet:) userInfo:nil repeats:YES];
    }
}

//滑动结束时停止动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
