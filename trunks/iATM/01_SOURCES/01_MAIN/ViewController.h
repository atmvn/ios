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
#import "BBTableView.h"

#define METERS_PER_MILE 1609.344
#define NUMBER_OF_REQUEST_ATM 100

@class UIGlossyButton;

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, APIRequesterProtocol, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet BBTableView *bankTableView;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationBtn;

@property (strong, nonatomic) UIButton *bankBtn;
@property (retain, nonatomic) UIButton *refreshBtn;

- (IBAction)showCurrentLocation:(id)sender;


@end
