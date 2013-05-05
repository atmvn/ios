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
#import "UIView+Transition.h"
#import "BankDetailView.h"
#import "GradientPolylineView.h"
#import "TTAutoCollapseMenu.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"

#define REQUEST_URL_GOOGLE_DIRECTION_API @"http://maps.googleapis.com/maps/api/directions/json"
#define KEY_TITLE @"bankTitle"
#define KEY_IMAGE @"image"

#define NUMBER_OF_VISIBLE_ITEM 10
#define MAXIMUM_DISTANCE 3000 // 3km


@interface ViewController () <NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, BankDetailViewDelegate, TTAutoCollapseMenuDelegate>
{
//    CLLocationManager *_locationManager;
//    CLLocation *currentLocation;
    MKPolyline *_polyLine;
    APIRequester                            *_APIRequester;
    APIRequester                            *_ListBankRequester;
    
    NSMutableDictionary *_bankName2BankID;
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
    
    CLLocationCoordinate2D _centralPoint;
    CLLocationDistance _radiusMeters;
    
    BankDetailView *_bankDetailView;
    
    BOOL _isRefreshing;
    
    NSMutableArray *_arrMenuImages;
}

@property (retain, nonatomic) TTAutoCollapseMenu *actionHeaderView;

@property (retain, nonatomic) NSFetchedResultsController    *fetchedResultsController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _APIRequester = [APIRequester new];
    _ListBankRequester = [APIRequester new];
//    currentLocation = nil;
    _selectedRow = 0;
    _selectedBank = nil;
    _selectedType = enumBankType_Num;
    _searchStr = @"";
    _searchType = @"";
    _bankDetailView = [[BankDetailView alloc] init];
    _bankDetailView.delegate = self;
    _bankDetailView.movingView = self.currentLocationBtn;
    _bankName2BankID = nil;
    
    // init bank type menu
    _arrMenuImages = [[NSMutableArray alloc] initWithObjects:@"allBtn", @"atmBtn", @"bankBtn", nil];
    
    self.actionHeaderView = [[TTAutoCollapseMenu alloc] initWithFrame:self.view.bounds atPosition:enumTTAutoCollapseMenuPosition_Bottom];
    // Set action items, and previous items will be removed from action picker if there is any.
    self.actionHeaderView.borderGradientHidden = NO;
	self.actionHeaderView.delegate = self;
    [self.view addSubview:self.actionHeaderView];
    [self.actionHeaderView reloadData];
    
    // add other button
    _refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 3, AUTOEXPANDMENU_ITEM_WIDTH + 4, AUTOEXPANDMENU_ITEM_HEIGHT + 4)];
    [_refreshBtn setShadow:[UIColor blackColor] opacity:0.7 offset:CGSizeMake(0, 1) blurRadius: 2];
    [_refreshBtn setImage:[UIImage imageNamed:@"aqua_land_2_refresh.png"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionHeaderView addSubview:_refreshBtn];
    
    _bankBtn = [[UIGlossyButton alloc ]initWithFrame:CGRectMake(55, 5, 210, 40)];
	[_bankBtn useWhiteLabel: YES]; _bankBtn.tintColor = [UIColor doneButtonColor];
	[_bankBtn setShadow:[UIColor blackColor] opacity:0.7 offset:CGSizeMake(0, 1) blurRadius: 2];
    [(UIGlossyButton*)_bankBtn setGradientType:kUIGlossyButtonGradientTypeLinearSmoothBrightToNormal];
    [(UIGlossyButton*)_bankBtn setButtonCornerRadius:20.0f];
    [self.bankBtn setTitle:@"Tất Cả" forState:UIControlStateNormal];
    [self.bankBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];

    [_bankBtn addTarget:self action:@selector(bankBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionHeaderView addSubview:_bankBtn];
    
    // add bank detail view
    [self.view addSubview:_bankDetailView];
    
    // init bank list, and bank type
    _listBank = [[NSMutableArray alloc] initWithObjects:
                 @"Tất Cả",
                 @"ACB",
                 @"Vietcombank",
                 @"Techcombank",
                 nil];
    _listBankType = [[NSMutableArray alloc] initWithObjects:@"Mọi Loại", @"ATM", @"Điểm Giao Dịch", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self.bankTableView setContentInset:UIEdgeInsetsMake(100, 0, 100, 0)];
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    // load list Bank
    [self requestListBanks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setBankBtn:nil];
    [self setBankTableView:nil];
    [self setCurrentLocationBtn:nil];
    [self setRefreshBtn:nil];
    [super viewDidUnload];
}

-(void)updateListBank
{
    _listBank = [NSMutableArray arrayWithArray: [_bankName2BankID.allKeys sortedArrayUsingSelector:@selector(compare:)]];
    
    if (_listBank.count > 0) {
        [_listBank insertObject:@"Tất Cả" atIndex:0];
    }
    NSLog(@"%@", _listBank);
    // reload bank table
    [self loadDataSource:_listBank];
}

-(void)loadInterface
{
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }

    NSMutableArray *listAnotation = [[NSMutableArray alloc] initWithCapacity:self.fetchedResultsController.fetchedObjects.count];
    int numItemAvailable = MIN(self.fetchedResultsController.fetchedObjects.count, NUMBER_OF_VISIBLE_ITEM);
    
    for (NSInteger i =0; i < numItemAvailable; i++) {
        BankInfosModule *info = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
        BankItem *item = [[BankItem alloc] init];
        item.itemID = info.itemID;
        item.address = info.address;
        item.bankName = info.bankNameEN;
        if([info.banktype isEqualToString:@"ATM"])
        {
            item.type = enumBankType_ATM;
        }
        else {
            item.type = enumBankType_Branch;
        }
        item.city = info.city;
        item.locationName = info.locationname;
        item.phoneNumber = info.phoneNumber;
        item.workingTime = info.workingtime;
        item.distance = [info.distance doubleValue];
        double latitude = [info.latitude doubleValue];
        double longtitude = [info.longtitude doubleValue];
        item.location = CLLocationCoordinate2DMake(latitude, longtitude);
        NSLog(@"A %d loc = (%f, %f)", i, longtitude, latitude);
        [listAnotation addObject:item];
    }

//    NSLog(@"Number Item = %d", listAnotation.count);
    
    // add anotation to map view
    [self.mapView addAnnotations:listAnotation];
    
    // zoom to visual region
    MKCoordinateRegion region = [self createZoomRegionFromCentralPointAndRadius :listAnotation];
    
    // Zoom and scale to central point
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    [_mapView reloadInputViews];
}

