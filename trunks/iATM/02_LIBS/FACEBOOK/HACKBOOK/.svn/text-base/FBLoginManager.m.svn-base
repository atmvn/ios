//
//  FBLoginManager.m
//  VFA_QUEUENCE
//
//  Created by Phan Ba Minh on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBLoginManager.h"

#define STRING_FACEBOOK_HACKBOOK_APP_ID                              @"342694312412758" // Free
#define STRING_FACEBOOK_HACKBOOK_APP_PERMISSION                      @"read_stream,publish_stream,friends_likes"
#define ARRAY_FACEBOOK_HACKBOOK_APP_PERMISSION                       [[NSArray alloc] initWithObjects:@"publish_stream", @"read_stream", @"friends_likes", nil]

@implementation FBLoginManager
@synthesize facebook;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        facebook = [[Facebook alloc] initWithAppId:STRING_FACEBOOK_HACKBOOK_APP_ID andDelegate:self];
        permissions = ARRAY_FACEBOOK_HACKBOOK_APP_PERMISSION;
        CGFloat xProfilePhotoOffset = self.view.center.x - 25.0;
        profilePhotoImageView = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(xProfilePhotoOffset, 20, 50, 50)];
        profilePhotoImageView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        nameLabel = [[UILabel alloc]
                     initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, 20.0)];
        nameLabel.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        nameLabel.textAlignment = UITextAlignmentCenter;
        nameLabel.text = @"";
        
        userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        
        // Check and retrieve authorization information
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
        if (STRING_FACEBOOK_HACKBOOK_APP_ID == nil) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
            [alertView release];
        } else {
            // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
            // be opened, doing a simple check without local app id factored in here
            NSString *url = [NSString stringWithFormat:@"fb%@://authorize",STRING_FACEBOOK_HACKBOOK_APP_ID];
            BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
            NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
            if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
                ([aBundleURLTypes count] > 0)) {
                NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
                if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                    NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                    if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                        ([aBundleURLSchemes count] > 0)) {
                        NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                        if ([scheme isKindOfClass:[NSString class]] &&
                            [url hasPrefix:scheme]) {
                            bSchemeInPlist = YES;
                        }
                    }
                }
            }
            // Check if the authorization callback will work
            BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
            if (!bSchemeInPlist || !bCanOpenUrl) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Setup Error"
                                          message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil,
                                          nil];
                [alertView show];
                [alertView release];
            }
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)showMessage:(NSString *)message {
    CGRect labelFrame = messageView.frame;
    labelFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    messageView.frame = labelFrame;
    messageLabel.text = message;
    messageView.hidden = NO;
    
    // Use animation to show the message from the bottom then
    // hide it.
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect labelFrame = messageView.frame;
                         labelFrame.origin.y -= labelFrame.size.height;
                         messageView.frame = labelFrame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:3.0
                                                 options: UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  CGRect labelFrame = messageView.frame;
                                                  labelFrame.origin.y += messageView.frame.size.height;
                                                  messageView.frame = labelFrame;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      messageView.hidden = YES;
                                                      messageLabel.text = @"";
                                                  }
                                              }];
                         }
                     }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![facebook isSessionValid]) {
        [self showLoggedOut];
    } else {
        [self showLoggedIn];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

static FBLoginManager *m_Instance;
+ (FBLoginManager *)Shared
{
    if ( !m_Instance ) {
        m_Instance = [[FBLoginManager alloc] init];
    }
    return m_Instance;
}

#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [facebook requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)apiGraphUserPermissions {
    [facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
}

#pragma - Private Helper Methods

/**
 * Show the logged in menu
 */

- (void)showLoggedIn {    
    [self apiFQLIMe];
}

/**
 * Show the logged in menu
 */

- (void)showLoggedOut {

}

/**
 * Show the authorization dialog.
 */
- (void)login {
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions];
    } else {
        [self showLoggedIn];
    }
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    [facebook logout];
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    [self showLoggedIn];
    
    [self storeAuthData:[facebook accessToken] expiresAt:[facebook expirationDate]];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
//    [[AppViewController Shared] enableSubViewInPostScreenWithStep:ENUM_POST_SCREEN_STEP_FROM_HOME];
}
/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
//    [[AppViewController Shared] enableSubViewInPostScreenWithStep:ENUM_POST_SCREEN_STEP_FROM_HOME];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
///**
// * Called when the user granted additional permissions.
// */
//- (void)userDidGrantPermission {
//    // After permissions granted follow up with next API call
//    switch (currentAPICall) {
//        case kDialogPermissionsCheckinForRecent:
//        {
//            // After the check-in permissions have been
//            // granted, save them in app session then
//            // retrieve recent check-ins
//            [self updateCheckinPermissions];
//            [self apiGraphUserCheckins];
//            break;
//        }
//        case kDialogPermissionsCheckinForPlaces:
//        {
//            // After the check-in permissions have been
//            // granted, save them in app session then
//            // get nearby locations
//            [self updateCheckinPermissions];
//            [self getNearby];
//            break;
//        }
//        case kDialogPermissionsExtended:
//        {
//            // In the sample test for getting user_likes
//            // permssions, echo that success.
//            [self showMessage:@"Permissions granted."];
//            break;
//        }
//        default:
//            break;
//    }
//}
//
///**
// * Called when the user canceled the authorization dialog.
// */
//- (void)userDidNotGrantPermission {
//    [self showMessage:@"Extended permissions not granted."];
//}

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    NSLog(@"Result: %@",result);
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        // If basic information callback, set the UI objects to
        // display this.
        nameLabel.text = [result objectForKey:@"name"];
//        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"uid"] forKey:STRING_USER_DEFAULT_FB_ID];
        
        // Get the profile image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
        float ratio;
        float delta;
        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        CGPoint offset;
        CGSize size = image.size;
        if (size.width > size.height) {
            ratio = px / size.width;
            delta = (ratio*size.width - ratio*size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = px / size.height;
            delta = (ratio*size.height - ratio*size.width);
            offset = CGPointMake(0, delta/2);
        }
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * size.width) + delta,
                                     (ratio * size.height) + delta);
        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        UIImage *imgThumb =   UIGraphicsGetImageFromCurrentImageContext();
        [imgThumb retain];
        
        [profilePhotoImageView setImage:imgThumb];
        [self apiGraphUserPermissions];
    } else {
        // Processing permissions information
        userPermissions = [[result objectForKey:@"data"] objectAtIndex:0];
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
//    [[AppViewController Shared] enableSubViewInPostScreenWithStep:ENUM_POST_SCREEN_STEP_FROM_HOME];
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}
@end
