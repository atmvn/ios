/*
 * $Author: kidbaw $
 * $Revision: 59 $
 * $Date: 2012-03-23 22:44:48 +0700 (Fri, 23 Mar 2012) $
 *
 */

#import "SupportFunction.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "Define.h"
#import "Utilities.h"

@implementation UIAlertView (Shared)

static UIAlertView *_Shared_1Button;
+ (UIAlertView *)Shared_1Button {
    if ( !_Shared_1Button ) {
        _Shared_1Button = [[UIAlertView alloc] init];
    }
    return _Shared_1Button;
}

static UIAlertView *_Shared_2Button;
+ (UIAlertView *)Shared_2Button {
    if ( !_Shared_2Button ) {
        _Shared_2Button = [[UIAlertView alloc] init];
    }
    return _Shared_2Button;
}

static UIAlertView *_Shared_3Button;
+ (UIAlertView *)Shared_3Button {
    if ( !_Shared_3Button ) {
        _Shared_3Button = [[UIAlertView alloc] init];
    }
    return _Shared_3Button;
}

@end

@implementation UIDevice (Resolutions)

- (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

- (BOOL)isSimulator {
    if ([[[UIDevice currentDevice].model lowercaseString] rangeOfString:@"simulator"].location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}

@end

@implementation SupportFunction

typedef enum {
	libUserInterfaceIdiomUnknown = -1,
    libUserInterfaceIdiomPhone,
    libUserInterfaceIdiomPad,
} libUserInterfaceIdiom;

static libUserInterfaceIdiom g_interfaceIdiom = libUserInterfaceIdiomUnknown;
+ (BOOL)deviceIsIPad
{
#ifdef IS_SUPPORTED_IPAD
	if ( g_interfaceIdiom == libUserInterfaceIdiomUnknown ) {
		switch ( UI_USER_INTERFACE_IDIOM() ) {
			case UIUserInterfaceIdiomPhone:
				g_interfaceIdiom = libUserInterfaceIdiomPhone;
				break;
				
			case UIUserInterfaceIdiomPad:
				g_interfaceIdiom = libUserInterfaceIdiomPad;
				break;
		}
	}
	return (g_interfaceIdiom == libUserInterfaceIdiomPad);
#else
    g_interfaceIdiom = libUserInterfaceIdiomUnknown;
    return NO;
#endif
    g_interfaceIdiom = libUserInterfaceIdiomUnknown;
}

+ (int)getDeviceHeight
{
#ifdef IS_SUPPORTED_LANDSCAPE
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (IS_IPAD) {
            return _WIDTH_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _WIDTH_IPHONE_5;
        }
        else {
            return _WIDTH_IPHONE;
        }
    }
    else {
        if (IS_IPAD) {
            return _HEIGHT_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _HEIGHT_IPHONE_5;
        }
        else {
            return _HEIGHT_IPHONE;
        }
    }
#else
    if (IS_IPAD) {
        return _HEIGHT_IPAD;
    }
    else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
        return _HEIGHT_IPHONE_5;
    }
    else {
        return _HEIGHT_IPHONE;
    }
#endif
}

+ (int)getDeviceWidth
{
#ifdef IS_SUPPORTED_LANDSCAPE
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (IS_IPAD) {
            return _HEIGHT_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _HEIGHT_IPHONE_5;
        }
        else {
            return _HEIGHT_IPHONE;
        }
    }
    else {
        if (IS_IPAD) {
            return _WIDTH_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _WIDTH_IPHONE_5;
        }
        else {
            return _WIDTH_IPHONE;
        }
    }
#else
    if (IS_IPAD) {
        return _WIDTH_IPAD;
    }
    else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
        return _WIDTH_IPHONE_5;
    }
    else {
        return _WIDTH_IPHONE;
    }
#endif
}

+ (int)getKeyboardHeight
{
#ifdef IS_SUPPORTED_LANDSCAPE
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (IS_IPAD) {
            return HEIGHT_IPAD_KEYBOARD_LANDSCAPE;
        }
        else
            return HEIGHT_IPHONE_KEYBOARD_LANDSCAPE;
    }
    else {
        if (IS_IPAD) {
            return HEIGHT_IPAD_KEYBOARD;
        }
        else
            return HEIGHT_IPHONE_KEYBOARD;
    }
