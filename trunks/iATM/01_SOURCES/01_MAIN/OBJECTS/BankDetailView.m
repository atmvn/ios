//
//  BankDetailView.m
//  iATM
//
//  Created by Tai Truong on 4/14/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "BankDetailView.h"
#import "Define.h"

#define HEIGHT_OF_VIEW_SMALL 85
@implementation BankDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:[self.class description] owner:self options:nil] objectAtIndex:0];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, HEIGHT_IPHONE, WIDTH_IPHONE, HEIGHT_IPHONE);
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)routeTouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bankDetailViewRouteTouchUpInside:)]) {
        [self.delegate bankDetailViewRouteTouchUpInside:self];
    }
}

-(void)show
{
    CGRect r = self.frame;
    r.origin.y = HEIGHT_IPHONE - HEIGHT_STATUS_BAR - HEIGHT_OF_VIEW_SMALL;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = r;
    } completion:nil];
}

-(void)hide
{
    CGRect r = self.frame;
    r.origin.y = HEIGHT_IPHONE;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = r;
    } completion:nil];
}
@end
