//
//  APIRequester.h
//  VFA_QUEUENCE
//
//  Created by Phan Ba Minh on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#ifdef __DEV1__
#define STRING_REQUEST_ROOT                                                 @"http://taxivnapi.rs.af.cm"
//#define STRING_REQUEST_ROOT                                                    @"http://192.168.2.72:3001"
//#define STRING_REQUEST_ROOT                                                 @"http://aws-aigo-api.ap01.aws.af.cm"
#endif
#ifdef __DEV2__
#define STRING_REQUEST_ROOT                                                 @"http://aigo-api.herokuapp.com"
#endif

#ifdef __DRIVER__
#define STRING_REQUEST_USERTYPE                                             @"driver"
#endif

#ifdef __CLIENT__
#define STRING_REQUEST_USERTYPE                                             @"client"
#endif


//#define STRING_REQUEST_ROOT                                                 @"http://dev.visikard.com:6868/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://dev1.visikard.com:6868/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://192.168.2.83:8080/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://khanh-pc:8080/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://192.168.2.150:8080/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://lcalserver.visikard.vn/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://staging1.visikard.com:6868/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://216.119.157.11:6868/vk4"
//#define STRING_REQUEST_ROOT                                                 @"http://216.119.158.150:6868/vk4"

#ifndef STRING_REQUEST_ROOT
#define STRING_REQUEST_ROOT                                                 @"http://taxivnapi.rs.af.cm"
#endif

#define TIMER_REQUEST_TIMEOUT                                               60

//http://dev1.visikard.com:6868/vk4/serversetupinfo/2


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// USER
#define STRING_REQUEST_URL_USER_LOGIN                                   [NSString stringWithFormat:@"%@/accounts/%@/login", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_USER_LOGOUT                                  [NSString stringWithFormat:@"%@/accounts/%@/logout", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_REGISTRY_ACCOUNT                             [NSString stringWithFormat: @"%@/accounts/%@/signup", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]

#define STRING_REQUEST_URL_USER_LOGIN_USERNAME_EMAIL                    [NSString stringWithFormat:@"%@/accounts/login/email/username", STRING_REQUEST_ROOT]
#define STRING_REQUEST_URL_USER_UPDATE_LOCATION_AND_GPS                 [NSString stringWithFormat:@"%@/accounts/%@/location", STRING_REQUEST_ROOT, STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_USER_CHANGE_PASSWORD                         [NSString stringWithFormat:@"%@/accounts/change/password", STRING_REQUEST_ROOT]
#define STRING_REQUEST_URL_USER_RECOVERY_PASSWORD                       [NSString stringWithFormat:@"%@/accounts/forget/password/user", STRING_REQUEST_ROOT]
#define STRING_REQUEST_URL_USER_FORGET_PASSWORD                         [NSString stringWithFormat:@"%@/accounts/recovery/forget/password", STRING_REQUEST_ROOT]

// Push notification
#define STRING_REQUEST_URL_USER_UPDATE_DEVICE_TOKEN_DRIVER              [NSString stringWithFormat:@"%@/accounts/driver/updatedevicetoken", STRING_REQUEST_ROOT]
// CLIENT
#define STRING_REQUEST_URL_CLIENT_CLOSEST_DRIVER                        [NSString stringWithFormat:@"%@/locations/%@/distance", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_CLIENT_REQUEST_CLOSEST_DRIVER                [NSString stringWithFormat:@"%@/transactions/%@/request", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_CLIENT_REQUEST_THIS_DRIVER                   [NSString stringWithFormat:@"%@/transactions/%@/requestthisdriver", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_CLIENT_CANCEL_THE_REQUEST                    [NSString stringWithFormat:@"%@/transactions/%@/cancelrequest", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_CLIENT_CANCEL_THIS_TRANSACTION               [NSString stringWithFormat:@"%@/transactions/%@/canceltransaction", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]
#define STRING_REQUEST_URL_CLIENT_CHARGE_BILL                           [NSString stringWithFormat:@"%@/transactions/%@/confirmbill", STRING_REQUEST_ROOT,STRING_REQUEST_USERTYPE]

