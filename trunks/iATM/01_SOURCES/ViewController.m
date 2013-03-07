//
//  ViewController.m
//  iATM
//
//  Created by Tai Truong on 3/5/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    APIRequester                            *_APIRequester;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _APIRequester = [APIRequester new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    
    // TODO: call API for update location
}

- (void)applicationWillResignActive
{
    if (YES)
    {
        [_locationManager stopUpdatingLocation];
    }
}

- (void)applicationDidBecomeActive
{
    [_locationManager startUpdatingLocation];
}
@end
