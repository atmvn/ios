//
//  TouchedGestureRecognizer.h
//  MAP_KIT_BOOK_MARK
//
//  Created by Phan Ba Minh on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol TouchedGestureRecognizerProtocol <NSObject>

@optional
- (void)touchesBeganCallback:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesAndHoldForShortTimeCallback:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesAndHoldForLongTimeCallback:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesDoubleClickCallback:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesOneClickCallback:(NSSet *)touches withEvent:(UIEvent *)event;
@end

typedef enum {
    enumTouchedGestureRecognizerClickStep_Invalid,
    enumTouchedGestureRecognizerClickStep_TouchBegan,
    enumTouchedGestureRecognizerClickStep_TouchEnd,
    enumTouchedGestureRecognizerClickStep_DoubleClick,
    enumTouchedGestureRecognizerClickStep_ShortPress,
    enumTouchedGestureRecognizerClickStep_LongPress,
    enumTouchedGestureRecognizerClickStep_OneClick,
    enumTouchedGestureRecognizerClickStep_TouchMoved
}enumTouchedGestureRecognizerClickStep;

typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface TouchedGestureRecognizer : UIGestureRecognizer {
    TouchesEventBlock                       touchesBeganCallback;
    
    enumTouchedGestureRecognizerClickStep   enumTouchedForClick;
//    enumTouchedGestureRecognizerClickStep   enumTouchedForLongPress;
    
    CFAbsoluteTime                          _timeTouchForHolds;
    CFAbsoluteTime                          _timeTouchForClicks;
}
@property (nonatomic, assign) id<TouchedGestureRecognizerProtocol> delegateCallBack;

- (void)update;

@end