// DRIVER
#define STRING_REQUEST_URL_DRIVER_ACCEPT_THIS_TRANSACTION               [NSString stringWithFormat:@"%@/transactions/driver/accept", STRING_REQUEST_ROOT]
#define STRING_REQUEST_URL_DRIVER_CANCEL_THIS_TRANSACTION               [NSString stringWithFormat:@"%@/transactions/driver/cancel", STRING_REQUEST_ROOT]
#define STRING_REQUEST_URL_DRIVER_NOTIFY_YOUR_ARRIVAL                   [NSString stringWithFormat:@"%@/transactions/driver/arrival", STRING_REQUEST_ROOT]
#define STRING_REQUEST_URL_DRIVER_BEGIN_TRIP                            [NSString stringWithFormat:@"%@/transactions/driver/begintrip", STRING_REQUEST_ROOT]
#define STRING_REQUEST_URL_DRIVER_FINISH_TRIP                           [NSString stringWithFormat:@"%@/transactions/driver/finishtrip", STRING_REQUEST_ROOT]

// LOGIN, REQUEST
#define STRING_REQUEST_KEY_USER_NAME                                    @"username"
#define STRING_REQUEST_KEY_PASSWORD                                     @"password"
#define STRING_REQUEST_KEY_FK_USER                                      @"fkUser"
#define STRING_REQUEST_KEY_LATITUDE                                     @"latitude"
#define STRING_REQUEST_KEY_LONGITUDE                                    @"longitude"
#define STRING_REQUEST_KEY_SESSION_ID                                   @"sessionID"
#define STRING_REQUEST_KEY_SESSION                                      @"session"
#define STRING_REQUEST_KEY_GPS                                          @"gps"
#define STRING_REQUEST_KEY_F_NAME										@"fname"
#define STRING_REQUEST_KEY_L_NAME										@"lname"
#define STRING_REQUEST_KEY_EMAIL										@"email"
#define STRING_REQUEST_KEY_FULL_NAME                                    @"fullName"
#define STRING_REQUEST_KEY_PROFILE_NAME                                 @"profilename"
#define STRING_REQUEST_KEY_GENDER										@"gender"
#define STRING_REQUEST_KEY_ABOUT										@"about"
#define STRING_REQUEST_KEY_FK_KARD										@"fkKard"
#define STRING_REQUEST_KEY_USER_NAME_EMAIL                              @"usernameemail"
#define STRING_REQUEST_KEY_AGE                                          @"age"
#define STRING_REQUEST_KEY_LOC                                          @"loc"

#define STRING_REQUEST_KEY_NAME                                         @"name"
#define STRING_REQUEST_KEY_EMAIL                                        @"email"
#define STRING_REQUEST_KEY_USER                                         @"user"
#define STRING_REQUEST_KEY_PASS                                         @"pass"
#define STRING_REQUEST_KEY_DEVICE_TOKEN                                 @"devicetoken"
#define STRING_REQUEST_KEY_OLD_DEVICE_TOKEN                             @"olddevicetoken"
#define STRING_REQUEST_KEY_NEW_DEVICE_TOKEN                             @"newdevicetoken"
#define STRING_REQUEST_KEY_COUNTRY                                      @"country"
#define STRING_REQUEST_KEY_USER_TYPE                                    @"usertype"
#define STRING_REQUEST_KEY_MESSAGE                                      @"messages"
#define STRING_REQUEST_KEY_NUMBER                                       @"number"
#define STRING_REQUEST_KEY_SEAT                                         @"seat"

#define STRING_REQUEST_KEY_CLIENT                                       @"Client"
#define STRING_REQUEST_KEY_DRIVER                                       @"Driver"

// CLIENT, REQUEST
#define STRING_REQUEST_KEY_ALERT                                        @"alert"
#define STRING_REQUEST_KEY_BADGE                                        @"badge"
#define STRING_REQUEST_KEY_SOUND                                        @"sound"
#define STRING_REQUEST_KEY_DRIVER_ID                                    @"driverid"

