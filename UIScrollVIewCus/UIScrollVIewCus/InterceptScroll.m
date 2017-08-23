//
//  InterceptScroll.m
//  UIScrollVIewCus
//
//  Created by Thinkive on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "InterceptScroll.h"

@implementation InterceptScroll

- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor redColor]];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 200)];
        view.backgroundColor = [UIColor yellowColor];
        [self addSubview:view];
    }
    return self;
}

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
//      返回YES 不滚动scroll ；返回NO 滚动
    NSLog(@" **** %@",view);
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
//      返回NO scroll 不能滚动；返回YES 滚动
    NSLog(@" --------- %@",view);
    return NO;
}



@end
