/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"
#import "SupportFunction.h"// MinhPB 2012/06/28
#import <objc/runtime.h>

@implementation UIButton (WebCache)
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

//    [self setImage:placeholder forState:UIControlStateNormal];
    // MinhPB 03/07/2012
    if (self.scaleOption == enumWebImageScaleOption_FullFill) {
        [self setImage:[placeholder imageByScalingToSize:self.frame.size withOption:enumImageScalingType_TargetSize] forState:UIControlStateNormal];
    }
    else if (self.scaleOption == enumWebImageScaleOption_ScaleToFill) {
        [self setImage:[placeholder imageByScalingToSize:self.frame.size withOption:enumImageScalingType_Center_ScaleSize] forState:UIControlStateNormal];
    }
    else {
        [self setImage:placeholder forState:UIControlStateNormal];
    }

//    // added by MinhPB 02/07/2012 
//    UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc]
//                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
//    activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2 - 11.0f),CGRectGetHeight(self.frame) / 2, 22.0f, 22.0f);
//    
//    activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
//    UIViewAutoresizingFlexibleBottomMargin |
//    UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleTopMargin;
//    
//    [self addSubview: activityView];
//    [activityView startAnimating]; 
    
    if (url)
    {
        // MinhPB 2012/10/04
        [manager downloadWithURL:url delegate:self retryFailed:YES];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

//- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
//{
//    [self setImage:image forState:UIControlStateNormal];
//}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    // MinhPB 03/07/2012
    if (self.scaleOption == enumWebImageScaleOption_FullFill) {
        [self setImage:[image imageByScalingToSize:self.frame.size withOption:enumImageScalingType_TargetSize] forState:UIControlStateNormal];
    }
    else if (self.scaleOption == enumWebImageScaleOption_ScaleToFill) {
        [self setImage:[image imageByScalingToSize:self.frame.size withOption:enumImageScalingType_Center_ScaleSize] forState:UIControlStateNormal];
    }
    else if (self.scaleOption == enumWebImageScaleOption_ScaleToWidth_Top) {
        [self setImage:[image imageByScalingToSize:self.frame.size withOption:enumImageScalingType_Top] forState:UIControlStateNormal];
    }
    else {
        [self setImage:image forState:UIControlStateNormal];
    }
    
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

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error {
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

@end
