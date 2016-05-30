//
//  HU_ScycleScrollView.h
//  轮播图
//
//  Created by huhang on 15/11/4.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, pageControlAligment){
  
    pageControlAligmentCenter = 0,
    pageControlAligmentLeft
};

@class HU_ScycleScrollView;
@protocol ScyleScrollViewDelegate <NSObject>

- (void)scyleScrollView:(HU_ScycleScrollView *)scyleView index:(NSInteger)index;

@end


@interface HU_ScycleScrollView : UIView

//初始化
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;

/** 占位图片 */
@property (nonatomic,strong)UIImage *placeHolderImg;

/** 标题数组 */
@property (nonatomic,strong)NSArray *titles;

/** 圆点位置 */
@property (nonatomic,assign)pageControlAligment pageAligment;

/** 目前页时小圆点显示的颜色 */
@property (nonatomic,strong)UIColor *currentPageIndicatorTintColor;

/** 小圆点正常时候的颜色 */
@property (nonatomic,strong)UIColor *pageIndicatorTintColor;

/** 协议 */
@property (nonatomic,assign)id<ScyleScrollViewDelegate> delegate;

@end