-(void)reloadMapWithAdditionItems:(NSArray*)additionItems
{
    for (NSMutableDictionary *dict in additionItems) {
        NSMutableDictionary *dicJson = [SupportFunction normalizeDictionary:dict];
        NSDictionary *obj = [dicJson objectForKey:@"obj"];
        NSString *itemID = [obj objectForKey:@"_id"];
        NSString *bankName = [obj objectForKey:@"bankNameEN"];
        
        // check exist
        BOOL isExisted = NO;
        for (BankItem *anotation in self.mapView.annotations)
        {
            if ([anotation isKindOfClass:[BankItem class]]) {
                if ([anotation.bankName isEqualToString:bankName] && [anotation.itemID isEqualToString:itemID]) {
                    isExisted = YES;
                }
            }
        }
        
        // if it is NOT existed, insert to Map
        if (!isExisted) {
            BankItem *item = [[BankItem alloc] init];
            item.itemID = itemID;
            item.address = [obj objectForKey:@"address"];
            item.bankName = bankName;
            NSString *bankType = [obj objectForKey:@"banktype"];
            if([bankType isEqualToString:@"ATM"])
            {
                item.type = enumBankType_ATM;
            }
            else {
                item.type = enumBankType_Branch;
            }
            item.city = [obj objectForKey:@"city"];
            item.locationName = [obj objectForKey:@"locationname"];
            item.phoneNumber = [obj objectForKey:@"phones"];
            item.workingTime = [obj objectForKey:@"workingtime"];
            item.distance = [[dicJson objectForKey:@"dis"] doubleValue];
            double longtitude = [[[obj objectForKey:@"loc"] objectAtIndex:0] doubleValue];
            double latitude = [[[obj objectForKey:@"loc"] objectAtIndex:1] doubleValue];
            item.location = CLLocationCoordinate2DMake(latitude, longtitude);
            
            NSLog(@"ADDED annotation loc = (%f, %f)", longtitude, latitude);
            [self.mapView addAnnotation:item];
        }
        else {
            NSLog(@"annotation is existed");
        }
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
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"  ascending:YES selector:@selector(compare:)];
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
    if (type == enumBankType_ATM)
        _searchType = @"ATM";
    else if (type == enumBankType_Branch)
        _searchType = @"BRANCH";
    else
        _searchType = @"";

    _fetchedResultsController = nil;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
    }
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
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        [array addObject:location];
    }
    
    return array;
}


