//
//  FRDACCTextfield.m
//  Cropnet
//
//  Created by chinhlt on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VKWelcomeTextField.h"

@implementation VKWelcomeTextField
@synthesize fontType = _fontType;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib {

}

-(void)textDidChange:(NSNotification *)notification{
//    NSLog(@"textDidChange: %@", self.text);
    if (_fontType == enumVKWelcomeTextFieldType_BebasNeue) {
//        [super drawTextInRect:CGRectMake(self.frame.origin.x, self.frame.origin.y + 5, self.frame.size.width, self.frame.size.height)];
    }
}

- (void)drawPlaceholderInRect:(CGRect)rect {
//    NSLog(@"drawPlaceholderInRect: %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    if (_fontType == enumVKWelcomeTextFieldType_BebasNeue) {
        [super drawPlaceholderInRect:CGRectMake(rect.origin.x, rect.origin.y + 3, rect.size.width, rect.size.height)];
    }
    else {
        [super drawPlaceholderInRect:rect];
    }
}

- (void)drawTextInRect:(CGRect)rect {
//    NSLog(@"drawTextInRect: %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    if (_fontType == enumVKWelcomeTextFieldType_BebasNeue) {
//        [self.textColor setFill];
//        [self.text drawInRect:CGRectMake(rect.origin.x, rect.origin.y + 5, rect.size.width, rect.size.height) withFont:self.font lineBreakMode:NSLineBreakByClipping alignment:self.textAlignment];
        
//        CGFloat fontHeight;
//        CGSize newSize;
//        fontHeight = (self.font.ascender - self.font.descender) + 1;
//        newSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(999, 999)];
//        newSize = CGSizeMake(newSize.width, newSize.height + fontHeight);
//        NSLog(@"newSize: %f %f", newSize.width, newSize.height);
        
        [super drawTextInRect:CGRectMake(rect.origin.x, rect.origin.y + 3, rect.size.width, rect.size.height)];
    }
    else {
        [super drawTextInRect:rect];
    }
}

-(void)drawRect:(CGRect)rect{
//    NSLog(@"drawRect: %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    if (_fontType == enumVKWelcomeTextFieldType_BebasNeue) {
        [self.text drawInRect:CGRectMake(rect.origin.x, rect.origin.y + 5, rect.size.width, rect.size.height) withFont:self.font lineBreakMode:NSLineBreakByClipping alignment:self.textAlignment];
    }
    else {
        
    }
}

@end
