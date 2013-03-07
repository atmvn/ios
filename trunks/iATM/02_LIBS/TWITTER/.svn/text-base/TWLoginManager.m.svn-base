//
//  TWLoginManager.m
//  VFA_QUEUENCE
//
//  Created by Phan Ba Minh on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWLoginManager.h"
#import "AppViewController.h"
#import "JSON.h"

@implementation TWLoginManager
@synthesize TWController, email, accessToken, loginStatus, name, userName, authData, userID, gender, about;

- (id)initWithConsumerKey:(NSString *)consumerKey andConsumerSecret:(NSString *)consumerSecret {
    self = [super init];
    if (self) {
        // Custom initialization
        m_OAuthTwitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        m_OAuthTwitterEngine.consumerKey    = consumerKey;  
        m_OAuthTwitterEngine.consumerSecret = consumerSecret;  
        [m_OAuthTwitterEngine requestRequestToken];
        [m_OAuthTwitterEngine requestAccessToken];
		
		_APIRequester = [APIRequester new];
        
        m_AlertTWLoginFail = [[UIAlertView alloc] initWithTitle:@"Twitter" message:STRING_TWITTER_MESSAGE_CONNECTION_ERROR delegate:self cancelButtonTitle:STRING_ALERT_OK otherButtonTitles:nil];
    }
    return self;
}

- (void)dealloc {
    RELEASE_SAFE(m_OAuthTwitterEngine);
    RELEASE_SAFE(TWController);
	RELEASE_SAFE(_APIRequester);
	RELEASE_SAFE(name);
	RELEASE_SAFE(accessToken);
	RELEASE_SAFE(email);
	RELEASE_SAFE(userName);
	RELEASE_SAFE(authData);
    RELEASE_SAFE(userID);
    RELEASE_SAFE(m_AlertTWLoginFail);
    RELEASE_SAFE(gender);
    RELEASE_SAFE(about);
    [super dealloc];
}

static TWLoginManager *m_Instance;
+ (TWLoginManager *)Shared {
    if ( !m_Instance ) {
        m_Instance = [[TWLoginManager alloc] initWithConsumerKey:STRING_TWITTER_APP_KEY andConsumerSecret:STRING_TWITTER_APP_SECRET];
		
		NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:STRING_USER_DEFAULT_TWITTER_DATA_MANAGER];
        if ([NSKeyedUnarchiver unarchiveObjectWithData:data]) {
            TWLoginManager *_data = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
			m_Instance.name = _data.name;
			m_Instance.email = _data.email;
			m_Instance.accessToken = _data.accessToken;
			m_Instance.loginStatus = _data.loginStatus;
            m_Instance.userName = _data.userName;
            m_Instance.userID = _data.userID;
            m_Instance.gender = _data.gender;
            m_Instance.about  = _data.about;
			[_data release];
        }
    }
    return m_Instance;
}

#pragma mark - Encode - Decode

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:userName forKey:STRING_CODER_TW_USER_NAME];
	[encoder encodeObject:name forKey:STRING_CODER_TW_NAME];
	[encoder encodeObject:email forKey:STRING_CODER_TW_EMAIL];
	[encoder encodeObject:accessToken forKey:STRING_CODER_TW_ACCESS_TOKEN];
	[encoder encodeBool:loginStatus forKey:STRING_CODER_TW_LOGIN_STATUS];
    [encoder encodeObject:userID forKey:STRING_CODER_TW_USER_ID];
    [encoder encodeObject:gender forKey:STRING_CODER_TW_GENDER];
    [encoder encodeObject:about forKey:STRING_CODER_TW_ABOUT];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
		if ([decoder decodeObjectForKey:STRING_CODER_TW_USER_NAME]) self.userName = [decoder decodeObjectForKey:STRING_CODER_TW_USER_NAME];
        if ([decoder decodeObjectForKey:STRING_CODER_TW_NAME]) self.name = [decoder decodeObjectForKey:STRING_CODER_TW_NAME];
        if ([decoder decodeObjectForKey:STRING_CODER_TW_EMAIL]) self.email = [decoder decodeObjectForKey:STRING_CODER_TW_EMAIL];
		if ([decoder decodeObjectForKey:STRING_CODER_TW_ACCESS_TOKEN]) self.accessToken = [decoder decodeObjectForKey:STRING_CODER_TW_ACCESS_TOKEN];
        if ([decoder decodeBoolForKey:STRING_CODER_TW_LOGIN_STATUS]) self.loginStatus = [decoder decodeBoolForKey:STRING_CODER_TW_LOGIN_STATUS];
        if ([decoder decodeObjectForKey:STRING_CODER_TW_USER_ID]) self.userID = [decoder decodeObjectForKey:STRING_CODER_TW_USER_ID];
        if ([decoder decodeObjectForKey:STRING_CODER_TW_GENDER]) self.gender = [decoder decodeObjectForKey:STRING_CODER_TW_GENDER];
        if ([decoder decodeObjectForKey:STRING_CODER_TW_ABOUT]) self.about = [decoder decodeObjectForKey:STRING_CODER_TW_ABOUT];
    }
    return self;
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:STRING_USER_DEFAULT_TWITTER_DATA_MANAGER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - TWLoginManager

