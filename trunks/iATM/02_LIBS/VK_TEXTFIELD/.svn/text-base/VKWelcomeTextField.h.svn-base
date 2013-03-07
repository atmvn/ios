//
//  FRDACCTextfield.h
//  Cropnet
//
//  Created by chinhlt on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    enumVKWelcomeTextFieldType_Invalid,
    enumVKWelcomeTextFieldType_BebasNeue
}enumVKWelcomeTextFieldType;
@interface VKWelcomeTextField:  UITextField
{
	NSString *_placeholder;
    UIColor *_placeHolderColor;

}
@property (nonatomic) enumVKWelcomeTextFieldType fontType;
-(void)awakeFromNib;
-(void)textDidChange:(NSNotification *)notification;

@end
