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

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, APIRequesterProtocol, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bankBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bankTypeBtn;
@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *directionBtn;
@property (weak, nonatomic) IBOutlet BBTableView *bankTableView;

- (IBAction)refreshTouchUpInside:(UIBarButtonItem *)sender;
- (IBAction)pickerCancelTouchUpInside:(id)sender;
- (IBAction)pickerDoneTouchUpInside:(id)sender;
- (IBAction)bankBtnTouchUpInside:(id)sender;

- (IBAction)bankTypeBtnTouchUpInside:(id)sender;
- (IBAction)directionBtnTouchUpInside:(UIButton *)sender;


@end