#else
    if (IS_IPAD) {
        return HEIGHT_IPAD_KEYBOARD;
    }
    else
        return HEIGHT_IPHONE_KEYBOARD;
#endif
}

+ (int)getKeyboardWidth
{
    return [self getDeviceWidth];
}

+ (NSMutableArray *)sortArray:(NSMutableArray *)source withKey:(NSString *)key
{
    if ([source count] < 1) {
        return nil;
    }
    if ([source count] == 1) {
        return source;
    }
    NSMutableArray *ma_Copy = [NSMutableArray arrayWithArray:source];
    NSSortDescriptor *sd_Temp = [[[NSSortDescriptor alloc] initWithKey:key ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *a_Descriptor = [NSArray arrayWithObjects:sd_Temp, nil];
    NSMutableArray *ma_Sort = [[NSMutableArray new] autorelease];
    [ma_Sort addObjectsFromArray:[ma_Copy sortedArrayUsingDescriptors:a_Descriptor]];
    return ma_Sort;
}

+ (NSString *)getStringDistanceFromLocation:(CLLocation *)fromLoc toLocation:(CLLocation *)toLoc {
    CLLocationDistance kilometers = [fromLoc distanceFromLocation:toLoc] / 1000; 
//    CLLocationDistance meters = [fromLoc distanceFromLocation:toLoc];
    
    return [NSString stringWithFormat:@"%.2fKm", kilometers];
}

+ (NSString *)getStringDistanceFromMeter:(double)meters {
//    int feet = meters; // Server: return to inches
//    int realMeter = inches / 0.0254;
    float realMeters = meters * 0.3048;
    
//    int feet = realMeters / 0.3048;
//    int yards = realMeters / 0.9144;
//    int miles = realMeters / 1609;
//    if (miles >= DOUBLE_DISTANCE_UNIT_MIN && miles <= DOUBLE_DISTANCE_UNIT_MAX*DOUBLE_DISTANCE_UNIT_MAX) {
//        return [NSString stringWithFormat:@"%i mi", miles];
//    }
//    else if (yards >= DOUBLE_DISTANCE_UNIT_MIN && miles <= DOUBLE_DISTANCE_UNIT_MIN) {
//        return [NSString stringWithFormat:@"%i yd", yards];
//    }
//    else if (feet >= 0 && yards <= DOUBLE_DISTANCE_UNIT_MIN) {
//        return [NSString stringWithFormat:@"%i ft", feet];
//    }
//    else
//        return [NSString stringWithFormat:@"∞"];
    
    float miles = realMeters / 1609;
    if (miles == 0) {
        return @"";
    }
    else if (miles <= DOUBLE_DISTANCE_UNIT_MAX*DOUBLE_DISTANCE_UNIT_MAX) {
        return [NSString stringWithFormat:@"%.1f mi", miles + 0.1];
    }
    else
        return [NSString stringWithFormat:@"∞"];
}


+ (CGRect)getFrameNotificationWithFont:(UIFont *)font andNotificationNumber:(int)num andAppearPosition:(enumVKNotificationAppearPosition)position andParentFrame:(CGRect)frame {
    CGRect newRect = CGRectZero;
    
    NSString *strNum = [NSString stringWithFormat:@"%i", num];
    CGSize sizeNotification = [strNum sizeWithFont:font];
    float widthNotification = sizeNotification.width + 12;
    float heightNotification = sizeNotification.height + 6;
    
    if (position == enumVKNotificationAppearPosition_Top_Left) {
        newRect = CGRectMake(-widthNotification/3, -heightNotification/3, widthNotification, heightNotification);
    }
    else if (position == enumVKNotificationAppearPosition_Top_Right) {
        newRect = CGRectMake(frame.size.width - widthNotification*2/3, -heightNotification/3, widthNotification, heightNotification);
    }
    else if (position == enumVKNotificationAppearPosition_Top_Right_Not_Margin_Right) {
        newRect = CGRectMake(frame.size.width - widthNotification, -heightNotification/3, widthNotification, heightNotification);
    }
    
    return newRect;
}

+ (NSString *)getObjectTextWithCount:(NSInteger)count withText:(NSString *)text withHidden:(BOOL)isHidden
{
    if (count == 0 && isHidden) {
        return @"";
    } else if (count <= 1)
        return [NSString stringWithFormat:@"%i %@",count, text];
    else if (count > 1)
        return [NSString stringWithFormat:@"%i %@s",count,text];
    return @"";
}

#pragma mark - Response Alert

void ALERT(NSString* title, NSString* message) {
    if ([[UIAlertView Shared_1Button] isVisible]) {
        return;
    }
    
    if ([UIAlertView Shared_1Button].numberOfButtons == 0) {
        [[UIAlertView Shared_1Button] addButtonWithTitle:STRING_ALERT_OK];
    }
    
    [UIAlertView Shared_1Button].title = title;
    [UIAlertView Shared_1Button].message = message;
    [[UIAlertView Shared_1Button] show];
}

void ALERT_2(NSString* title, NSString* message, id delegate, NSString* other_button, NSString* cancel_button)
{
    if ([[UIAlertView Shared_2Button] isVisible]) {
        return;
    }
    
    if ([UIAlertView Shared_2Button].numberOfButtons == 0) {
        [[UIAlertView Shared_2Button] addButtonWithTitle:other_button];
        [[UIAlertView Shared_2Button] addButtonWithTitle:cancel_button];
    }
    
    [UIAlertView Shared_2Button].delegate = delegate;
    [UIAlertView Shared_2Button].title = title;
    [UIAlertView Shared_2Button].message = message;
    [[UIAlertView Shared_2Button] show];
}

#pragma mark - Date Formatter

+ (NSDate *)dateFromRFC1123String:(NSString *)string
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
	// Does the string include a week day?
	NSString *day = @"";
	if ([string rangeOfString:@","].location != NSNotFound) {
		day = @"EEE, ";
	}
	// Does the string include seconds?
	NSString *seconds = @"";
	if ([[string componentsSeparatedByString:@":"] count] == 3) {
		seconds = @":ss";
	}
	[formatter setDateFormat:[NSString stringWithFormat:@"%@dd MMM yyyy HH:mm%@ z",day,seconds]];
	return [formatter dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
	
    [formatter setDateFormat:[NSString stringWithFormat:@"EEE, dd MMM yyyy HH:mm:ss"]];
	return [formatter stringFromDate:date];
}

+ (NSString *)stringFromDateUseForName:(NSDate *)date
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
	
    [formatter setDateFormat:[NSString stringWithFormat:@"ddMMyyyyHHmmss"]];
	return [formatter stringFromDate:date];

}

+ (NSMutableDictionary *)repairingDictionaryWith:(NSDictionary *)dictionary 
{
    NSMutableDictionary *muDictionary = [[NSMutableDictionary alloc] init];
    NSArray *allKeys = [dictionary allKeys];
    for (int i = 0; i < [allKeys count]; i ++) {
        if ((NSNull *)[dictionary objectForKey:[allKeys objectAtIndex:i]] == [NSNull null]) {
            [muDictionary setObject:@"" forKey:[allKeys objectAtIndex:i]];
        }
        else {
            [muDictionary setObject:[dictionary objectForKey:[allKeys objectAtIndex:i]] forKey:[allKeys objectAtIndex:i]];
        }
    }
    return [muDictionary autorelease];
}

+ (void)scalePickerView:(UIPickerView *)picker toSize:(CGSize)size {
    picker.frame = FRAME(0, 0, picker.frame.size.height * size.width / size.height, picker.frame.size.height);
    float widthScale = size.width / picker.bounds.size.width;
    float heightScale = size.height / picker.bounds.size.height;
    
    CGAffineTransform s0 = CGAffineTransformMakeScale (widthScale, heightScale);
    CGAffineTransform t0 = CGAffineTransformMakeTranslation (picker.bounds.size.width/2, picker.bounds.size.height/2);
    CGAffineTransform t1 = CGAffineTransformMakeTranslation (-picker.bounds.size.width/2, -picker.bounds.size.height/2);
    picker.transform = CGAffineTransformConcat (t0, CGAffineTransformConcat(s0, t1));
}

+ (NSString *)textForDate:(NSString *)stringDate withTime:(BOOL)time
{
    if (time) {        
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
        NSString* localAbbreviation = [localTimeZone abbreviation];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:localAbbreviation]];
        NSDate *now = [NSDate date];
        double deltaSeconds = fabs([[formatter dateFromString:stringDate] timeIntervalSinceDate:now]);
        if(deltaSeconds < 60)
            return @"Just now";
        return formatLastUpdateTimeWithAgoForm([formatter dateFromString:stringDate]);
        
    }else
    {
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
        NSString* localAbbreviation = [localTimeZone abbreviation];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:localAbbreviation]];
        NSDate *date = [formatter dateFromString:stringDate];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        return [formatter stringFromDate:date];
    }
    return nil;
}
#pragma mark - UIColor

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end

