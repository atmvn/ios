//
//  UIImageExtension.m
//  VietQuan
//
//  Created by hainguyen on 11/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImageExtension.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Extension)

+(void) addRoundedRectToPath: (CGContextRef) context rect: (CGRect) rect width: (float) ovalWidth height: (float) ovalHeight {
	float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(void) addTopRoundedRectToPath: (CGContextRef) context rect: (CGRect) rect width: (float) ovalWidth height: (float) ovalHeight {
	float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 0);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 0);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(void) addTopLeftRoundedRectToPath: (CGContextRef) context rect: (CGRect) rect width: (float) ovalWidth height: (float) ovalHeight {
	float fw, fh;
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	CGContextSaveGState(context);
	CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM (context, ovalWidth, ovalHeight);
	fw = CGRectGetWidth (rect) / ovalWidth;
	fh = CGRectGetHeight (rect) / ovalHeight;
	CGContextMoveToPoint(context, fw, fh/2);
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 0);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 0);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 0);
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

+(UIImage *) makeRoundCornersImage: (UIImage*) img : (int) cornerWidth : (int) cornerHeight{
	UIImage * newImage = nil;
	
	if( nil != img)
	{
		int w = img.size.width;
		int h = img.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		[self addRoundedRectToPath:context rect:rect width:cornerWidth height:cornerHeight];
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		newImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
	}
	
    return newImage;
}

+(UIImage *) makeRoundTopCornersImage: (UIImage*) img : (int) cornerWidth : (int) cornerHeight{
	UIImage * newImage = nil;
	
	if( nil != img)
	{
		int w = img.size.width;
		int h = img.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		[self addTopRoundedRectToPath:context rect:rect width:cornerWidth height:cornerHeight];
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		newImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
	}
	
    return newImage;
}

+(UIImage *) makeRoundTopLeftCornerImage: (UIImage*) img : (int) cornerWidth : (int) cornerHeight {
	UIImage * newImage = nil;
	
	if( nil != img)
	{
		int w = img.size.width;
		int h = img.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		[self addTopLeftRoundedRectToPath:context rect:rect width:cornerWidth height:cornerHeight];
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		newImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
	}
	
    return newImage;
}

-(UIImage*) scaleToNewHeight:(CGSize) size{
    int scaleWidth = (int)size.height*self.size.width/self.size.height; 
    UIImageView *thumbView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scaleWidth, size.height)] autorelease];
    [thumbView setImage:self];                    
    UIView *tempView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];                    
    [tempView setBackgroundColor:[UIColor blackColor]];
    [tempView addSubview:thumbView];
    [thumbView setFrame:CGRectMake((tempView.frame.size.width/2) - scaleWidth/2, 0, scaleWidth, size.height)];                    
    UIGraphicsBeginImageContext(tempView.bounds.size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage*) scaleToNewWidth:(CGSize) size{
    int scaleHeight = (int)size.height*self.size.width/self.size.height;
    UIImageView *thumbView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, scaleHeight)] autorelease];
    [thumbView setImage:self];                    
    UIView *tempView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];                    
    [tempView setBackgroundColor:[UIColor blackColor]];
    [tempView addSubview:thumbView];
    [thumbView setFrame:CGRectMake(0, (tempView.frame.size.height/2) - scaleHeight/2, size.width, scaleHeight)];                    
    UIGraphicsBeginImageContext(tempView.bounds.size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(UIImage*) scaleToSize:(CGSize)size{
	//Use Quartz for thread safety
	CGImageRef selfRef = [self CGImage];
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 4 * size.width, colorSpaceRef, kCGImageAlphaPremultipliedFirst);
	CGColorSpaceRelease(colorSpaceRef);
	CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), selfRef);
	CGImageRef scaledImageRef = CGBitmapContextCreateImage(context);
	UIImage *scaledImage = [UIImage imageWithCGImage:scaledImageRef];
	CGContextRelease(context);
	CGImageRelease(scaledImageRef);
	return scaledImage;
}

- (CGRect)scaleFrame:(CGRect)originFrame heightImage:(float)aHeight widthImage:(float)aWidth {
	CGRect frame = originFrame;
	float height = frame.size.height;
	float width = frame.size.width;
	float rate1 = height/aHeight;
	float rate2 = width/aWidth;
	
	if (aHeight > height && aWidth > width){
		if (rate1 < rate2){
			frame.size.width = rate1*aWidth;
		} else {
			frame.size.height = rate2*aHeight;
		}
	} else if(aHeight > height) {
		frame.size.width = rate1*aWidth;
	} else if(aWidth > width) {
		frame.size.height = rate2*aHeight;
	} else {
		frame.size.width = aWidth;
		frame.size.height = aHeight;
	}
	return frame;
}

-(UIImage*) imageWithBackgroundColor:(UIColor*)color {
    UIView *newView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.height, self.size.width)] autorelease];
    newView.backgroundColor = color;
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.75*self.size.width, self.size.width)] autorelease];
    imageView.image = self;
    [newView addSubview:imageView];
    imageView.center = newView.center;
    UIGraphicsBeginImageContext(newView.frame.size);
    [[newView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [newImage retain];
}

-(UIImage*) convertOrientationUp:(UIImage*)image {
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef context = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage), 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(context, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(context, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(context, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(context);
    CGImageRelease(imageRef);
    return newImage;
}

+ (UIImage *) imageWithView:(UIView *)view
{
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
-(UIImage *) ChangeViewToImage : (UIView *) view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



@end
