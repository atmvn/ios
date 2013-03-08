//
//  ViewController.m
//  iATM
//
//  Created by Tai Truong on 3/5/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "ViewController.h"
#import "AppViewController.h"

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
    currentLocation = nil;
    
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
    if(newLocation != currentLocation) {
        currentLocation = newLocation;
        // TODO: call API for update location
        [self requestListNearestATM];
    }
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

- (void)requestListNearestATM
{
    CGFloat longtitude = 106.63896;
    CGFloat lattitude = 10.827257;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[NSString stringWithFormat:@"%f", longtitude] forKey:STRING_REQUEST_KEY_LONGTITUDE];
    [params setValue:[NSString stringWithFormat:@"%f", lattitude] forKey:STRING_REQUEST_KEY_LATTITUDE];
    [params setValue:[NSString stringWithFormat:@"%d", NUMBER_OF_REQUEST_ATM] forKey:STRING_REQUEST_KEY_NUMBER];
    
    [[AppViewController Shared] isRequesting:YES andRequestType:ENUM_API_REQUEST_TYPE_GET_NEAREST_ATM andFrame:FRAME(0, 0, WIDTH_IPHONE, HEIGHT_IPHONE)];
    [_APIRequester requestWithType:ENUM_API_REQUEST_TYPE_GET_NEAREST_ATM andRootURL:STRING_REQUEST_URL_GET_NEAREST_ATM andPostMethodKind:YES andParams:params andDelegate:self];
}

#pragma mark - APIRequesterProtocol
- (void)requestFinished:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type {
    
    [[AppViewController Shared] isRequesting:NO andRequestType:type andFrame:CGRectZero];
    
    NSError *error;
    SBJSON *sbJSON = [SBJSON new];
    
    if (![sbJSON objectWithString:[request responseString] error:&error] || request.responseStatusCode != 200 || !request) {
        //        if (![ASIHTTPRequest isNetworkReachable]) {
        //            ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, STRING_ALERT_SERVER_ERROR);
        //        }
        ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, [[sbJSON objectWithString:[request responseString] error:&error] objectForKey:STRING_RESPONSE_KEY_MSG]);
        return;
    }
    
    NSMutableDictionary *dicJson = [sbJSON objectWithString:[request responseString] error:&error];
    if (type == ENUM_API_REQUEST_TYPE_GET_NEAREST_ATM) {
        NSMutableArray *atmList = [dicJson objectForKey:STRING_RESPONSE_KEY_RESULTS];
        NSLog(@"%@", atmList);
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type {
    NSLog(@" requestFailed %@ ", request.responseString);
    
    [[AppViewController Shared] isRequesting:NO andRequestType:type andFrame:CGRectZero];
    
    if (![ASIHTTPRequest isNetworkReachable]) {
        ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, STRING_ALERT_CONNECTION_ERROR);
    }
}
@end