@implementation UIImage (Extras)

- (UIImage *)imageByScalingToSize:(CGSize)size withOption:(enumImageScalingType)type {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize targetSize;
    CGRect drawRect;
    
    if (type == enumImageScalingType_Top) {
        targetSize = CGSizeMake(sourceImage.size.width, size.height*sourceImage.size.width/size.width);
        drawRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    }
    else if (type == enumImageScalingType_TargetSize) {
        targetSize = CGSizeMake(sourceImage.size.width, size.height*sourceImage.size.width/size.width);
        drawRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    }
    else if (type == enumImageScalingType_Center_ScaleSize) {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor;
        else
            scaleFactor = widthFactor;
        
        CGFloat scaledWidth  = size.width*scaleFactor;
        CGFloat scaledHeight = size.height*scaleFactor;
        targetSize = CGSizeMake(scaledWidth, scaledHeight);
        
        drawRect = CGRectMake((scaledWidth - sourceImage.size.width)/2, (scaledHeight - sourceImage.size.height)/2, sourceImage.size.width, sourceImage.size.height);
    }
    else if (type == enumImageScalingType_Center_FullSize) {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        CGFloat scaledWidth  = size.width*scaleFactor;
        CGFloat scaledHeight = size.height*scaleFactor;
        targetSize = CGSizeMake(scaledWidth, scaledHeight);
        
        drawRect = CGRectMake(-(sourceImage.size.width - scaledWidth)/2, -(sourceImage.size.height - scaledHeight)/2, sourceImage.size.width, sourceImage.size.height);
    }
    else {
        targetSize = CGSizeMake(size.width*sourceImage.size.height/size.height, sourceImage.size.height);
        drawRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    }
    
    //Qasim 10/11/12
    //NSLog(@"targetSize.width:%f, targetSize.height:%f, drawRect.origin.x:%f, drawRect.origin.y:%f, drawRect.size.width:%f, drawRect.size.height:%f", targetSize.width, targetSize.height, drawRect.origin.x, drawRect.origin.y, drawRect.size.width, drawRect.size.height);
    UIGraphicsBeginImageContext(targetSize);
    
    // draw image
    [sourceImage drawInRect:drawRect];
    
    // grab image
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage;
}

