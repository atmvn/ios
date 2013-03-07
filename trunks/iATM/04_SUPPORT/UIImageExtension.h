//
//  UIImageExtension.h
//  VietQuan
//
//  Created by hainguyen on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Extension)

+(UIImage *) makeRoundCornersImage: (UIImage*) img : (int) cornerWidth : (int) cornerHeight;
+(UIImage *) makeRoundTopCornersImage: (UIImage*) img : (int) cornerWidth : (int) cornerHeight;
+(UIImage*) makeRoundTopLeftCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight;
-(UIImage*) scaleToNewHeight:(CGSize) size;
-(UIImage*) scaleToNewWidth:(CGSize) size;
-(UIImage*) scaleToSize:(CGSize)size;
-(CGRect)scaleFrame:(CGRect)originFrame heightImage:(float)aHeight widthImage:(float)aWidth;
-(UIImage*) imageWithBackgroundColor:(UIColor*)color;
-(UIImage*) convertOrientationUp:(UIImage*)image;
+ (UIImage *)imageWithView:(UIView *)view;

@end
