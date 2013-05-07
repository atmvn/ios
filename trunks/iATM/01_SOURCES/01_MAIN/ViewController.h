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
#define NUMBER_OF_REQUEST_ATM 10
#define NUMBER_OF_VISIBLE_ITEM 15
#define MAXIMUM_DISTANCE 2000.0 // 3km
#define MAXIMUM_DISTANCE_USER_REACHABLE 5000.0 // 5km

@class UIGlossyButton;

typedef enum {
    enumATMDataRequestType_ListBank = 0,
    enumATMDataRequestType_NearestATM,
    enumATMDataRequestType_ATMOfBank,
    enumATMDataRequestType_Num
}enumATMDataRequestType;

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, APIRequesterProtocol, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet BBTableView *bankTableView;
@property (weak, nonatomic) IBOutlet UIView *bankTableContainer;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationBtn;

@property (strong, nonatomic) UIButton *bankBtn;
@property (retain, nonatomic) UIButton *refreshBtn;

- (IBAction)showCurrentLocation:(id)sender;

- (IBAction)closeBankTableTouchUpInside:(UIButton *)sender;


@end