- (NSData*)getImageDataWithMaxSize:(CGSize)size andQuality:(float)quality {
    CGSize origSize = self.size;
    NSInteger newHeight = origSize.height;
    NSInteger newWidth = origSize.width;
    
    NSInteger maxHeight;
    NSInteger maxWidth;
    if (size.width <= 0 || size.height <= 0) {
        maxHeight = HEIGHT_IMAGE_REDUCED_QUALITY_DEFAULT;
        maxWidth = WIDTH_IMAGE_REDUCED_QUALITY_DEFAULT;
    }
    else {
        maxHeight = size.height;
        maxWidth = size.width;
    }
    
    //Image is taller than it is wide or square
    if(origSize.height > origSize.width && origSize.height > maxHeight) {
        float scale = origSize.height/maxHeight;
        newHeight = maxHeight;
        newWidth = origSize.width/scale;
        
    }
    //Image is wider than it is tall
    else if(origSize.width > origSize.height && origSize.width > maxWidth) {
        float scale = origSize.width/maxWidth;
        newWidth = maxWidth;
        newHeight = origSize.height/scale;
        
    }
    //Else image is too small to need resizing
    
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    NSUInteger imgSize = 0;
    
    float imgQuality = 0.0;
    if (quality <= 0) {
        imgQuality = QUALITY_IMAGE_REDUCED_QUALITY_DEFAULT;
    }
    else {
        imgQuality = quality;
    }
    
    NSData* resizedImageData = nil;
    do {
        UIGraphicsBeginImageContext(newSize);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        resizedImageData = UIImageJPEGRepresentation(newImage, imgQuality);
        imgSize = [resizedImageData length];
        imgQuality -= .1;
        
        //NSLog(@"resizedImageData size = %d", imgSize);
    } while (imgSize > 512000 && imgQuality > 0);
    
    return resizedImageData;
}