#pragma mark - Database Methods
- (void)deleteAllBankData
{
    ////VKLog(@"deleteAllKard-0");
    [self performSearchKardForBankName:@"" withType:enumBankType_Num];
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
    
    // if bank item is NOT existed in local DB, insert it (same bankID, Type, location)
    // else, ignore it
    
    // get available items in local DB
    [self performSearchKardForBankName:_selectedBank withType:_selectedType];
    
    for (NSMutableDictionary *dict in dataList) {
        
        NSMutableDictionary *dicJson = [SupportFunction normalizeDictionary:dict];
        NSDictionary *obj = [dicJson objectForKey:@"obj"];
        NSString *_id = [obj objectForKey:@"_id"];
        NSString *bankID = [obj objectForKey:@"bankID"];
        NSString *bankType = [obj objectForKey:@"banktype"];
        double lon = [[[obj objectForKey:@"loc"] objectAtIndex:0] doubleValue];
        double lat = [[[obj objectForKey:@"loc"] objectAtIndex:1] doubleValue];
        // check exist
        BOOL isExisted = NO;
        for (BankInfosModule *item in self.fetchedResultsController.fetchedObjects)
        {
            if ([item.itemID isEqualToString:_id] || ([item.bankID isEqualToString:bankID] && [item.banktype isEqualToString:bankType] && [item.longtitude doubleValue] ==lon && [item.latitude doubleValue] == lat)) {
                isExisted = YES;
                NSLog(@"DB Duplicated loc (%f, %f)", lon, lat);
                break;
            }
        }
        
        // if it is NOT existed, insert to DB
        if (!isExisted) {
            BankInfosModule *kardsItem = [NSEntityDescription insertNewObjectForEntityForName:@"BankInfosModule" inManagedObjectContext:[[AppViewController Shared] managedObjectContext]];
            kardsItem.distance = [dicJson objectForKey:@"dis"];
            kardsItem.itemID = [obj objectForKey:@"_id"];
            kardsItem.address = [obj objectForKey:@"address"];
            kardsItem.bankID = bankID;
            kardsItem.bankNameEN = [obj objectForKey:@"bankNameEN"];
            kardsItem.bankNameVN = [obj objectForKey:@"bankNameVN"];
            kardsItem.banktype = bankType;
            kardsItem.city = [obj objectForKey:@"city"];
            kardsItem.locationname = [obj objectForKey:@"locationname"];
            kardsItem.phoneNumber = [obj objectForKey:@"phones"];
            kardsItem.workingtime = [obj objectForKey:@"workingtime"];
            kardsItem.latitude = @(lat);
            kardsItem.longtitude = @(lon);
        }
        else {
            NSLog(@"item is existed");
        }
    }
    
    [[AppViewController Shared] saveContext];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
		exit(-1);
    }
}

-(void)updateDistanceForBankItems:(CLLocation*)currentPosition
{
    // refresh fechtData
    [self performSearchKardForBankName:_selectedBank withType:_selectedType];
    NSLog(@"updateDistanceForBankItems-0 fcount = %d bank = %@ type = %d", self.fetchedResultsController.fetchedObjects.count, _selectedBank, _selectedType);
    for (BankInfosModule *bankItem in self.fetchedResultsController.fetchedObjects)
    {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[bankItem.latitude doubleValue] longitude:[bankItem.longtitude doubleValue]];
//        NSLog(@"old dis = %@", bankItem.distance);
        bankItem.distance = [NSNumber numberWithDouble:[currentPosition distanceFromLocation:location]];
//        NSLog(@"new dis = %@", bankItem.distance);
    }
    // save change to DB
    [[AppViewController Shared] saveContext];
}

