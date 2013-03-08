/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import "SupportFunction.h"// MinhPB 2012/06/28
#import <objc/runtime.h>

@implementation UIImageView (WebCache)
static char UIB_PROPERTY_KEY;
@dynamic scaleOption;

- (void)setScaleOption:(NSString *)option
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, option, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)scaleOption
{
    return (NSString *)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
    
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    
     SDWebImageManager *manager = [SDWebImageManager sharedManager];
     
     // Remove in progress downloader from queue
     [manager cancelForDelegate:self];
     
    // MinhPB 03/07/2012
    if ([self.scaleOption isEqual: enumWebImageScaleOption_FullFill]) {
        [self setImage:placeholder];
    }
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScaleToFill]) {
        [self setImage:[placeholder imageByScalingToSize:self.frame.size withOption:enumImageScalingType_Center_ScaleSize]];
    }
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSize]) {
        //[self setImage:[self scaleImageToGivenSize:placeholder]];
    }
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSizeLarger]) {
        //     // added by seng
        UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2 - 11.0f),CGRectGetHeight(self.frame) / 2, 22.0f, 22.0f);
        
        activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview: activityView];
        [activityView startAnimating];
    }
    else {
        [self setImage:placeholder];
    }
     
//     // added by seng
//     UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc]
//     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
//     activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2 - 11.0f),CGRectGetHeight(self.frame) / 2, 22.0f, 22.0f);
//     
//     activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
//     UIViewAutoresizingFlexibleBottomMargin |
//     UIViewAutoresizingFlexibleLeftMargin |
//     UIViewAutoresizingFlexibleTopMargin;
//     
//     [self addSubview: activityView];
//     [activityView startAnimating]; 
     
     
     if (url)
     {
         // MinhPB 2012/10/04
         [manager downloadWithURL:url delegate:self retryFailed:YES];
     }
        
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    // MinhPB 03/07/2012
    if ([self.scaleOption isEqual: enumWebImageScaleOption_FullFill]) {
        [self setImage:image];
    }
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScaleToFill]) {
        
       [self setImage:[image imageByScalingToSize:self.frame.size withOption:enumImageScalingType_Center_ScaleSize]];
    }
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScaleToWidth_Top]) {
        [self setImage:[image imageByScalingToSize:self.frame.size withOption:enumImageScalingType_Top]];
    }
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSize]) {
        
        UIImage *thumbnailPhoto = [self cropCenterAndScaleImageToSize:CGSizeMake(85.0,85.0) selectedImage:image];
        
        [self setImage:thumbnailPhoto];
    }
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoToSizeLarger]) {
        //UIImage *thumbnailPhoto = [self cropCenterAndScaleImageToSize:CGSizeMake(240.0,195.0) selectedImage:image];
        UIImage *thumbnailPhoto = [self cropCenterAndScaleImageToSize:CGSizeMake(240.0,220.0) selectedImage:image];
        [self setImage:thumbnailPhoto];
    }
    
    else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoFullSize]) {
        UIImage *thumbnailPhoto = [self cropCenterAndScaleImageToSize:CGSizeMake(320.0,220.0) selectedImage:image];
        [self setImage:thumbnailPhoto];
    } else if ([self.scaleOption isEqual: enumWebImageScaleOption_ScalePhotoCenterFullSize]) {
        UIImage *thumbnailPhoto = [image imageByScalingToSize:CGSizeMake(self.frame.size.width,self.frame.size.height) withOption:enumImageScalingType_Center_FullSize];
        [self setImage:thumbnailPhoto];
    }
    
    
    else {
        [self setImage:image];
    }
    
    NSArray *subviews = [self subviews];
    UIActivityIndicatorView *activityView = nil;
    for (activityView in subviews)
    {
        if ([activityView isKindOfClass:[UIActivityIndicatorView class]])
        {
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        }
    }
}

-(void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error{
   
    /*if(!self.image){
         NSLog(@"TAG FAIL = %d", self.tag);
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.tag],@"index", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadError" object:nil userInfo:userInfo];
    }
    else{
        UIImageView *imageTemp = [[UIImageView alloc]initWithImage:self.image];
        imageTemp.tag = self.tag;
        NSLog(@"TAG = %d", self.tag);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishDownloadImage" object:imageTemp userInfo:nil];
        

    }*/
    
    // MinhPB 02/07/2012
    NSArray *subviews = [self subviews];
    UIActivityIndicatorView *activityView = nil;
    for (activityView in subviews)
    {
        if ([activityView isKindOfClass:[UIActivityIndicatorView class]])
        {
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        }
    }   
}

#pragma mark UIImage Methods
//250x200

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize selectedImage:(UIImage*) image {
	UIImage *scaledImage = [self rescaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize selectedImage:image] selectedImage:image];
    
    NSLog(@"width:%f height:%f",scaledImage.size.width,scaledImage.size.height);
    
    CGRect cropedImageRect = CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height);
    
    //CGRect cropedImageRect = CGRectMake((image.size.width-cropSize.width)/2, (image.size.height-cropSize.height)/2, cropSize.width, cropSize.height);
    
	return [self cropImageToRect:cropedImageRect selectedImage:scaledImage];
}

- (UIImage *)cropImageToRect:(CGRect)cropRect selectedImage:(UIImage*)image {
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (image.size.height - cropRect.size.height) , image.size.width, image.size.height);
	CGContextDrawImage(ctx, drawRect, image.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox selectedImage:(UIImage*)image {
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (image.size.width < image.size.height) {
		newWidth = croppingBox.width;
		newHeight = (image.size.height / image.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (image.size.width / image.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)rescaleImageToSize:(CGSize)size selectedImage:(UIImage*)image {
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

@end
