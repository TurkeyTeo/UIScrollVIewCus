//
//  ViewController.m
//  UIScrollVIewCus
//
//  Created by Thinkive on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "ViewController.h"
#import "TTScrollView.h"
#import "InterceptScroll.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    bounds
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    [view1 setBounds:CGRectMake(-30, -30, 200, 200)];
    //    [view1 setBounds:CGRectMake(-30, -30, 250, 250)];
    //    [view1 setBounds:CGRectMake(-30, -30, 100, 100)];
    
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];//添加到self.view
    NSLog(@"view1 frame:%@========view1 bounds:%@",NSStringFromCGRect(view1.frame),NSStringFromCGRect(view1.bounds));
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view2.backgroundColor = [UIColor yellowColor];
    [view1 addSubview:view2];//添加到view1上,[此时view1坐标系左上角起点为(-30,-30)]
    //    NSLog(@"view2 frame:%@========view2 bounds:%@",NSStringFromCGRect(view2.frame),NSStringFromCGRect(view2.bounds));

    
    
//    2.implement a basic ScrollView by self
    TTScrollView *scrol = [[TTScrollView alloc] initWithFrame:CGRectMake(10, 240, 100, 100)];
    [self.view addSubview:scrol];
    scrol.backgroundColor = [UIColor lightGrayColor];
    scrol.contentSize = CGSizeMake(100, 300);
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
    lab.text = @"hello";
    [scrol addSubview:lab];
    
    
//    3.intercept view
    InterceptScroll *inScroll = [[InterceptScroll alloc] initWithFrame:CGRectMake(10, 360, 300, 300)];
    inScroll.contentSize = CGSizeMake(300, 500);
    [self.view addSubview:inScroll];
    
    [inScroll setCanCancelContentTouches:YES];
    [inScroll setDelaysContentTouches:NO];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