-(void)refreshData
{
    // update distance from Bankitem to current location
    [self updateDistanceForBankItems:self.mapView.userLocation.location];
    
    // fetch data
//    [self performSearchKardForBankName:_selectedBank withType:_selectedType];

    // reload interface
    [self loadInterface];
    // need to load data from server
    [self requestListATMOfBank:_selectedBank withType:_selectedType];
}

#pragma mark - Application Delegate
#define KEY_USER_LOCATION_LONGTITUDE @"com.aigo.iatm.userlocation.longtitude"
#define KEY_USER_LOCATION_LATITUDE @"com.aigo.iatm.userlocation.latitude"
- (void)applicationWillResignActive
{
    NSLog(@"applicationWillResignActive-0");
    
    // save current position for furthur use
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    CLLocation *currentLocation = self.mapView.userLocation.location;
    
    [defaults setObject:@(currentLocation.coordinate.latitude) forKey:KEY_USER_LOCATION_LATITUDE];
    [defaults setObject:@(currentLocation.coordinate.longitude) forKey:KEY_USER_LOCATION_LONGTITUDE];
    
    [defaults synchronize];
}

- (void)applicationDidBecomeActive
{
    NSLog(@"applicationDidBecomeActive-0");
}

#pragma mark - API Call

-(void)requestListBanks
{
    [_ListBankRequester requestWithType:ENUM_API_REQUEST_TYPE_GET_LIST_BANK andRootURL:STRING_REQUEST_URL_GET_LIST_BANK andPostMethodKind:NO andParams:nil andDelegate:self];
}

-(void)requestListATMOfBank:(NSString*)bankName  withType:(enumBankType)type
{
    CLLocation *currentLocation = self.mapView.userLocation.location;
    if(!currentLocation) return;
    
    // get bank ID from bank name
    NSString *bankID = (!bankName || [bankName isEqualToString:@""]) ? @"all" : [_bankName2BankID valueForKey:bankName];
    
    // get bank type
    NSString *bankType;
    if (type == enumBankType_ATM)
        bankType = @"ATM";
    else if (type == enumBankType_Branch)
        bankType = @"BRANCH";
    else
        bankType = @"all";

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude] forKey:STRING_REQUEST_KEY_LONGTITUDE];
    [params setValue:[NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude] forKey:STRING_REQUEST_KEY_LATTITUDE];
    [params setValue:[NSString stringWithFormat:@"%d", NUMBER_OF_REQUEST_ATM] forKey:STRING_REQUEST_KEY_NUMBER];
    [params setValue:bankID forKey:STRING_REQUEST_KEY_BANK_ID];
    [params setValue:bankType forKey:STRING_REQUEST_KEY_BANK_TYPE];
    
    [[AppViewController Shared] isRequesting:YES andRequestType:ENUM_API_REQUEST_TYPE_GET_LIST_ATM_OF_BANK andFrame:FRAME(0, 0, WIDTH_IPHONE, HEIGHT_IPHONE)];
    [_APIRequester requestWithType:ENUM_API_REQUEST_TYPE_GET_LIST_ATM_OF_BANK andRootURL:STRING_REQUEST_URL_GET_ATM_OF_BANK andPostMethodKind:YES andParams:params andDelegate:self];
}

-(void)getDirectionFrom:(CLLocationCoordinate2D)source to:(CLLocationCoordinate2D)destination
{
    NSString *url = [NSString stringWithFormat:@"%@?origin=%f,%f&destination=%f,%f&sensor=true",REQUEST_URL_GOOGLE_DIRECTION_API, source.latitude, source.longitude, destination.latitude, destination.longitude];
    [[AppViewController Shared] isRequesting:YES andRequestType:ENUM_API_REQUEST_TYPE_GET_DIRECTION andFrame:FRAME(0, 0, WIDTH_IPHONE, HEIGHT_IPHONE)];
    [_APIRequester requestWithType:ENUM_API_REQUEST_TYPE_GET_DIRECTION andRootURL:url andPostMethodKind:NO andParams:nil andDelegate:self];
}