@end

@implementation NSString (Extras)

- (BOOL)isAvailableWithCheckingType:(enumNSStringExtrasCheckingType)checkingType {
    if (checkingType == enumNSStringExtrasCheckingType_KardBuilder_KardName) {
        if (self.length < 2) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_NAME_TOO_SHORT(@"Kard"));
            return NO;
        }
        else if (self.length > 20) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_NAME_TOO_LONG(@"Kard"));
            return NO;
        }
        
        NSString *regexKardName = @"[a-zA-Z0-9- ]{2,20}"; 
        NSPredicate *preKardName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexKardName]; 
        if (![preKardName evaluateWithObject:self]) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_NAME_MUST_BE_AVAILABLE(@"Kard"));
            return NO;
        }
    }
    else if (checkingType == enumNSStringExtrasCheckingType_KardBuilder_ProfileName) {
        if (self.length < 2) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_NAME_TOO_SHORT(@"Profile"));
            return NO;
        }
        else if (self.length > 20) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_NAME_TOO_LONG(@"Profile"));
            return NO;
        }
        
        NSString *regexKardName = @"[a-zA-Z0-9- ]{2,20}"; 
        NSPredicate *preKardName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexKardName]; 
        if (![preKardName evaluateWithObject:self]) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_NAME_MUST_BE_AVAILABLE(@"Profile"));
            return NO;
        }
    }
    else if (checkingType == enumNSStringExtrasCheckingType_KardBuilder_Profile_FirstName) {
        if (self.length < 1) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_PROFILE_FIRST_NAME_TOO_SHORT);
            return NO;
        }
        else if (self.length > 32) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_PROFILE_FIRST_NAME_TOO_LONG);
            return NO;
        }
        
        NSString *regexKardName = @"[a-zA-Z0-9- ]{1,32}"; 
        NSPredicate *preKardName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexKardName]; 
        if (![preKardName evaluateWithObject:self]) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_PROFILE_FIRST_NAME_MUST_BE_AVAILABLE);
            return NO;
        }
    }
    else if (checkingType == enumNSStringExtrasCheckingType_KardBuilder_Profile_LastName) {
        if (self.length < 1) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_PROFILE_LAST_NAME_TOO_SHORT);
            return NO;
        }
        else if (self.length > 32) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_PROFILE_LAST_NAME_TOO_LONG);
            return NO;
        }
        
        NSString *regexKardName = @"[a-zA-Z0-9- ]{1,32}"; 
        NSPredicate *preKardName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexKardName]; 
        if (![preKardName evaluateWithObject:self]) {
            ALERT(@"", STRING_ALERT_MESSAGE_KARD_BUILDER_PROFILE_LAST_NAME_MUST_BE_AVAILABLE);
            return NO;
        }
    }
    else if (checkingType == enumNSStringExtrasCheckingType_Register_Email) {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:self]) {
            ALERT(@"", kAlertEmailErrorFormat);
            return NO;
        }
    }
    else if (checkingType == enumNSStringExtrasCheckingType_Register_UserName) {
        if (self.length < 2) {
            ALERT(@"", kAlertUserNameErrorLeast);
            return NO;
        }
        else if (self.length > 20) {
            ALERT(@"", kAlertUserNameErrorTooLong);
            return NO;
        }
    }
    else if (checkingType == enumNSStringExtrasCheckingType_Register_Password) {
        if (self.length < kLeastPassword || self.length > kTooLongPassword ) {
            ALERT(@"", kAlertPasswordFormat);
            return NO;
        }
    }
    return YES;
}


@end
