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
#import "BBCell.h"
#import <QuartzCore/QuartzCore.h>

#define REQUEST_URL_GOOGLE_DIRECTION_API @"http://maps.googleapis.com/maps/api/directions/json"
#define KEY_TITLE @"bankTitle"
#define KEY_IMAGE @"image"

@interface ViewController () <NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    MKPolyline *_polyLine;
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
    
    BankItem *_selectedBankItem;
    NSMutableArray *mDataSource;
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
    [self setDirectionBtn:nil];
    [self setBankTableView:nil];
    [super viewDidUnload];
}

-(void)updateListBank
{
    [_listBank removeAllObjects];
    [self performSearchKardForBankName:@"" withType:enumBankType_Num];
    for (BankInfosModule *info in self.fetchedResultsController.fetchedObjects)
    {
        NSLog(@"name = %@", info.bankNameEN);
        if (![_listBank containsObject:info.bankNameEN]) {
            [_listBank addObject:info.bankNameEN];
        }
    }
    _listBank = [NSMutableArray arrayWithArray:[_listBank sortedArrayUsingSelector:@selector(compare:)]];
    NSLog(@"%@", _listBank);
    // reload bank table
    [self loadDataSource:_listBank];
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
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(bankNameEN ==[c] %@) AND (banktype ==[c] %@)", _searchStr, _searchType];
        [fetchRequest setPredicate:pred];
    }
    else if (![_searchStr isEqualToString:@""])
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"bankNameEN ==[c] %@", _searchStr];
        [fetchRequest setPredicate:pred];
    }
    else if (![_searchType isEqualToString:@""])
    {
        // init predicate to search
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"banktype ==[c] %@", _searchType];
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

-(void)getDirectionFrom:(CLLocationCoordinate2D)source to:(CLLocationCoordinate2D)destination
{
    NSString *url = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true",REQUEST_URL_GOOGLE_DIRECTION_API, source.latitude, source.longitude, destination.latitude, destination.longitude];
    [[AppViewController Shared] isRequesting:YES andRequestType:ENUM_API_REQUEST_TYPE_GET_DIRECTION andFrame:FRAME(0, 0, WIDTH_IPHONE, HEIGHT_IPHONE)];
    [_APIRequester requestWithType:ENUM_API_REQUEST_TYPE_GET_DIRECTION andRootURL:url andPostMethodKind:NO andParams:nil andDelegate:self];
}

-(void)updateDirectionWithData:(NSDictionary*)data
{
    NSDictionary *route = [[data objectForKey:@"routes"] objectAtIndex:0];
    NSString *allPolylines = [[route objectForKey:@"overview_polyline"] objectForKey:@"points"];
    NSMutableArray *_path = [self decodePolyLine:allPolylines];
    NSInteger numberOfSteps = _path.count;
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [_path objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        coordinates[index] = coordinate;
    }
    
    [_mapView removeOverlay:_polyLine];
    _polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [_mapView addOverlay:_polyLine];
    
    // hide button request direction
    self.directionBtn.hidden = YES;
}

- (NSMutableArray *)decodePolyLine:(NSString *)encodedStr
{
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    
    while (index < len)
    {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    
    return array;
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
        
        // update list bank name
        [self updateListBank];
        // fetch data
        [self performSearchKardForBankName:_selectedBank withType:_selectedType];
        // reload interface
        [self loadInterface];
    }
    else if (type == ENUM_API_REQUEST_TYPE_GET_DIRECTION)
    {
        NSLog(@"Direction = %@", dicJson);
        [self updateDirectionWithData:dicJson];
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

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    if ([view.annotation isKindOfClass:[BankItem class]]) {
        self.directionBtn.hidden = NO;
        _selectedBankItem = (BankItem*)view.annotation;
    }
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
    if ([view.annotation isKindOfClass:[BankItem class]]) {
        self.directionBtn.hidden = YES;
        _selectedBankItem = nil;
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth = 5;
    overlayView.strokeColor = [UIColor redColor];
    overlayView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5f];
    return overlayView;
}
#pragma mark - Utilities

- (IBAction)refreshTouchUpInside:(UIBarButtonItem *)sender {
    currentLocation = nil;
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
    
    [self performSearchKardForBankName:_selectedBank withType:_selectedType];
    // reload list ATM on map
    [self loadInterface];
}

- (IBAction)bankBtnTouchUpInside:(id)sender {

    _activeList = _listBank;
    // show bank list
    CGRect r = self.bankTableView.frame;
    r.origin.y = HEIGHT_IPHONE;
    self.bankTableView.frame = r;
    self.bankTableView.hidden = NO;
    r.origin.y = 0;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bankTableView.frame = r;
    } completion:nil];
}
- (IBAction)bankTypeBtnTouchUpInside:(id)sender {
    [self showPickerWithData:_listBankType];
}

- (IBAction)directionBtnTouchUpInside:(UIButton *)sender {
    if (_selectedBankItem) {
        [self getDirectionFrom:currentLocation.coordinate to:_selectedBankItem.location];
    }
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

-(void)doubleTapOnCell:(UITapGestureRecognizer*)recognizer
{
    // close table view
    CGRect r = self.bankTableView.frame;
    r.origin.y = HEIGHT_IPHONE;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bankTableView.frame = r;
    } completion:^(BOOL finished) {
        self.bankTableView.hidden = YES;
    }];
    
    _selectedRow = recognizer.view.tag;
    
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
    
    [self performSearchKardForBankName:_selectedBank withType:_selectedType];
    // reload list ATM on map
    [self loadInterface];
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



#pragma mark UITableViewDelegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_listBank count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *test = @"table";
    BBCell *cell = (BBCell*)[tableView dequeueReusableCellWithIdentifier:test];
    if( !cell )
    {
        cell = [[BBCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:test];
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapOnCell:)];
        tapgesture.numberOfTapsRequired = 2;
        [cell addGestureRecognizer:tapgesture];
    }
    cell.tag = indexPath.row;
    NSDictionary *info = [mDataSource objectAtIndex:indexPath.row ];
    [cell setCellTitle:[info objectForKey:KEY_TITLE]];
    [cell setIcon:[info objectForKey:KEY_IMAGE]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select = %d", indexPath.row);
}

//read the data from the plist and alos the image will be masked to form a circular shape
- (void)loadDataSource:(NSMutableArray*)listBanks
{
    mDataSource = [[NSMutableArray alloc] init];
    
    NSString *imageName = @"vietcombank.png";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //generate image clipped in a circle
        for( NSString * bankName in listBanks )
        {
            NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithCapacity:2];
            [info setValue:bankName forKey:KEY_TITLE];
            UIImage *image = [UIImage imageNamed:imageName];
            UIImage *finalImage = nil;
            UIGraphicsBeginImageContext(image.size);
            {
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGAffineTransform trnsfrm = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, -1.0));
                trnsfrm = CGAffineTransformConcat(trnsfrm, CGAffineTransformMakeTranslation(0.0, image.size.height));
                CGContextConcatCTM(ctx, trnsfrm);
                CGContextBeginPath(ctx);
                CGContextAddEllipseInRect(ctx, CGRectMake(0.0, 0.0, image.size.width, image.size.height));
                CGContextClip(ctx);
                CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, image.size.width, image.size.height), image.CGImage);
                finalImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            [info setObject:finalImage forKey:KEY_IMAGE];
            
            [mDataSource addObject:info];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bankTableView reloadData];
            // [self setupShapeFormationInVisibleCells];
        });
    });
}

@end