#pragma mark - APIRequesterProtocol
- (void)requestFinished:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type {
    
    [[AppViewController Shared] isRequesting:NO andRequestType:type andFrame:CGRectZero];
    
    if (_isRefreshing) {
        // stop refresh animation
        [self.refreshBtn.layer removeAllAnimations];
        _isRefreshing = NO;
        self.refreshBtn.selected = NO;
    }
    
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
    
    if (type == ENUM_API_REQUEST_TYPE_GET_DIRECTION)
    {
//        NSLog(@"Direction = %@", dicJson);
        [self updateDirectionWithData:dicJson];
    }
    else if (type == ENUM_API_REQUEST_TYPE_GET_LIST_BANK)
    {
        _bankName2BankID = [[NSMutableDictionary alloc] init];
        NSArray *listBankName = [[dicJson objectForKey:@"_configuration"] objectForKey:@"bankNameENList"];
        NSArray *listBankIDs = [[dicJson objectForKey:@"_configuration"] objectForKey:@"bankIDList"];
        for (NSInteger i = 0; i < listBankName.count; i++) {
            [_bankName2BankID setValue:[listBankIDs objectAtIndex:i] forKey:[listBankName objectAtIndex:i]];
        }
        
        // update list bank name
        [self updateListBank];
    }
    else if (type == ENUM_API_REQUEST_TYPE_GET_LIST_ATM_OF_BANK)
    {
        NSMutableArray *atmList = [dicJson objectForKey:STRING_RESPONSE_KEY_RESULTS];
        NSLog(@"Num server respond = %d", atmList.count);
        // add new bank data
        [self insertKardDataFromServer:atmList];

        // reload interface
        [self loadInterface];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type {
//    NSLog(@" requestFailed %@ ", request.responseString);
    
    [[AppViewController Shared] isRequesting:NO andRequestType:type andFrame:CGRectZero];
    
    if (![ASIHTTPRequest isNetworkReachable]) {
        ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, STRING_ALERT_CONNECTION_ERROR);
    }
    
    if (_isRefreshing) {
        // stop refresh animation
        [self.refreshBtn.layer removeAllAnimations];
        self.refreshBtn.selected = NO;
        _isRefreshing = NO;
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"BankItemID";
    if ([annotation isKindOfClass:[BankItem class]]) {
        
        // select pin image
        NSString *imageName = ((BankItem*)annotation).type == enumBankType_Branch ? @"red_pin_bank.png" : @"red_pin_atm.png";
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:imageName];
        
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    if ([view.annotation isKindOfClass:[BankItem class]]) {
//        self.directionBtn.hidden = NO;
        _selectedBankItem = (BankItem*)view.annotation;
        _bankDetailView.bankName.text = _selectedBankItem.bankName;
        _bankDetailView.titleLbl.text = _selectedBankItem.locationName;
        _bankDetailView.subTitleLbl.text = _selectedBankItem.address;
        [_bankDetailView setWorkingTime: _selectedBankItem.workingTime];
        [_bankDetailView setPhoneNumber: _selectedBankItem.phoneNumber];
        [_bankDetailView show];
    }
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
    if ([view.annotation isKindOfClass:[BankItem class]]) {
        [_bankDetailView hide];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {
    GradientPolylineView *overlayView = [[GradientPolylineView alloc] initWithOverlay:overlay];
    overlayView.lineWidth = 5;
//    overlayView.strokeColor = [UIColor redColor];
//    overlayView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5f];
    return overlayView;
}


- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLocatingUser-0");
}
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"mapViewDidStopLocatingUser-1");
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation-2");
    // refresh data
    // check distance from last position
    NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
    CLLocation *currentLocation = self.mapView.userLocation.location;
    
    if (!self.mapView.annotations || self.mapView.annotations.count == 0) {
        [self refreshUI];
    }
    else if ([defaults objectForKey:KEY_USER_LOCATION_LATITUDE] && [[defaults objectForKey:KEY_USER_LOCATION_LATITUDE] doubleValue] != 0.0) {
        // get last locaton
        CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:[[defaults objectForKey:KEY_USER_LOCATION_LATITUDE] doubleValue] longitude:[[defaults objectForKey:KEY_USER_LOCATION_LONGTITUDE] doubleValue]];
        // calculate distance from current location and last location
        CLLocationDistance distance = [currentLocation distanceFromLocation:lastLocation];
        // refresh data if it is far enough
        if (distance > MAXIMUM_DISTANCE) {
            [self refreshUI];
        }
    }
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError-3");
}