// UPDATE LOCATION, REQUEST
#define STRING_REQUEST_KEY_CURRENT_LOCATION                             @"loc"
#define STRING_REQUEST_KEY_CLIENT_ID                                    @"clientid"
#define STRING_REQUEST_KEY_PRICE                                        @"price"

// LOGIN, RESPONSE
#define STRING_RESPONSE_KEY_STATUS                                      @"status"
#define STRING_RESPONSE_KEY_RESULT                                      @"result"
#define STRING_RESPONSE_KEY_SESSION_ID                                  @"sessionID"
#define STRING_RESPONSE_KEY__ID                                         @"_id"
#define STRING_RESPONSE_KEY_USER_ID                                     @"idUsers"
#define STRING_RESPONSE_KEY_USER                                        @"user"
#define STRING_RESPONSE_KEY_USER_NAME                                   @"username"
#define STRING_RESPONSE_KEY_MESSAGE_LOGIN                               @"messageLogin"
#define STRING_RESPONSE_KEY_F_NAME_LOGIN                                @"fname"
#define STRING_RESPONSE_KEY_L_NAME_LOGIN                                @"lname"
#define STRING_RESPONSE_KEY_FULL_NAME_LOGIN                             @"fullName"
#define STRING_RESPONSE_KEY_SORT_MY_KARD                                @"sortMyKard"
#define STRING_RESPONSE_KEY_SHOW_UNREAD                                 @"showUnread"
#define STRING_RESPONSE_KEY_USER_VISIBLE                                @"userVisible"
#define STRING_RESPONSE_KEY_PASSWORD                                    @"password"
#define STRING_RESPONSE_KEY_POINT_USER                                  @"pointUser"
#define STRING_RESPONSE_KEY_MSG                                         @"msg"
#define STRING_RESPONSE_KEY_OK                                          @"ok"

// COUNTRY
#define STRING_RESPONSE_KEY_ID                                          @"id"
#define STRING_RESPONSE_KEY_CODE                                        @"code"

// BANNER ADS
#define STRING_RESPONSE_KEY_BANNER_IMAGE_URL                            @"adsUrl"
#define STRING_RESPONSE_KEY_BANNER_ADS_ID                               @"adsId"

// CLIENT, RESPONSE
#define STRING_RESPONSE_KEY_RESULTS                                     @"results"
#define STRING_RESPONSE_KEY_NAME                                        @"name"
#define STRING_RESPONSE_KEY_OBJ                                         @"obj"
#define STRING_RESPONSE_KEY_LOC                                         @"loc"
#define STRING_RESPONSE_KEY_EMAIL                                       @"email"
#define STRING_RESPONSE_KEY_DRIVER_ID                                   @"driverid"
#define STRING_RESPONSE_KEY_PRICE                                       @"price"

// DRIVER, RESPONSE
#define STRING_RESPONSE_KEY_CLIENT_ID                                   @"clientid"

// FB
#define STRING_RESPONSE_KEY_FB_NAME                                     @"name"
#define STRING_RESPONSE_KEY_FB_ID                                       @"id"
#define STRING_RESPONSE_KEY_FB_PICTURE                                  @"picture"
#define STRING_RESPONSE_KEY_FB_F_NAME									@"first_name"
#define STRING_RESPONSE_KEY_FB_L_NAME									@"last_name"
#define	STRING_RESPONSE_KEY_FB_EMAIL									@"email"
#define	STRING_RESPONSE_KEY_FB_GENDER									@"gender"
#define	STRING_RESPONSE_KEY_FB_ABOUT									@"about"
#define	STRING_RESPONSE_KEY_FB_BIRTHDAY									@"birthday"
#define	STRING_RESPONSE_KEY_FB_UPDATETIME								@"updated_time"

// TW
#define STRING_RESPONSE_KEY_TW_NAME                                     @"name"
#define STRING_RESPONSE_KEY_TW_GENDER                                   @"gender"
#define STRING_RESPONSE_KEY_TW_ABOUT                                    @"about"

// DATA
#define STRING_REQUEST_KEY_CONTENT_TYPE_IMAGE_JPEG                      @"image/jpeg"
#define STRING_REQUEST_KEY_FILE                                         @"file"

