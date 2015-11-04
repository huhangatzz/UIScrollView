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
@interface ViewController ()
{
    HU_ScycleScrollView *_scyleSV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *images = @[@"http://img2.3lian.com/2014/f7/5/d/22.jpg",
                        @"http://image.tianjimedia.com/uploadImages/2011/327/1VPRY46Q4GB7.jpg",
                        @"http://img6.faloo.com/Picture/0x0/0/747/747488.jpg",
                        @"http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg"];
    NSArray *titles = @[@"1http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg",@"2http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg",@"3http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg",@"4http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg"];
    
    _scyleSV = [[HU_ScycleScrollView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 170) placeHolderImg:@"1.png" interval:3.0 imageArrs:images titleArrs:titles];
    [self.view addSubview:_scyleSV];
    [self clickTheImgAction];
}

- (void)clickTheImgAction{
 
    _scyleSV.clickCurrentImgBlock = ^(NSInteger i){

        NSLog(@"== %ld",(long)i);
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
