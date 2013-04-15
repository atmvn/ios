//
//  BankDetailView.m
//  iATM
//
//  Created by Tai Truong on 4/14/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "BankDetailView.h"

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
        self.backgroundColor = [UIColor clearColor];
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

@end
