//
//  TTScrollView.m
//  UIScrollVIewCus
//
//  Created by Thinkive on 2017/8/22.
//  Copyright © 2017年 Teo. All rights reserved.
//

#import "TTScrollView.h"

@implementation TTScrollView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panG];
    self.layer.masksToBounds = YES;
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = self.bounds.origin;
    }
    else if (pan.state == UIGestureRecognizerStateChanged){
        CGPoint point = [pan translationInView:self];
        CGFloat newStartX = self.startPoint.x - point.x;
        CGFloat newStartY = self.startPoint.y - point.y;
        
        CGRect bounds = self.bounds;
        bounds.origin = CGPointMake(newStartX, newStartY);
        
        if (bounds.origin.x + bounds.size.width > _contentSize.width) {
            bounds.origin.x = _contentSize.width - bounds.size.width;
        }
        if (bounds.origin.y + bounds.size.height > _contentSize.height) {
            bounds.origin.y = _contentSize.height - bounds.size.height;
        }
        if (bounds.origin.x < 0) {
            bounds.origin.x = 0;
        }
        if (bounds.origin.y < 0) {
            bounds.origin.y = 0;
        }
        self.bounds = bounds;
    }
}

- (void)setContentSize:(CGSize)contentSize{
    _contentSize = contentSize;
    CGRect bounds = self.bounds;
    bounds.origin = _contentOffset;
}

@end