// OTHERS
#define INT_RESPONSE_CODE_FINISH                                        200
#define INT_RESPONSE_CODE_CONNECTION_ERROR                              1000
#define STRING_RESPONSE_CODE_SUCCESS                                    @"SUCCESS"
#define STRING_RESPONSE_CODE_FAILER                                     @"FAILER"
#define STRING_RESPONSE_CODE_EXIST                                      @"EXIST"
#define STRING_RESPONSE_CODE_ACCEPTED                                   @"ACCEPTED"
#define STRING_RESPONSE_CODE_NOTALLOW                                   @"NOTALLOW"

#define RELOAD_FEEDS                                                    @"reload"
#define MAIL_NOT_SEND                                                   @"Email not send."

#define STRING_ALERT_CONNECTION_ERROR_TITLE                             @"Offline"
#define STRING_ALERT_CONNECTION_ERROR									@"Sorry, this function is not available in offline mode.  Please connect to the internet to perform this function"
//#define STRING_ALERT_SERVER_ERROR                                       @"Sorry, server's response is not in the format"
#define STRING_ALERT_SERVER_ERROR                                       @"We are sorry, the AiGo server is temporarily offline for an upgrade...We will be back within the next few minutes. Please try again."

#define STRING_ALERT_DATA_IS_NIL										@"DATA is nil"

// MESSAGE
#define STRING_RESPONSE_KEY_SUCCESS                                     @"SUCCESS"
#define STRING_RESPONSE_KEY_INVALID                                     @"INVALID"
#define STRING_RESPONSE_KEY_FAILURE                                     @"FAILURE"
#define STRING_RESPONSE_KEY_EMPTY                                       @"EMPTY"


#define kSqliteFileName @"VisiKard"

@protocol APIRequesterProtocol <NSObject>

@optional

- (void)requestFailed:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type;
- (void)requestFinished:(ASIHTTPRequest *)request andType:(ENUM_API_REQUEST_TYPE)type;
- (void)requestTimeoutWithType:(ENUM_API_REQUEST_TYPE)type;
- (void)requestRetried:(ENUM_API_REQUEST_TYPE)type;

@end

@interface APIRequester : NSObject <ASIHTTPRequestDelegate, AppViewControllerProtocol, UIAlertViewDelegate>
{
    ENUM_API_REQUEST_TYPE                               m_RequestType;
    ASIHTTPRequest                                      *m_ASIRequest;
    
    id<APIRequesterProtocol>                              m_Delegate;
    
    ENUM_API_REQUESTER_STEP                             m_RequestStep;
    CFAbsoluteTime                                      m_TimerRequest;
    UIAlertView                                         *m_AlertFail;
    NSString                                            *m_StringURL;
    
    ASIFormDataRequest                                  *m_ASIFormRequest;
    NSMutableDictionary                                 *m_ParamsDic;
}
- (void)requestWithType:(ENUM_API_REQUEST_TYPE)type andURL:(NSString *)url andDelegate:(id)delegate;
- (void)requestWithType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL andPostMethodKind:(BOOL)methodKind andParams:(NSMutableDictionary *)params andDelegate:(id)delegate;
- (void)requestWithType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL andPostMethodKind:(BOOL)methodKind andParams:(NSMutableDictionary *)params andImageData:(NSData *)data andDelegate:(id)delegate;
- (void)requestMultiPartRequestType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL
                  andPostMethodKind:(BOOL)methodKind
                          andParams:(NSArray *)params
                            andKeys:(NSArray*)keysArr
                        andDelegate:(id)delegate;

- (void)videoRequestMultiPartRequestType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL
                       andPostMethodKind:(BOOL)methodKind
                               andParams:(NSArray *)params
                                 andKeys:(NSArray*)keysArr
                             andDelegate:(id)delegate;

- (void)requestSimpleRequestType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL
               andPostMethodKind:(BOOL)methodKind
                       andParams:(NSArray *)params
                         andKeys:(NSArray*)keysArr
                     andDelegate:(id)delegate;

- (void)cancelRequest;
+ (APIRequester *)Shared;
@end
