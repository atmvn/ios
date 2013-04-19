//
//  ViewController.m
//  aigo
//
//  Created by Tai Truong on 11/20/12.
//  Copyright (c) 2012 AIGO. All rights reserved.
//

#import "AppViewController.h"

@interface AppViewController ()

@end


@implementation AppViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _listOfViewController = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 100, 30)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////
static AppViewController *_appVCInstance;
+ (AppViewController *)Shared
{
    if (!_appVCInstance) {
        _appVCInstance = [[AppViewController alloc] init];
    }
    return _appVCInstance;
}

#pragma mark - Indicator view animation

- (void)isRequesting:(BOOL)isRe andRequestType:(ENUM_API_REQUEST_TYPE)type andFrame:(CGRect)frame {
    if (isRe) {
        if (_requestingView == nil) {
            _requestingView = [UIView new];
            _requestingView.backgroundColor = [UIColor blackColor];
            _requestingView.alpha= 0.5;
        }
        if (_requestingIndicator == nil) {
            _requestingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [_requestingView addSubview:_requestingIndicator];
            
        }
        
        [_requestingView removeFromSuperview];
        [_requestingIndicator startAnimating];
		_requestingView.frame = frame;
		_requestingIndicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [[[_listOfViewController lastObject] view] addSubview:_requestingView];
    }
    else {
        [_requestingIndicator stopAnimating];
        [_requestingView removeFromSuperview];
    }
}

#pragma mark - App Protocol
/////////////////////////////////
- (void)update {
    // update top view controller
    if ([_listOfViewController lastObject]) {
        id<AppViewControllerProtocol> vc = [_listOfViewController lastObject];
        if ([vc respondsToSelector:@selector(update)]) {
            [vc update];
        }
    }
}

#pragma mark - UIImage Picker View Controller

- (void)changeToPickerControllerWithSourceType:(UIImagePickerControllerSourceType)type andDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = type;
        picker.delegate = delegate;
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] && type == UIImagePickerControllerSourceTypeCamera) {
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        [self presentModalViewController:picker animated:NO];
    }
    else {
        ALERT(@"", STRING_ALERT_MESSAGE_CAMERA_PHOTO_NOT_SUPPORTED);
    }
}
- (void)changeBackFromPickerController {
    [self dismissModalViewControllerAnimated:NO];
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)requestUpdateDeviceToken:(NSString*)oldToken
{

}


#pragma mark - APIRequesterProtocol

- (void)requestFinished:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type {
//    NSLog(@"requestFinished %@, request.responseStatusCode: %i", request.responseString, request.responseStatusCode);
    
    [[AppViewController Shared] isRequesting:NO andRequestType:ENUM_API_REQUEST_TYPE_INVALID andFrame:CGRectZero];
    
    NSError *error;
    SBJSON *sbJSON = [SBJSON new];
    
    if (![sbJSON objectWithString:[request responseString] error:&error] || request.responseStatusCode != 200 || !request) {
//        if (![ASIHTTPRequest isNetworkReachable]) {
//            ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, STRING_ALERT_SERVER_ERROR);
//        }
        ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, STRING_ALERT_SERVER_ERROR);
        return;
    }
    
    if (type == ENUM_API_REQUEST_TYPE_NOTIFICATION_UPDATE_DEVICE_TOKEN)
    {
        NSLog(@"Update Device Token is Success.");
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type {
    NSLog(@"requestFailed %@, request.responseStatusCode: %i", request.responseString, request.responseStatusCode);
    
    [[AppViewController Shared] isRequesting:NO andRequestType:ENUM_API_REQUEST_TYPE_INVALID andFrame:CGRectZero];
    
    if (![ASIHTTPRequest isNetworkReachable]) {
        ALERT(STRING_ALERT_CONNECTION_ERROR_TITLE, STRING_ALERT_CONNECTION_ERROR);
    }
}


#pragma mark - Remote Notification
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo andNotificationType:(enumRemoveNotificationType)type {
}


#pragma mark - managedObjectContext

- (void)saveContext
{
    // MinhPB 2012/10/30
    //    [[AppViewController Shared] isRequesting:YES andRequestType:ENUM_API_REQUEST_TYPE_DEAL_GET_All andFrame:CGRectMake(0, HEIGHT_HOME_VIEW_CONTROLLER_TITLE, [SupportFunction getDeviceWidth], [SupportFunction getDeviceHeight] - HEIGHT_HOME_VIEW_CONTROLLER_TITLE - HEIGHT_STATUS_BAR)];
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    // MinhPB 2012/10/30
    //    [[AppViewController Shared] isRequesting:NO andRequestType:ENUM_API_REQUEST_TYPE_DEAL_GET_All andFrame:CGRectZero];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kSqliteFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
//    NSLog(@"----%@",[_managedObjectModel entities]);
//    NSLog(@"----%@",modelURL);
//    NSLog(@"%@---%@", _managedObjectModel,modelURL);
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //if ([[VKDataService sharedService] createEditableCopyOfDatabaseIfNeeded:kSqliteFileName])
    //{
    //[[VKDataService sharedService] revertVersionToDefault];
    //}
    
    NSURL *storeURL = [[self applicationCacheDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kSqliteFileName]];
    
//    NSLog(@"Local database path: %@", storeURL);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns YES if local database is compatible with current model. Else return NO
- (BOOL)validateLocalDatabase
{
    
    NSURL *storeURL = [[self applicationCacheDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",kSqliteFileName]];
    
//    NSLog(@"Local database path: %@", storeURL);
    
    NSError * error = nil;
    
    NSDictionary *storeMeta = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil URL:storeURL error:&error];
    
    if (!storeMeta) {
        NSLog(@"Unable to load store metadata from URL: %@; Error = %@", storeURL, error);
        return YES;
    }
    
    BOOL result = [[self managedObjectModel] isConfiguration: nil compatibleWithStoreMetadata: storeMeta];
    
    if (!result) {
        // reset _managedObjectModel to reload new model
        _managedObjectModel = nil;
        NSLog(@"Unable to load store metadata from URL: %@; Error = %i", storeURL, result);
    }
    return result;
}

@end
