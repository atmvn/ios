//
//  FBFunLoginMnager.m
//  FACEBOOK_SHARE
//
//  Created by Phan Ba Minh on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBFunLoginManager.h"
#import "APIRequester.h"
#import "JSON.h"
#import "AppViewController.h"

@implementation FBFunLoginManager
@synthesize name, email, fName, lName, userID, loginStatus, pictureURL, accessToken, about, gender, birthday, updateTime;

- (id)initWithAppId:(NSString *)appId andPermission:(NSString *)permission
{
    self = [super init];
    if (self) {
        // Custom initialization
        _FBLoginDialogVC = [[FBFunLoginDialog alloc] initWithAppId:appId requestedPermissions:permission delegate:self];
        
        m_AlertFBLoginFail = [[UIAlertView alloc] initWithTitle:@"Facebook" message:STRING_FACEBOOK_MESSAGE_CONNECTION_ERROR delegate:self cancelButtonTitle:STRING_ALERT_OK otherButtonTitles:nil];
		
		_APIRequester = [APIRequester new];
    }
    return self;
}

- (UIViewController *)getFBControllerWithDelegate:(id)idDelegate {
    m_Delegate = idDelegate;
    
    if (_FBLoginDialogVC) {
        return _FBLoginDialogVC;
    }
    return [[UIViewController new] autorelease];//Qasim 7/11/12
}

#pragma mark - FB Fun Login Manager

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    if ([m_Delegate respondsToSelector:@selector(changeBackFromFBFunLoginManager)]) {
        [m_Delegate changeBackFromFBFunLoginManager];
    }
    
    [_FBLoginDialogVC isLoadingView:NO];
}

- (void)logout
{
	self.loginStatus = NO;
	[self save];
	
    [_FBLoginDialogVC logout];
}

- (void)login
{
	self.loginStatus = NO;
	[self save];
	
    [_FBLoginDialogVC login];
    m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_START;
}

- (void)reLogin {
	self.loginStatus = NO;
	[self save];
	
    [_FBLoginDialogVC logout];
    [_FBLoginDialogVC login];
    m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_START;
}

- (void)changeBackToPreviousViewController {
//    [self dismissModalViewControllerAnimated:YES];
    
    [[AppViewController Shared] chageBackFromFacebookViewController];
}

- (void)update {
    switch (m_FBFunLoginManagerStep) {
        case ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_CANCEL:

            break;
        case ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FINISH:

            break;
        case ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FAIL:

            break;
        default:
            break;
    }
}

- (void)dealloc {
    RELEASE_SAFE(_FBLoginDialogVC);
    RELEASE_SAFE(m_AlertFBLoginFail);
	RELEASE_SAFE(_APIRequester);
	RELEASE_SAFE(userID);
    RELEASE_SAFE(name);
	RELEASE_SAFE(fName);
	RELEASE_SAFE(lName);
    RELEASE_SAFE(pictureURL);
	RELEASE_SAFE(email);
	RELEASE_SAFE(accessToken);
    RELEASE_SAFE(about);
    RELEASE_SAFE(gender);
    RELEASE_SAFE(birthday);
    RELEASE_SAFE(updateTime);
    
    [super dealloc];
}

static FBFunLoginManager *m_Instance;
+ (FBFunLoginManager *)Shared
{
    if ( !m_Instance ) {
		m_Instance = [[FBFunLoginManager alloc] initWithAppId:STRING_FACEBOOK_APP_ID andPermission:STRING_FACEBOOK_APP_PERMISSION];
		
       NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:STRING_USER_DEFAULT_FACEBOOK_DATA_MANAGER];
        if ([NSKeyedUnarchiver unarchiveObjectWithData:data]) {
            FBFunLoginManager *_data = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
			m_Instance.userID = _data.userID;
			m_Instance.name = _data.name;
			m_Instance.fName = _data.fName;
			m_Instance.lName = _data.lName;
			m_Instance.pictureURL = _data.pictureURL;
			m_Instance.email = _data.email;
			m_Instance.accessToken = _data.accessToken;
			m_Instance.loginStatus = _data.loginStatus;
            m_Instance.gender = _data.gender;
            m_Instance.about = _data.about;
            m_Instance.birthday = _data.birthday;
            m_Instance.updateTime = _data.updateTime;
			[_data release];
        }
    }
    return m_Instance;
}

