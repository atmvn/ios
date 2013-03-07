//
//  TWLoginManager.h
//  VFA_QUEUENCE
//
//  Created by Phan Ba Minh on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "APIRequester.h"

#define STRING_TWITTER_MESSAGE_CONNECTION_ERROR             @"Network Error. Please check the reception and the connection settings."

//#define STRING_TWITTER_APP_KEY                              @"WABJukJBiYdCkDbIaGUoA"		
//#define STRING_TWITTER_APP_SECRET                           @"klcLXs3Jm9PIeXPfmR7Fphde9jzCNewq1OTiRhm4o"
//#define STRING_TWITTER_APP_KEY                              @"lCF5Be505c5aY5k2Yw5ZuQ" 
//#define STRING_TWITTER_APP_SECRET                           @"9GOWS1C3DR6bhYen90cGzxuuCpkQ2IoWXcXFkFI5y0"
#define STRING_TWITTER_APP_KEY                              @"63dFcygYKWwBw2NMtThqUQ" 
#define STRING_TWITTER_APP_SECRET                           @"E9Vqe6QrF99pIoheokAUOs4bFYDwy8DQzlxpQEE4"
 
#define STRING_CODER_TW_USER_NAME							@"STRING_CODER_TW_USER_NAME"
#define STRING_CODER_TW_NAME								@"STRING_CODER_TW_NAME"
#define	STRING_CODER_TW_EMAIL								@"STRING_CODER_TW_EMAIL"
#define STRING_CODER_TW_ACCESS_TOKEN						@"STRING_CODER_TW_ACCESS_TOKEN"
#define STRING_CODER_TW_AUTH_DATA							@"STRING_CODER_TW_AUTH_DATA"
#define STRING_CODER_TW_LOGIN_STATUS						@"STRING_CODER_TW_LOGIN_STATUS"
#define STRING_CODER_TW_USER_ID                             @"STRING_CODER_TW_USER_ID"
#define STRING_CODER_TW_GENDER                              @"STRING_CODER_TW_GENDER"
#define STRING_CODER_TW_ABOUT                               @"STRING_CODER_TW_ABOUT"

@protocol TWLoginManagerDelegate
@optional
- (void)accessTokenFound:(NSString *)apiKey;
- (void)displayRequired;
- (void)loginFail;
- (void)clickBack;
@end

@interface TWLoginManager : NSObject <SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, MGTwitterEngineDelegate, UIAlertViewDelegate> {
    SA_OAuthTwitterEngine                   *m_OAuthTwitterEngine;
    
    id<TWLoginManagerDelegate>              delegate;
	APIRequester							*_APIRequester;
    
    UIAlertView                             *m_AlertTWLoginFail;
}
@property (nonatomic, retain) UIViewController *TWController;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *authData;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *about;

@property (nonatomic) BOOL loginStatus;

- (void)reLogin;
- (void)login;

- (UIViewController *)getTWControllerWithDelegate:(id)idDelegate;
+ (TWLoginManager *)Shared;

@end
