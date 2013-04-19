//
//  GradientPolylineView.m
//  iATM
//
//  Created by Tai Truong on 4/16/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "GradientPolylineView.h"

@implementation GradientPolylineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
    UIColor *fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
    CGFloat lineWidth = 75.0;
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, lineWidth);
    CGContextAddPath(context, self.path);
    CGContextReplacePathWithStrokedPath(context);
    CGContextFillPath(context);
    
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
}
@end
