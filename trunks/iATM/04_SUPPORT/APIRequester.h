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

#define STRING_REQUEST_ROOT                                                 @"http://atm.rs.af.cm"

#define TIMER_REQUEST_TIMEOUT                                               60


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// USER
#define STRING_REQUEST_URL_GET_NEAREST_ATM                                   [NSString stringWithFormat:@"%@/atm/distance", STRING_REQUEST_ROOT]

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

#define STRING_REQUEST_KEY_LONGTITUDE                                  @"longtitude"
#define STRING_REQUEST_KEY_LATTITUDE                                   @"lattitude"
#define STRING_REQUEST_KEY_NUMBER                                      @"number"

#define STRING_RESPONSE_KEY_MSG                                         @"msg"
#define STRING_RESPONSE_KEY_OK                                          @"ok"
#define STRING_RESPONSE_KEY_RESULTS                                     @"results"

#define kSqliteFileName @"iATM_DB"

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
