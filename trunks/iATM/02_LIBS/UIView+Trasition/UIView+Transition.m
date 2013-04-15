//
//  UIView+Transition.m
//  viewtrasition
//
//  Created by Tai Truong on 4/8/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "UIView+Transition.h"
#import "Define.h"


@implementation UIView (FadingTransisiton)

-(void)fadingTransisitonShowWithMask
{
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_IPHONE)];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.0f;
    mask.tag = 10033;
    UITapGestureRecognizer *taptodismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadingTransisitonShouldHideView:)];
    [mask addGestureRecognizer:taptodismiss];
    
    [self.superview addSubview:mask];
    [self.superview bringSubviewToFront:self];
    CGRect r = self.frame;
    r.origin.y = HEIGHT_IPHONE;
    self.frame = r;
    r.origin.y = HEIGHT_IPHONE - r.size.height;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = r;
        mask.alpha = 0.6f;
    } completion:nil];
}

-(void)fadingTransisitonShouldHideView:(UITapGestureRecognizer*)recognizer
{
    [self fadingTransisitonShouldHideWithMask];
}

-(void)fadingTransisitonShouldHideWithMask
{
    CGRect r = self.frame;
    r.origin.y = HEIGHT_IPHONE;
    UIView *mask = [self.superview viewWithTag:10033];
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = r;
        mask.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [mask removeFromSuperview];
    }];
}
@end