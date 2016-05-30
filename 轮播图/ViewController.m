//
//  ViewController.m
//  轮播图
//
//  Created by huhang on 15/11/4.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "ViewController.h"
#import "HU_ScycleScrollView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<ScyleScrollViewDelegate>
{
    HU_ScycleScrollView *_scyleSV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *images = @[@"http://img5.imgtn.bdimg.com/it/u=2778082280,495752289&fm=21&gp=0.jpg",
//                        @"http://img0.imgtn.bdimg.com/it/u=3314769904,2856776754&fm=21&gp=0.jpg",
//                        @"http://img2.3lian.com/2014/f7/5/d/22.jpg",
//                        @"http://f.hiphotos.baidu.com/image/h%3D360/sign=b023dbb2d739b60052ce09b1d9513526/f2deb48f8c5494ee55f2d7482ff5e0fe98257e8b.jpg",
//                        @"http://a.hiphotos.baidu.com/image/h%3D200/sign=af9259bf03082838770ddb148898a964/6159252dd42a2834bc76c4ab5fb5c9ea14cebfba.jpg"];
    
    NSArray *images = @[@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.png"];
    NSArray *titles = @[@"学校",@"学霸",@"学生",@"学渣",@"学习"];
    _scyleSV = [[HU_ScycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250) images:images];
    //_scyleSV.placeHolderImg = [UIImage imageNamed:@"1"];
    _scyleSV.delegate = self;
    _scyleSV.titles = titles;
    [self.view addSubview:_scyleSV];
}

#pragma mark ScyleScrollViewDelegate
- (void)scyleScrollView:(HU_ScycleScrollView *)scyleView index:(NSInteger)index{
    NSLog(@"----- %ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
