//
//  Utilities.m
//  UIPrototypes
//
//  Created by Vu Minh Trong on 10/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

CGPoint MCGPointAdd(CGPoint point, CGFloat dx, CGFloat dy)
{
    return CGPointMake(point.x+dx, point.y+dy);
}

CGRect MCGRectMake(CGFloat minx, CGFloat miny, CGFloat maxx, CGFloat maxy)
{
    assert(maxx>=minx);
    assert(maxy>=miny);
    return CGRectMake(minx, miny, maxx-minx, maxy-miny);
}

CGFloat MSquaredDistanceBetween(CGPoint pointA, CGPoint pointB)
{
    return (pointA.x - pointB.x) * (pointA.x - pointB.x)
    + (pointA.y - pointB.y) * (pointA.y - pointB.y);
}

UIColor* MFUIColorMakeFromRGBArray(NSArray* rgbArray)
{
    return MFRGB(
                 [(NSNumber*)[rgbArray objectAtIndex:0] intValue],
                 [(NSNumber*)[rgbArray objectAtIndex:1] intValue],
                 [(NSNumber*)[rgbArray objectAtIndex:2] intValue]);
}

UIColor* MFUIColorMakeFromRGBAArray(NSArray* rgbaArray)
{
    return MFRGBA(
                  [(NSNumber*)[rgbaArray objectAtIndex:0] intValue],
                  [(NSNumber*)[rgbaArray objectAtIndex:1] intValue],
                  [(NSNumber*)[rgbaArray objectAtIndex:2] intValue],
                  [(NSNumber*)[rgbaArray objectAtIndex:3] floatValue]);
}

// https://github.com/kevinlawler/NSDate-TimeAgo
NSString* formatLastUpdateTimeWithAgoForm(NSDate* date)
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([date timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    if(deltaSeconds < 5)
    {
        return @"Just now";
    }
    else if(deltaSeconds < 60)
    {
        return [NSString stringWithFormat:@"%d seconds ago", (int)deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return @"A minute ago";
    }
    else if (deltaMinutes < 60)
    {
        return [NSString stringWithFormat:@"%d minutes ago", (int)deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return @"An hour ago";
    }
    else if (deltaMinutes < (24 * 60))
    {
        return [NSString stringWithFormat:@"%d hours ago", (int)floor(deltaMinutes/60)];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return @"Yesterday";
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        return [NSString stringWithFormat:@"%d days ago", (int)floor(deltaMinutes/(60 * 24))];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return @"Last week";
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        return [NSString stringWithFormat:@"%d weeks ago", (int)floor(deltaMinutes/(60 * 24 * 7))];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return @"Last month";
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        return [NSString stringWithFormat:@"%d months ago", (int)floor(deltaMinutes/(60 * 24 * 30))];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return @"Last year";
    }
    return [NSString stringWithFormat:@"%d years ago", (int)floor(deltaMinutes/(60 * 24 * 365))];
}