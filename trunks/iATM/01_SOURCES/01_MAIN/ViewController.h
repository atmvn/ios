//
//  ViewController.h
//  iATM
//
//  Created by Tai Truong on 3/5/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "APIRequester.h"

#define METERS_PER_MILE 1609.344
#define NUMBER_OF_REQUEST_ATM 10

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, APIRequesterProtocol>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
