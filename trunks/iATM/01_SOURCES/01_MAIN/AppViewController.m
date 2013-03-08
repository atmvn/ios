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
    NSLog(@"requestFinished %@, request.responseStatusCode: %i", request.responseString, request.responseStatusCode);
    
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

@end
