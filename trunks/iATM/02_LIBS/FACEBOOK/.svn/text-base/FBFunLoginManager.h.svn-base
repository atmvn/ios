//
//  FBFunLoginMnager.h
//  FACEBOOK_SHARE
//
//  Created by Phan Ba Minh on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFunLoginDialog.h"
#import <Foundation/Foundation.h>
#import "APIRequester.h"

//#define STRING_FACEBOOK_APP_ID                              @"342694312412758" // Free
//#define STRING_FACEBOOK_APP_ID                              @"210849718975311" // Hackbook
#define STRING_FACEBOOK_APP_ID                              @"416904738361278"

#define ARRAY_FACEBOOK_APP_PERMISSION                       [[NSArray alloc] initWithObjects:@"publish_stream", @"read_stream", @"friends_likes", nil]
//#define STRING_FACEBOOK_APP_PERMISSION                      @"read_stream,publish_stream,friends_likes,user_photos,friends_photos"
#define STRING_FACEBOOK_APP_PERMISSION                      @"read_stream,publish_stream,user_photos,email,user_birthday"
#define STRING_FACEBOOK_MESSAGE_CONNECTION_ERROR            @"Network Error. Please check the reception and the connection settings."
#define STRING_CODER_FB_USER_ID								@"STRING_CODER_FB_USER_ID"
#define STRING_CODER_FB_NAME								@"STRING_CODER_FB_NAME"
#define STRING_CODER_FB_PICTURE								@"STRING_CODER_FB_PICTURE"
#define STRING_CODER_FB_ACCESS_TOKEN						@"STRING_CODER_FB_ACCESS_TOKEN"
#define	STRING_CODER_FB_LOGIN_STATUS						@"STRING_CODER_FB_LOGIN_STATUS"
#define STRING_CODER_FB_FIRST_NAME							@"STRING_CODER_FB_FIRST_NAME"
#define STRING_CODER_FB_LAST_NAME							@"STRING_CODER_FB_LAST_NAME"
#define	STRING_CODER_FB_EMAIL								@"STRING_CODER_FB_EMAIL"
#define	STRING_CODER_FB_GENDER								@"STRING_CODER_FB_GENDER"
#define	STRING_CODER_FB_ABOUT								@"STRING_CODER_FB_ABOUT"

typedef enum
{
    ENUM_FB_FUN_LOGIN_MANAGER_STEP_INVALID,
    ENUM_FB_FUN_LOGIN_MANAGER_STEP_START,
    ENUM_FB_FUN_LOGIN_MANAGER_STEP_DISPLAY_REQUIRED,
    ENUM_FB_FUN_LOGIN_MANAGER_STEP_DISPLAYED,
    ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FAIL,
    ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FINISH,
    ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_CANCEL
}ENUM_FB_FUN_LOGIN_MANAGER_STEP;

@protocol FBFunLoginManagerDelegate <NSObject>
@required
- (void)changeBackFromFBFunLoginManager;
@end

@interface FBFunLoginManager : NSObject <FBFunLoginDialogDelegate, UIAlertViewDelegate> {
    FBFunLoginDialog                    *_FBLoginDialogVC;
    ENUM_FB_FUN_LOGIN_MANAGER_STEP      m_FBFunLoginManagerStep;
    
    UIAlertView                         *m_AlertFBLoginFail;
    id<FBFunLoginManagerDelegate>       m_Delegate;
	APIRequester						*_APIRequester;
}
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fName;
@property (nonatomic, retain) NSString *lName;
@property (nonatomic, retain) NSString *pictureURL;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, strong) NSDate   *birthday;
@property (nonatomic, strong) NSDate   *updateTime;

@property (nonatomic) BOOL loginStatus;

- (void)logout;
- (void)login;
- (void)reLogin;
- (void)update;
- (void)save;

- (UIViewController *)getFBControllerWithDelegate:(id)idDelegate;
+ (FBFunLoginManager *)Shared;
@end