#pragma mark - Encode - Decode

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:userID forKey:STRING_CODER_FB_USER_ID];
	[encoder encodeObject:name forKey:STRING_CODER_FB_NAME];
	[encoder encodeObject:fName forKey:STRING_CODER_FB_FIRST_NAME];
	[encoder encodeObject:lName forKey:STRING_CODER_FB_LAST_NAME];
	[encoder encodeObject:pictureURL forKey:STRING_CODER_FB_PICTURE];
	[encoder encodeObject:email forKey:STRING_CODER_FB_EMAIL];
	[encoder encodeObject:accessToken forKey:STRING_CODER_FB_ACCESS_TOKEN];
	[encoder encodeBool:loginStatus forKey:STRING_CODER_FB_LOGIN_STATUS];
    [encoder encodeObject:gender forKey:STRING_CODER_FB_GENDER];
    [encoder encodeObject:about forKey:STRING_CODER_FB_ABOUT];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.userID = [decoder decodeObjectForKey:STRING_CODER_FB_USER_ID];
        self.name = [decoder decodeObjectForKey:STRING_CODER_FB_NAME];
		self.fName = [decoder decodeObjectForKey:STRING_CODER_FB_FIRST_NAME];
        self.lName = [decoder decodeObjectForKey:STRING_CODER_FB_LAST_NAME];
		self.pictureURL = [decoder decodeObjectForKey:STRING_CODER_FB_PICTURE];
        self.email = [decoder decodeObjectForKey:STRING_CODER_FB_EMAIL];
		self.accessToken = [decoder decodeObjectForKey:STRING_CODER_FB_ACCESS_TOKEN];
        self.loginStatus = [decoder decodeBoolForKey:STRING_CODER_FB_LOGIN_STATUS];
        self.gender = [decoder decodeObjectForKey:STRING_CODER_FB_GENDER];
        self.about = [decoder decodeObjectForKey:STRING_CODER_FB_ABOUT];
    }
    return self;
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:STRING_USER_DEFAULT_FACEBOOK_DATA_MANAGER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - APIRequester Protocol
- (void)requestFailed:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type
{
    if (type == ENUM_API_REQUEST_TYPE_FB_GET_PROFILE) {
        NSLog(@"getMyFacebookProfileFail");
        self.loginStatus = NO;
		[self save];
    }
    
    [m_AlertFBLoginFail show];
    m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FAIL;
}
- (void)requestFinished:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type
{
    if (type == ENUM_API_REQUEST_TYPE_FB_GET_PROFILE) {
        NSString *responseString = [request responseString];
        NSLog(@"getMyFacebookProfileFinished: %@",responseString);
        
        NSMutableDictionary *responseJSON = [responseString JSONValue];
        if (responseJSON) {
			self.userID = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_ID];
            self.name = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_NAME];
            self.pictureURL = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_PICTURE];
			self.fName = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_F_NAME];
            self.lName = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_L_NAME];
            self.email = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_EMAIL];
            self.gender = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_GENDER];
            if (self.gender == nil) {
                self.gender = [NSString stringWithFormat:@""];
            }
			self.about = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_ABOUT];
            if (self.about == nil) {
                self.about = [NSString stringWithFormat:@""];
            }
            // get birthday and update time
            NSString *tempStr = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_BIRTHDAY];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            if(tempStr)
                self.birthday = [dateFormatter dateFromString:tempStr];
            else
                self.birthday = nil;
            
            tempStr = [responseJSON objectForKey:STRING_RESPONSE_KEY_FB_UPDATETIME];
            if(tempStr)
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
                self.updateTime = [dateFormatter dateFromString:tempStr];
            }
            else
                self.updateTime = nil;
            
			if (userID && name) {
				self.loginStatus = YES;
				[self save];
                [self changeBackToPreviousViewController];
                m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FINISH;
			}
            else {
                NSLog(@"userID || name = nil");
                self.loginStatus = NO;
                [self save];
                [m_AlertFBLoginFail show];
                m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FAIL;
            }
        }
        else{
            NSLog(@"responseJSON = nil || empty");
            self.loginStatus = NO;
			[self save];
            [m_AlertFBLoginFail show];
            m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FAIL;
        }
    }
}

#pragma mark - FBFunLoginDialog Protocol
- (void)accessTokenFound:(NSString *)apiKey
{
    NSLog(@"FB screen: accessTokenFound finish is = %@", apiKey);
    self.accessToken = apiKey;
	[self save];
    
    [_FBLoginDialogVC isLoadingView:YES];
  
    NSString *strURLString = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", accessToken];
    [_APIRequester requestWithType:ENUM_API_REQUEST_TYPE_FB_GET_PROFILE andURL:strURLString andDelegate:self];
    
//    NSString *strURL = @"https://graph.facebook.com/me?";
//    NSMutableDictionary *dicPost = [NSMutableDictionary new];
//    
//    [dicPost setValue:@"name,id,picture" forKey:@"fields"];
//    [dicPost setValue:USER_DEFAULT_FB_ACCESSTOKEN forKey:@"access_token"];
//    
//    [[APIRequester Shared] requestWithType:ENUM_API_REQUEST_TYPE_FB_GET_PROFILE andStringURL:strURL andDictionaryPost:dicPost andDelegate:self];
}
- (void)displayRequired
{
    if (m_FBFunLoginManagerStep == ENUM_FB_FUN_LOGIN_MANAGER_STEP_DISPLAYED) {
        NSLog(@"FB screen: displayed before");
        return;
    }
    else if (m_FBFunLoginManagerStep == ENUM_FB_FUN_LOGIN_MANAGER_STEP_START) {
        m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_DISPLAY_REQUIRED;
        NSLog(@"FB screen: displayRequired");
    }
}
- (void)loginFail
{
    NSLog(@"FB screen: loginFail");
    
    if (m_FBFunLoginManagerStep == ENUM_FB_FUN_LOGIN_MANAGER_STEP_START) {
        
        [m_AlertFBLoginFail show];
        m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_FAIL;
    }
}
- (void)clickBack
{
    NSLog(@"FB screen: clickBack");
    [self changeBackToPreviousViewController];
    m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_CANCEL;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self changeBackToPreviousViewController];
    m_FBFunLoginManagerStep = ENUM_FB_FUN_LOGIN_MANAGER_STEP_LOGIN_CANCEL;
}

@end
