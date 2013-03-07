//
//  Utilities.h
//  UIPrototypes
//
//  Created by Vu Minh Trong on 10/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MCreatePNGUIImage(___name___) \
[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(___name___) ofType:@"png"]]


#define MCreatePNGCGImage(___name___) \
[MCreatePNGUIImage(___name___) CGImage]


#define MPNGUIImage(___name___) \
MCreatePNGUIImage(___name___)


#define MPNGCGImage(___name___) \
[MPNGUIImage(___name___) CGImage]


#define MAngleToDegree(___val___)\
((___val___) / 180.0 * M_PI)

#define MDegreeToAngle(___val___)\
((___val___) * (180.0 / M_PI))

CGPoint MCGPointAdd(CGPoint point, CGFloat dx, CGFloat dy);

CGRect MCGRectMake(CGFloat minx, CGFloat miny, CGFloat maxx, CGFloat maxy);

CGFloat MSquaredDistanceBetween(CGPoint pointA, CGPoint pointB);

UIColor* MFUIColorMakeFromRGBArray(NSArray* rgbArray);
UIColor* MFUIColorMakeFromRGBAArray(NSArray* rgbaArray);

#define MFLocalizedString(key,comment) NSLocalizedString((key),(comment))
#define MFLocalizedStringFromTable(key,tbl,comment) NSLocalizedStringFromTable((key), (tbl), (comment))
#define MFLocalizedStringFromTableInBundle(key,tbl,bundle,comment) NSLocalizedStringFromTableInBundle((key),(tbl),(bundle),(comment))
#define MFLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) NSLocalizedStringWithDefaultValue((key), (tbl), (bundle), (val), (comment))

#define MFRGB(r, g, b)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define MFRGBA(r, g, b, a)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define MFCGRGB(r, g, b)        [MFRGB(r, g, b) CGColor]
#define MFCGRGBA(r, g, b, a)    [MFRGBA(r, g, b, a)] CGColor]

#define methodNotImplemented() \
@throw [NSException exceptionWithName:NSInvalidArgumentException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] \
userInfo:nil]

NSString* formatLastUpdateTimeWithAgoForm(NSDate* date);