- (void)changeBackToPreviousViewController {
    //    [self dismissModalViewControllerAnimated:YES];
    
    [[AppViewController Shared] chageBackFromTwitterViewController];
}

- (void)logout
{
	self.loginStatus = NO;
	[self save];
	
    [m_OAuthTwitterEngine  clearAccessToken];
    [m_OAuthTwitterEngine setClearsCookies:YES];
    TWController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:m_OAuthTwitterEngine delegate:self];
}

- (void)reLogin {
	self.loginStatus = NO;
    
    // Reset authentication of last login if have
    self.authData = nil;
	
    [self save];
	
    [m_OAuthTwitterEngine  clearAccessToken];
    [m_OAuthTwitterEngine setClearsCookies:YES];
    TWController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:m_OAuthTwitterEngine delegate:self];  
}

- (void)login {
	self.loginStatus = NO;
	[self save];
	
    TWController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:m_OAuthTwitterEngine delegate:self];  
}

- (UIViewController *)getTWControllerWithDelegate:(id)idDelegate {
    delegate = idDelegate;
    
    if (TWController) {
        return TWController;
    }
    return [[UIViewController new] autorelease];//Qasim 7/11/12
}

#pragma mark - SA_OAuthTwitterEngine Protocol

- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username {
    NSLog(@"storeCachedTwitterOAuthData data: %@", data);
    NSLog(@"username: %@", username);
    
    if (data && data.length > 0) {
        self.userName = username;
        self.authData = data;
        self.userID = [[[[data componentsSeparatedByString:@"&"] objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1];
        [self save];
    }
}

- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *)username {
    NSLog(@"cachedTwitterOAuthDataForUsername username: %@", username);
	return authData;
}

- (void)twitterOAuthConnectionFailedWithData:(NSData *)data {
    NSLog(@"twitterOAuthConnectionFailedWithData");
    
    [m_AlertTWLoginFail show];
}

#pragma mark - TwitterEngineDelegate
- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
    NSLog(@"OAuthTwitterControllerFailed");
    
    [m_AlertTWLoginFail show];
}

- (void)OAuthTwitterControllerCanceled:(SA_OAuthTwitterController *)controller {
     NSLog(@"OAuthTwitterControllerCanceled");
    
    [self changeBackToPreviousViewController];
}

- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
    NSLog(@"OAuthTwitterController info");
    
    
    [_APIRequester requestWithType:ENUM_API_REQUEST_TYPE_TW_GET_PROFILE andURL:[NSString stringWithFormat:@"https://api.twitter.com/1/users/show.json?screen_name=%@", userName] andDelegate:self];
    
//	self.loginStatus = YES;
//	[self save];
//  [self changeBackToPreviousViewController];
    
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
	NSLog(@"TW requestSucceeded %@", connectionIdentifier);
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	NSLog(@"TW requestFailed %@", connectionIdentifier);
    
    [m_AlertTWLoginFail show];
}

#pragma mark - APIRequester Protocol
- (void)requestFailed:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type
{
    if (type == ENUM_API_REQUEST_TYPE_FB_GET_PROFILE) {
        NSLog(@"getMyFacebookProfileFail");
        self.loginStatus = NO;
		[self save];
    }
    
    [m_AlertTWLoginFail show];
}
- (void)requestFinished:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type
{
    if (type == ENUM_API_REQUEST_TYPE_TW_GET_PROFILE) {
        NSString *responseString = [request responseString];
        NSLog(@"requestFinished: %@",responseString);
        
        NSMutableDictionary *responseJSON = [responseString JSONValue];
        if (responseJSON) {
			self.name = [responseJSON objectForKey:STRING_RESPONSE_KEY_TW_NAME];
			self.gender = [responseJSON objectForKey:STRING_RESPONSE_KEY_TW_GENDER];
            if (self.gender == nil) {
                self.gender = [NSString stringWithFormat:@""];
            }
            self.about = [responseJSON objectForKey:STRING_RESPONSE_KEY_TW_ABOUT];
			if (self.about == nil) {
                self.about = [NSString stringWithFormat:@""];
            }
            
			if (userID && name) {
				self.loginStatus = YES;
				[self save];
                [self changeBackToPreviousViewController];
			}
            else {
                NSLog(@"userID || name = nil");
                self.loginStatus = NO;
                [self save];
                [m_AlertTWLoginFail show];
            }
        }
        else{
            NSLog(@"responseJSON = nil || empty");
            self.loginStatus = NO;
			[self save];
            [m_AlertTWLoginFail show];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self changeBackToPreviousViewController];
}

@end
