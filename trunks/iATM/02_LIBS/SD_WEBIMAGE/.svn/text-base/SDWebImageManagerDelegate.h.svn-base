/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

@class SDWebImageManager;

#define enumWebImageScaleOption_ScaleToFill                 @"enumWebImageScaleOption_ScaleToFill"
#define enumWebImageScaleOption_FullFill                    @"enumWebImageScaleOption_FullFill"
#define enumWebImageScaleOption_Fill                        @"enumWebImageScaleOption_Fill"
#define enumWebImageScaleOption_ScaleToWidth_Top            @"enumWebImageScaleOption_ScaleToWidth_Top"
#define enumWebImageScaleOption_ScalePhotoToSize            @"enumWebImageScaleOption_ScalePhotoToSize"
#define enumWebImageScaleOption_ScalePhotoToSizeLarger      @"enumWebImageScaleOption_ScalePhotoToSizeLarger"
#define enumWebImageScaleOption_ScalePhotoFullSize          @"enumWebImageScaleOption_ScalePhotoFullSize"
#define enumWebImageScaleOption_ScalePhotoCenterFullSize          @"enumWebImageScaleOption_ScalePhotoCenterFullSize"

@protocol SDWebImageManagerDelegate <NSObject>

@optional

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image;
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error;

@end
