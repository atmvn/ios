//
//  ViewController.m
//  iATM
//
//  Created by Tai Truong on 3/5/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "ViewController.h"
#import "AppViewController.h"
#import "BankItem.h"

@interface ViewController ()
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    APIRequester                            *_APIRequester;
    NSMutableArray      *_listBankItems;
    
    NSMutableArray      *_listBank; // list available bank in current area (city, provice)
    NSMutableArray      *_listBankType; // ATM, Tradding place
    NSArray             *_activeList; // temporaty variable
    NSInteger           _selectedRow;
    NSString            *_selectedBank;
    enumBankType        _selectedType;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _APIRequester = [APIRequester new];
    currentLocation = nil;
    _listBankItems = [[NSMutableArray alloc] init];
    _selectedBank = nil;
    _selectedType = enumBankType_Num;
    // init bank list, and bank type
    _listBank = [[NSMutableArray alloc] initWithObjects:
                 @"Tất Cả Ngân Hàng",
                 @"ACB",
                 @"Vietcombank",
                 @"Techcombank",
                 nil];
    _listBankType = [[NSMutableArray alloc] initWithObjects:@"Mọi Loại", @"ATM", @"Điểm Giao Dịch", nil];
    CGRect r = self.pickerContainerView.frame;
    r.origin.y = self.view.frame.size.height;
    self.pickerContainerView.frame = r;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self;
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
    [self setPickerContainerView:nil];
    [self setPickerView:nil];
    [self setBankBtn:nil];
    [self setBankTypeBtn:nil];
    [super viewDidUnload];
}

-(void)loadInterface
{
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }

//    [_mapView addAnnotations:_listBankItems];
    for (BankItem *item in _listBankItems)
    {
        if(_selectedBank && ![_selectedBank isEqualToString:item.bankName])
            continue;
        if (_selectedType != enumBankType_Num && _selectedType != item.type) {
            continue;
        }
        
        [self.mapView addAnnotation:item];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(currentLocation == nil) {
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
    if(!currentLocation) return;
//    CGFloat longtitude = 106.63896;
//    CGFloat lattitude = 10.827257;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] forKey:STRING_REQUEST_KEY_LONGTITUDE];
    [params setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude] forKey:STRING_REQUEST_KEY_LATTITUDE];
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
//        ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, [[sbJSON objectWithString:[request responseString] error:&error] objectForKey:STRING_RESPONSE_KEY_MSG]);
        return;
    }
    
    NSMutableDictionary *dicJson = [sbJSON objectWithString:[request responseString] error:&error];
    if (type == ENUM_API_REQUEST_TYPE_GET_NEAREST_ATM) {
        NSMutableArray *atmList = [dicJson objectForKey:STRING_RESPONSE_KEY_RESULTS];
        NSLog(@"%@", atmList);
        [_listBankItems removeAllObjects];
        for (NSDictionary *dataDic in atmList) {
            BankItem *bankItem = [[BankItem alloc] initWithData:dataDic];
            [_listBankItems addObject:bankItem];
        }
        [self loadInterface];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type {
    NSLog(@" requestFailed %@ ", request.responseString);
    
    [[AppViewController Shared] isRequesting:NO andRequestType:type andFrame:CGRectZero];
    
    if (![ASIHTTPRequest isNetworkReachable]) {
        ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, STRING_ALERT_CONNECTION_ERROR);
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"BankItemID";
    if ([annotation isKindOfClass:[BankItem class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}
- (IBAction)refreshTouchUpInside:(UIBarButtonItem *)sender {
    [self requestListNearestATM];
}

- (IBAction)pickerCancelTouchUpInside:(id)sender {
    [self closePickerView];
}

- (IBAction)pickerDoneTouchUpInside:(id)sender {
    [self closePickerView];
    NSString *selectedStr = [_activeList objectAtIndex:_selectedRow];
    UIBarButtonItem *tempBtn = self.bankBtn;
    if (_activeList == _listBankType) {
        tempBtn = self.bankTypeBtn;
        _selectedType = _selectedRow == 0 ? enumBankType_Num : (_selectedRow - 1);
    }
    else {
        _selectedBank = _selectedRow == 0 ? nil : selectedStr;
    }
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [tempBtn setTitle:selectedStr];
    } completion:nil];
    
    // reload list ATM on map
    [self loadInterface];
}

- (IBAction)bankBtnTouchUpInside:(id)sender {
    // show bank picker
    [self showPickerWithData:_listBank];
}
- (IBAction)bankTypeBtnTouchUpInside:(id)sender {
    [self showPickerWithData:_listBankType];
}

-(void)showPickerWithData:(NSArray*)data
{
    // reload data
    _activeList = data;
    [self.pickerView reloadAllComponents];
    
    CGRect r = self.pickerContainerView.frame;
    r.origin.y = self.view.bounds.size.height - r.size.height;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
        self.pickerContainerView.frame = r;
    } completion:nil];
}

-(void)closePickerView
{
    CGRect r = self.pickerContainerView.frame;
    r.origin.y = self.view.bounds.size.height;
    [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
        self.pickerContainerView.frame = r;
    } completion:nil];
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 260.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 46.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(!_activeList) return 0;
    
	NSInteger rows = [_activeList count];
	return rows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [_activeList objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedRow = row;
}

@end