#pragma mark - Utilities
-(void)refreshUI
{
    // if request is sending, do nothing
    if (_isRefreshing) {
        return;
    }
    
    // refresh UI and data
    [self refreshTouchUpInside:self.refreshBtn];
}

- (IBAction)refreshTouchUpInside:(id)sender {
    ((UIButton*)sender).selected = !((UIButton*)sender).selected;
    
    if (!((UIButton*)sender).selected) {
        [self.refreshBtn.layer removeAllAnimations];
        _isRefreshing = NO;
        return;
    }
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 3.0f;
    animation.repeatCount = HUGE_VAL;
    [self.refreshBtn.layer addAnimation:animation forKey:@"refresh_button_animation"];
    
    _isRefreshing = YES;
    
    // refresh data of current bank and type
    [self refreshData];
}

- (IBAction)bankBtnTouchUpInside:(id)sender {

    _activeList = _listBank;
    self.bankTableView.contentOffset = CGPointMake(0, 0);
    // show bank list
    CGRect r = self.bankTableView.frame;
    r.origin.y = HEIGHT_IPHONE;
    self.bankTableView.frame = r;
    self.bankTableView.hidden = NO;
    [self.bankTableView fadingTransisitonShowWithMask];
}

- (IBAction)directionBtnTouchUpInside:(UIButton *)sender {
    if (_selectedBankItem) {
        [self getDirectionFrom:self.mapView.userLocation.location.coordinate to:_selectedBankItem.location];
    }
}

- (IBAction)showCurrentLocation:(id)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

-(void)doubleTapOnCell:(UITapGestureRecognizer*)recognizer
{
    // close table view
    CGRect r = self.bankTableView.frame;
    r.origin.y = HEIGHT_IPHONE;
    [self.bankTableView fadingTransisitonShouldHideWithMask];
    
    if (recognizer.view.tag != _selectedRow) {
        _selectedRow = recognizer.view.tag;
        NSString *selectedStr = [_activeList objectAtIndex:_selectedRow];
        _selectedBank = _selectedRow == 0 ? nil : selectedStr;
        
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self.bankBtn setTitle:selectedStr forState:UIControlStateNormal];
        } completion:nil];
        
        // check in local DB, if data of selected Bank is existed, show it
        // if it is not existed, load from server
        [self refreshData];
    }
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
        tapgesture.numberOfTapsRequired = 1;
        [cell addGestureRecognizer:tapgesture];
    }
    cell.tag = indexPath.row;
    
    NSDictionary *info = [mDataSource objectAtIndex:indexPath.row];
    [cell setCellTitle:[info objectForKey:KEY_TITLE]];
    [cell setIcon:[info objectForKey:KEY_IMAGE]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"did select = %d", indexPath.row);
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


#pragma mark - Map procedures

