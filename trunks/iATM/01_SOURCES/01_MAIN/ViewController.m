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
#import "BankInfosModule.h"

@interface ViewController () <NSFetchedResultsControllerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    APIRequester                            *_APIRequester;
    
    NSMutableArray      *_listBank; // list available bank in current area (city, provice)
    NSMutableArray      *_listBankType; // ATM, Tradding place
    NSArray             *_activeList; // temporaty variable
    NSInteger           _selectedRow;
    NSString            *_selectedBank;
    enumBankType        _selectedType;
    
    // search string
    NSString *_searchStr;
    NSString *_searchType;
}

@property (retain, nonatomic) NSFetchedResultsController    *fetchedResultsController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _APIRequester = [APIRequester new];
    currentLocation = nil;
    _selectedBank = nil;
    _selectedType = enumBankType_Num;
    _searchStr = @"";
    _searchType = @"";
    
    
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
//    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(_lattitude, _longtitude)];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_locationManager startUpdatingLocation];
    
    // for testing
//    currentLocation = [[CLLocation alloc] initWithLatitude:_lattitude longitude:_longtitude];
//    [self requestListNearestATM];
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

    for (BankInfosModule *info in self.fetchedResultsController.fetchedObjects) {
        BankItem *item = [[BankItem alloc] init];
        item.itemID = info.itemID;
        item.address = info.address;
        item.bankName = info.bankNameEN;
        if([info.banktype isEqualToString:@"ATM"])
        {
            item.type = enumBankType_ATM;
        }
        item.city = info.city;
        item.locationName = info.locationname;
        item.phoneNumber = info.phoneNumber;
        item.workingTime = info.workingtime;
        item.distance = [info.distance floatValue];
        CGFloat latitude = [info.latitude floatValue];
        CGFloat longtitude = [info.longtitude floatValue];
        item.location = CLLocationCoordinate2DMake(latitude, longtitude);
        
        [self.mapView addAnnotation:item];
    }
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BankInfosModule" inManagedObjectContext:[[AppViewController Shared] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"bankID"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    //    [fetchRequest setFetchBatchSize:20];
    
    if (![_searchStr isEqualToString:@""] && ![_searchType isEqualToString:@""])
    {
        // init predicate to search
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(bankNameEN like %@) AND (banktype like %@)", _searchStr, _searchType];
        [fetchRequest setPredicate:pred];
    }
    else if (![_searchStr isEqualToString:@""])
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"bankNameEN like %@", _searchStr];
        [fetchRequest setPredicate:pred];
    }
    else if (![_searchType isEqualToString:@""])
    {
        // init predicate to search
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"banktype like %@", _searchType];
        [fetchRequest setPredicate:pred];
    }
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[AppViewController Shared] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)performSearchKardForBankName:(NSString*)name withType:(enumBankType)type
{
    _searchStr = name ? name : @"";
    _searchType = type == enumBankType_ATM ? @"ATM" : @"";
    _fetchedResultsController = nil;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
    }
    
    // reload table
//    [self reloadInterface];
}

#pragma mark - Database Methods
- (void)deleteAllBankData
{
    ////VKLog(@"deleteAllKard-0");
    int n = [[self.fetchedResultsController fetchedObjects] count];
    for (int i = 0; i < n; i++)
    {
        BankInfosModule *info = [[self.fetchedResultsController fetchedObjects] objectAtIndex:i];
        [[[AppViewController Shared] managedObjectContext] deleteObject:info];
    }
    [[AppViewController Shared] saveContext];
}

- (void)insertKardDataFromServer:(NSMutableArray *)dataList
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    for (NSMutableDictionary *dict in dataList) {
        
        NSMutableDictionary *dicJson = [SupportFunction normalizeDictionary:dict];
        
        BankInfosModule *kardsItem = [NSEntityDescription insertNewObjectForEntityForName:@"BankInfosModule" inManagedObjectContext:[[AppViewController Shared] managedObjectContext]];
        kardsItem.distance = [dicJson objectForKey:@"dis"];
        NSDictionary *obj = [dicJson objectForKey:@"obj"];
        kardsItem.itemID = [obj objectForKey:@"_id"];
        kardsItem.address = [obj objectForKey:@"address"];
        kardsItem.bankID = [obj objectForKey:@"bankID"];
        kardsItem.bankNameEN = [obj objectForKey:@"bankNameEN"];
        kardsItem.bankNameVN = [obj objectForKey:@"bankNameVN"];
        kardsItem.banktype = [obj objectForKey:@"banktype"];
        kardsItem.city = [obj objectForKey:@"city"];
        kardsItem.locationname = [obj objectForKey:@"locationname"];
        kardsItem.phoneNumber = [obj objectForKey:@"phones"];
        kardsItem.workingtime = [obj objectForKey:@"workingtime"];
        kardsItem.latitude = [[obj objectForKey:@"loc"] objectAtIndex:1];
        kardsItem.longtitude = [[obj objectForKey:@"loc"] objectAtIndex:0];
    }
    
    [[AppViewController Shared] saveContext];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
		exit(-1);
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
        // delete all bank in database first
        [self deleteAllBankData];
        // add new bank data
        [self insertKardDataFromServer:atmList];
        // fetch data
        [self performSearchKardForBankName:_selectedBank withType:_selectedType];
        // reload interface
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
