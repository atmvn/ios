//
//  TouchedGestureRecognizer.m
//  MAP_KIT_BOOK_MARK
//
//  Created by Phan Ba Minh on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchedGestureRecognizer.h"

#define TIME_TOUCHS_AND_HOLD_FOR_SHORT_TIME_CALL_BACK               0.2
#define TIME_TOUCHS_AND_HOLD_FOR_LONG_TIME_CALL_BACK                0.2
#define TIME_TOUCHS_AND_DOUBLE_CLICK                                0.2

#define TIME_TOUCHS_AND_CHECK_CLICK                                 0.3

@implementation TouchedGestureRecognizer
@synthesize delegateCallBack;

-(id) init{
    if (self = [super init])
    {
        self.cancelsTouchesInView = NO;
    }
    return self;
}

- (void)update {
//    if (enumTouchedForClick == enumTouchedGestureRecognizerClickStep_TouchEnd && CFAbsoluteTimeGetCurrent() - _timeTouchForClicks > TIME_TOUCHS_AND_DOUBLE_CLICK) {
//        enumTouchedForClick = enumTouchedGestureRecognizerClickStep_OneClick;
//        
//        if ([delegateCallBack respondsToSelector:@selector(touchesOneClickCallback:withEvent:)]) {
//            NSLog(@" touchesOneClickCallback ");
//            [delegateCallBack touchesOneClickCallback:nil withEvent:nil];
//        }
//    }
//    
    if (enumTouchedForClick == enumTouchedGestureRecognizerClickStep_TouchBegan) {
        if ((CFAbsoluteTimeGetCurrent() - _timeTouchForHolds > TIME_TOUCHS_AND_HOLD_FOR_LONG_TIME_CALL_BACK)) {
            NSLog(@" touchesAndHoldForLongTimeCallback ");
            enumTouchedForClick = enumTouchedGestureRecognizerClickStep_LongPress;
            
            if ([delegateCallBack respondsToSelector:@selector(touchesAndHoldForLongTimeCallback:withEvent:)]) {
                [delegateCallBack touchesAndHoldForLongTimeCallback:nil withEvent:nil];
            }
        }
        else if ((CFAbsoluteTimeGetCurrent() - _timeTouchForHolds > TIME_TOUCHS_AND_HOLD_FOR_SHORT_TIME_CALL_BACK)) {
            NSLog(@" touchesAndHoldForShortTimeCallback ");
            enumTouchedForClick = enumTouchedGestureRecognizerClickStep_ShortPress;
            
            if ([delegateCallBack respondsToSelector:@selector(touchesAndHoldForShortTimeCallback:withEvent:)])
                [delegateCallBack touchesAndHoldForShortTimeCallback:nil withEvent:nil];
        }
    }
}

-(void)oneTap
{
    if (enumTouchedForClick == enumTouchedGestureRecognizerClickStep_TouchEnd) {
        NSLog(@"Single tap");
        enumTouchedForClick = enumTouchedGestureRecognizerClickStep_OneClick;
        
        if ([delegateCallBack respondsToSelector:@selector(touchesOneClickCallback:withEvent:)]) {
            [delegateCallBack touchesOneClickCallback:nil withEvent:nil];
        }
    }
}

-(void)twoTaps
{
    NSLog(@"Double tap");
    enumTouchedForClick = enumTouchedGestureRecognizerClickStep_DoubleClick;
    
    if ([delegateCallBack respondsToSelector:@selector(touchesDoubleClickCallback:withEvent:)]) {
        [delegateCallBack touchesDoubleClickCallback:nil withEvent:nil];
    }
}

-(void)threeTaps
{
    NSLog(@"Triple tap");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    enumTouchedForClick = enumTouchedGestureRecognizerClickStep_TouchBegan;
    
//    enumTouchedForLongPress = enumTouchedGestureRecognizerClickStep_TouchBegan;
    
    if ([delegateCallBack respondsToSelector:@selector(touchesBeganCallback:withEvent:)]) {
        NSLog(@" touchesBeganCallback ");
        [delegateCallBack touchesBeganCallback:touches withEvent:event];
    }
    
//    if (CFAbsoluteTimeGetCurrent() - _timeTouchForClicks < TIME_TOUCHS_AND_DOUBLE_CLICK) {
//        enumTouchedForClick = enumTouchedGestureRecognizerClickStep_DoubleClick;
//        
//        if ([delegateCallBack respondsToSelector:@selector(touchesDoubleClickCallback:withEvent:)]) {
//            NSLog(@" touchesDoubleClickCallback ");
//            [delegateCallBack touchesDoubleClickCallback:touches withEvent:event];
//        }
//    }
    
    _timeTouchForHolds = CFAbsoluteTimeGetCurrent();
    
    // Detect touch anywhere
    UITouch *touch = [touches anyObject];
    
    switch ([touch tapCount]) 
    {
        case 1:
            [self performSelector:@selector(oneTap) withObject:nil afterDelay:TIME_TOUCHS_AND_CHECK_CLICK];
            break;
            
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];
            [self performSelector:@selector(twoTaps) withObject:nil afterDelay:TIME_TOUCHS_AND_CHECK_CLICK];
            break;
            
        case 3:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(twoTaps) object:nil];
            [self performSelector:@selector(threeTaps) withObject:nil afterDelay:TIME_TOUCHS_AND_CHECK_CLICK];
            break;
            
        default:
            break;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@" touchesCancelled ");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@" touchesEnded ");
    if (enumTouchedForClick == enumTouchedGestureRecognizerClickStep_TouchBegan) {
        enumTouchedForClick = enumTouchedGestureRecognizerClickStep_TouchEnd;
    }
    
    _timeTouchForClicks = CFAbsoluteTimeGetCurrent();
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@" touchesMoved ");
    if (enumTouchedForClick == enumTouchedGestureRecognizerClickStep_TouchBegan)
        enumTouchedForClick = enumTouchedGestureRecognizerClickStep_TouchMoved;
}

@end