- (void)calculateCentralPointAndRadiusFromCurrentLocation:(NSMutableArray*) categoryArray {
    
    CLLocation *userLocation = self.mapView.userLocation.location;
    // only zoom in 20 nearest ATM
    if (categoryArray.count > 20) {
        CLLocation * location;
        BankItem *item1, *item2;
        for (NSInteger i = 0; i < categoryArray.count; i ++) {
            NSInteger tempIdx = i;
            
            // calculate distance of i item to user location
            item1 = [categoryArray objectAtIndex:i];
            location = [[CLLocation alloc] initWithLatitude:item1.location.latitude longitude:item1.location.longitude];
            CLLocationDistance dis1 = [location distanceFromLocation:userLocation];
            for (NSInteger j = i + 1; j < categoryArray.count; j ++) {
                // calculate distance of j item to user location
                item2 = [categoryArray objectAtIndex:j];
                location = [[CLLocation alloc] initWithLatitude:item2.location.latitude longitude:item2.location.longitude];
                CLLocationDistance dis2 = [location distanceFromLocation:userLocation];
                
                // find the nearest item to user location
                if (dis2 < dis1) {
                    tempIdx = j;
                }
            }
            
            // if nearest item is different than i index
            if (tempIdx != i) {
                // replace 2 location by another one
                BankItem *tempItem = item2;
                [categoryArray replaceObjectAtIndex:tempIdx withObject:item1];
                [categoryArray replaceObjectAtIndex:i withObject:tempItem];
            }
        }
    }
    
    // Find latitude and longtitude smallest and biggest
    float smallLongtitute   = 0;
    float smallLattitute    = 0;
    float bigLongtitute     = 0;
    float bigLattitute      = 0;
    
    smallLongtitute   = self.mapView.userLocation.coordinate.longitude;
    smallLattitute    = self.mapView.userLocation.coordinate.latitude;
    bigLongtitute     = self.mapView.userLocation.coordinate.longitude;
    bigLattitute      = self.mapView.userLocation.coordinate.latitude;
    
    for (NSInteger i = 0; i < 20 && i < categoryArray.count ; i++) {
        BankItem *item = [categoryArray objectAtIndex:i];
        float lat = item.coordinate.latitude;
        float lng = item.coordinate.longitude;
        if (lat < smallLattitute || smallLattitute == 0) {
            smallLattitute = lat;
        }
        if (lat> bigLattitute || bigLattitute == 0) {
            bigLattitute = lat;
        }
        if (lng < smallLongtitute || smallLongtitute == 0) {
            smallLongtitute = lng;
        }
        if (lng> bigLongtitute || bigLongtitute == 0) {
            bigLongtitute = lng;
        }
    }
    
    // Update central point
    _centralPoint.latitude    = (bigLattitute + smallLattitute)/2;
    _centralPoint.longitude   = (bigLongtitute + smallLongtitute)/2;
    
//    NSLog(@"-caluclateCentralPointWithLocationKards-central point - latitude=%f---longtitude=%f",_centralPoint.latitude, _centralPoint.longitude);
    

    
    // Calculate radius
    CLLocation *marklocation = [[CLLocation alloc] initWithLatitude:smallLattitute longitude:smallLongtitute];
    CLLocation *centralLocation = [[CLLocation alloc] initWithLatitude:_centralPoint.latitude longitude:_centralPoint.longitude];
    
    _radiusMeters = ([marklocation distanceFromLocation:centralLocation]);
    
    if (_radiusMeters == 0) {
        // Default for radius is 1km
        //Too far is when you show the entire USA.  Too close is when you show only a 300 ft/100m radius.
        //I think we can settle on something in the middle.  How about something like a 1Km radius
        _radiusMeters = 1000;
    }
//    NSLog(@"Distance in meters: %f", _radiusMeters);
}

- (MKCoordinateRegion)createZoomRegionFromCentralPointAndRadius:(NSMutableArray*) categoryArray {
    
    // have no deal zoom minimum scale to current location
    if ([categoryArray count] == 0) {
//        _radiusMeters = MAXIMUM_SCALEABLE_RADIUS_METERS/2;
//        _centralPoint.latitude = self.mapView.userLocation.coordinate.latitude;
//        _centralPoint.longitude = self.mapView.userLocation.coordinate.longitude;
    }
    else {
        [self calculateCentralPointAndRadiusFromCurrentLocation:categoryArray];
    }
    
    return MKCoordinateRegionMakeWithDistance(_centralPoint, _radiusMeters * 2, _radiusMeters *2 );
    
}


#pragma mark - BankDetailViewDelegate
-(void)bankDetailViewRouteTouchUpInside:(BankDetailView *)view
{
    if (_selectedBankItem) {
        [self getDirectionFrom:self.mapView.userLocation.location.coordinate to:_selectedBankItem.location];
    }
}

#pragma mark - TTAutoCollapseMenuDelegate
-(NSInteger)numberOfItemInAutoCollapseMenu
{
    return _arrMenuImages.count;
}

-(UIButton *)autoCollapseMenu:(TTAutoCollapseMenu *)menu viewForItemAtIndex:(NSInteger)index
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    [view setImage:[UIImage imageNamed:[_arrMenuImages objectAtIndex:index]] forState:UIControlStateNormal];
    view.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    [view setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 3];
    return view;
}

-(void)autoCollapseMenu:(TTAutoCollapseMenu *)menu didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"didSelectItemAtIndex %d", index);

    _selectedType = index == 0 ? enumBankType_Num : (index - 1);

    
    [self performSearchKardForBankName:_selectedBank withType:_selectedType];
    // reload list ATM on map
    [self loadInterface];
}

@end
