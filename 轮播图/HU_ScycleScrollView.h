//
//  HU_ScycleScrollView.h
//  轮播图
//
//  Created by huhang on 15/11/4.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBlock)(NSInteger);

typedef NS_ENUM(NSInteger, pageControlAligment){
  
    pageControlAligmentCenter = 0,
    pageControlAligmentLeft
};

@interface HU_ScycleScrollView : UIView

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame placeHolderImg:(NSString *)placeHolder interval:(NSTimeInterval)interval imageArrs:(NSArray *)imageArrs titleArrs:(NSArray *)titleArrs;

//点击图片的blcok
@property (nonatomic,strong)clickBlock clickCurrentImgBlock;

@end
