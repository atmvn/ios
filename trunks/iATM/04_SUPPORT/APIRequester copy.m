//
//  APIRequester.m
//  VFA_QUEUENCE
//
//  Created by Phan Ba Minh on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "APIRequester.h"

@implementation APIRequester
- (id)init{
    self = [super init];
    if (self) {
        m_ASIRequest = [ASIHTTPRequest new];
        m_ASIFormRequest = [ASIFormDataRequest new];
        m_AlertFail = [[UIAlertView alloc] initWithTitle:STRING_ALERT_CONNECTION_ERROR_TITLE message:STRING_ALERT_CONNECTION_ERROR delegate:self cancelButtonTitle:STRING_ALERT_RETRY otherButtonTitles:STRING_ALERT_CANCEL, nil];
        
        // Stop anything already in the queue before removing it
        //[m_networkQueue cancelAllOperations];
        
        // Creating a new queue each time we use it means we don't have to worry about clearing delegates or resetting progress tracking
        m_networkQueue = [ASINetworkQueue queue];
        [m_networkQueue setDelegate:self];
        [m_networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        [m_networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [m_networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    }
    return self;
}
- (void)dealloc {
    m_Delegate = nil;
    [m_ASIRequest clearDelegatesAndCancel];
    [m_ASIFormRequest clearDelegatesAndCancel];
    RELEASE_SAFE(m_ASIRequest);
    RELEASE_SAFE(m_AlertFail);
    RELEASE_SAFE(m_StringURL);
    RELEASE_SAFE(m_ASIFormRequest);
    RELEASE_SAFE(m_ParamsDic);
    [super dealloc];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFailed:(ASIHTTPRequest *)request {
//    NSLog(@" requestFailed ");
    if ([m_Delegate respondsToSelector:@selector(requestFailed:andType:)]) {
        [m_Delegate requestFailed:request andType:request.tag];
    }
    m_RequestStep = ENUM_API_REQUESTER_STEP_FAILED;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
//	NSLog(@" requestFinished ");
    if ([m_Delegate respondsToSelector:@selector(requestFinished:andType:)]) {
        [m_Delegate requestFinished:request andType:request.tag];
    }
    m_RequestStep = ENUM_API_REQUESTER_STEP_FINISHED;
}

- (void)queueFinished:(ASINetworkQueue *)queue {
    VKLog(@" Queue finished");
    // You could release the queue here if you wanted
//	if ([m_networkQueue requestsCount] == 0) {
//		m_networkQueue = nil;
//	}

    if ([m_Delegate respondsToSelector:@selector(queueFinished:)]) {
        [m_Delegate queueFinished:queue];
    }
    m_RequestStep = ENUM_API_REQUESTER_STEP_FINISHED;
}

//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data	{
//	NSLog(@" didReceiveData ");
//}
//
//- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
//	NSLog(@" didReceiveResponseHeaders ");
//}
//
//- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
//	NSLog(@" willRedirectToURL ");
//}
//
//- (void)requestRedirected:(ASIHTTPRequest *)request {
//	NSLog(@" requestRedirected ");
//}
//
//- (void)requestStarted:(ASIHTTPRequest *)request {
//	NSLog(@" requestStarted ");
//}

#pragma mark - Methods

- (void)requestWithType:(ENUM_API_REQUEST_TYPE)type andURL:(NSString *)url andDelegate:(id)delegate
{
    if (url == nil || delegate == nil) {
        return;
    }
    
    if (m_ASIRequest) {
        [m_ASIRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIRequest);
    }
    if (m_ASIFormRequest) {
        [m_ASIFormRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIFormRequest);
    }
    if (m_ParamsDic) {
        RELEASE_SAFE(m_ParamsDic);
    }
    if (![m_StringURL isEqualToString:url]) {
        RELEASE_SAFE(m_StringURL);
        m_StringURL = [url retain];
    }
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    
    NSLog(@"URL before: %@", url);
    NSString *stringURL;

    {
        stringURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"URL after: %@", stringURL);
        m_ASIRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:stringURL]];
        [m_ASIRequest setDelegate:self];
//        [m_ASIRequest setDidFailSelector:@selector(requestFailed)];
//        [m_ASIRequest setDidFinishSelector:@selector(requestFinished:)];
        m_ASIFormRequest.tag = type;
        m_ASIRequest.tag = type;  
        [m_ASIRequest setValidatesSecureCertificate:NO];
		[m_ASIRequest setTimeOutSeconds:TIMER_REQUEST_TIMEOUT];
        [m_ASIRequest startAsynchronous];
    }
}

- (void)requestWithType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL andPostMethodKind:(BOOL)methodKind andParams:(NSMutableDictionary *)params andDelegate:(id)delegate
{
    if (delegate == nil) {
        return;
    }
    
    if (m_ASIRequest) {
        [m_ASIRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIRequest);
    }
    if (m_ASIFormRequest) {
        [m_ASIFormRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIFormRequest);
    }
    if (m_StringURL) {
        RELEASE_SAFE(m_StringURL);
    }
    if (m_ParamsDic) {
        RELEASE_SAFE(m_ParamsDic);
    }
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    m_StringURL = STRING_REQUEST_ROOT;
    
    NSLog(@"rootURL: %@", rootURL);
    {
        m_ASIFormRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:rootURL]];
        [m_ASIFormRequest setDelegate:self];
//        [m_ASIFormRequest setDidFailSelector:@selector(requestFailed)];
//        [m_ASIFormRequest setDidFinishSelector:@selector(requestFinished:)];
        
        if (methodKind == YES) {
            [m_ASIFormRequest setRequestMethod:@"POST"];
            
            NSLog(@"POST ");
        }
        if (params) {
            for (int i = 0; i < [params allKeys].count; i++) {
                [m_ASIFormRequest setPostValue:[[params allValues] objectAtIndex:i]  forKey:[[params allKeys] objectAtIndex:i]];
                NSLog(@"VALUE: %@; KEY: %@", [[params allValues] objectAtIndex:i], [[params allKeys] objectAtIndex:i]);
            }
        }
        m_ASIFormRequest.tag = type;
        m_ASIRequest.tag = type; 
        [m_ASIRequest setValidatesSecureCertificate:NO];
		[m_ASIFormRequest setTimeOutSeconds:TIMER_REQUEST_TIMEOUT];
        [m_ASIFormRequest startAsynchronous];
    }
}

- (void)requestMultiPartRequestType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL 
      andPostMethodKind:(BOOL)methodKind 
              andParams:(NSArray *)params 
                andKeys:(NSArray*)keysArr
            andDelegate:(id)delegate
{
    if (delegate == nil) {
        return;
    }
    
    if (m_ASIRequest) {
        [m_ASIRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIRequest);
    }
    if (m_ASIFormRequest) {
        [m_ASIFormRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIFormRequest);
    }
    if (m_StringURL) {
        RELEASE_SAFE(m_StringURL);
    }
    if (m_ParamsDic) {
        RELEASE_SAFE(m_ParamsDic);
    }
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    m_StringURL = STRING_REQUEST_ROOT;
    NSObject *object;
    NSLog(@"rootURL: %@", rootURL);
    {
        m_ASIFormRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:rootURL]];
        [m_ASIFormRequest setDelegate:self];
         [m_ASIFormRequest setPostFormat:ASIMultipartFormDataPostFormat];
        
        if (methodKind == YES) {
            [m_ASIFormRequest setRequestMethod:@"POST"];
        }
        if (params) {
            for (int i = 0; i < params.count; i++) {
                object = [params objectAtIndex:i];
                if ([[object.class description] isEqualToString:STRING_COMPARED_NSCONCRTEMUTABLEDATA]) {
                    [m_ASIFormRequest setData:object withFileName:[NSString stringWithFormat:@"%@", [SupportFunction stringFromDateUseForName:[NSDate date]]] andContentType:@"image/jpeg" forKey:[keysArr objectAtIndex:i]];
                    
                }
            else {
                [m_ASIFormRequest setPostValue:[params objectAtIndex:i]  forKey:[keysArr objectAtIndex:i]];
            }
            }
        }
        m_ASIFormRequest.tag = type;
        m_ASIRequest.tag = type; 
        [m_ASIRequest setValidatesSecureCertificate:NO];
		[m_ASIFormRequest setTimeOutSeconds:TIMER_REQUEST_TIMEOUT];
        [m_ASIFormRequest startAsynchronous];
    }
}

/////////////////////

- (void)requestSimpleRequestType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL 
                  andPostMethodKind:(BOOL)methodKind 
                          andParams:(NSArray *)params 
                            andKeys:(NSArray*)keysArr
                        andDelegate:(id)delegate
{
    if (delegate == nil) {
        return;
    }
    
    if (m_ASIRequest) {
        [m_ASIRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIRequest);
    }
    if (m_ASIFormRequest) {
        [m_ASIFormRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIFormRequest);
    }
    if (m_StringURL) {
        RELEASE_SAFE(m_StringURL);
    }
    if (m_ParamsDic) {
        RELEASE_SAFE(m_ParamsDic);
    }
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    m_StringURL = STRING_REQUEST_ROOT;
    //NSObject *object;
    NSLog(@"rootURL: %@", rootURL);
    {
        m_ASIFormRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:rootURL]];
        [m_ASIFormRequest setDelegate:self];
       // [m_ASIFormRequest setPostFormat:ASIMultipartFormDataPostFormat];
        
        if (methodKind == YES) {
            [m_ASIFormRequest setRequestMethod:@"POST"];
        }
        if (params) {
            for (int i = 0; i < params.count; i++) {
                //object = [params objectAtIndex:i];
                
                [m_ASIFormRequest setPostValue:[params objectAtIndex:i]  forKey:[keysArr objectAtIndex:i]];
                
            }
        }
        m_ASIFormRequest.tag = type;
        m_ASIRequest.tag = type; 
        [m_ASIRequest setValidatesSecureCertificate:NO];
		[m_ASIFormRequest setTimeOutSeconds:TIMER_REQUEST_TIMEOUT];
        [m_ASIFormRequest startAsynchronous];
    }
}

#pragma mark Video Multipart request
- (void)videoRequestMultiPartRequestType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL 
                  andPostMethodKind:(BOOL)methodKind 
                          andParams:(NSArray *)params 
                            andKeys:(NSArray*)keysArr
                        andDelegate:(id)delegate
{
    if (delegate == nil) {
        return;
    }
    
    if (m_ASIRequest) {
        [m_ASIRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIRequest);
    }
    if (m_ASIFormRequest) {
        [m_ASIFormRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIFormRequest);
    }
    if (m_StringURL) {
        RELEASE_SAFE(m_StringURL);
    }
    if (m_ParamsDic) {
        RELEASE_SAFE(m_ParamsDic);
    }
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    m_StringURL = STRING_REQUEST_ROOT;
    id object;
    NSLog(@"rootURL: %@", rootURL);
    {
        m_ASIFormRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:rootURL]];
        [m_ASIFormRequest setDelegate:self];
        [m_ASIFormRequest setPostFormat:ASIMultipartFormDataPostFormat];
        
        if (methodKind == YES) {
            [m_ASIFormRequest setRequestMethod:@"POST"];
        }
        if (params) {
            for (int i = 0; i < params.count; i++) {
                object = [params objectAtIndex:i];
                if ([object isKindOfClass:[NSData class]]) {

                    [m_ASIFormRequest setData:object forKey:[keysArr objectAtIndex:i]];
                    
                }
                else {
                    [m_ASIFormRequest setPostValue:[params objectAtIndex:i]  forKey:[keysArr objectAtIndex:i]];
                }
            }
        }
        [m_ASIRequest setValidatesSecureCertificate:NO];
		[m_ASIFormRequest setTimeOutSeconds:TIMER_REQUEST_TIMEOUT];
        [m_ASIFormRequest startAsynchronous];
    }
}

#pragma mark --

- (void)requestWithType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL andPostMethodKind:(BOOL)methodKind andParams:(NSMutableDictionary *)params andImageData:(NSData *)data andDelegate:(id)delegate
{
    if (delegate == nil) {
        return;
    }
    
    if (m_ASIRequest) {
        [m_ASIRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIRequest);
    }
    if (m_ASIFormRequest) {
        [m_ASIFormRequest clearDelegatesAndCancel];
        RELEASE_SAFE(m_ASIFormRequest);
    }
    if (m_StringURL) {
        RELEASE_SAFE(m_StringURL);
    }
    if (m_ParamsDic) {
        RELEASE_SAFE(m_ParamsDic);
    }
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    m_StringURL = STRING_REQUEST_ROOT;
    
    NSLog(@"rootURL: %@", rootURL);
    {
        m_ASIFormRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:rootURL]];
        [m_ASIFormRequest setDelegate:self];
        
        if (methodKind == YES) {
            [m_ASIFormRequest setRequestMethod:@"POST"];
            
            NSLog(@"POST ");
        }
        if (params) {
            
            for (int i = 0; i < [params allKeys].count; i++) {
                [m_ASIFormRequest setPostValue:[[params allValues] objectAtIndex:i]  forKey:[[params allKeys] objectAtIndex:i]];
                NSLog(@"VALUE: %@; KEY: %@", [[params allValues] objectAtIndex:i], [[params allKeys] objectAtIndex:i]);
                
            }
        }
        if (data) {
            [m_ASIFormRequest setData:data withFileName:[NSString stringWithFormat:@"%@.jpg", [[SupportFunction stringFromDate:[NSDate date]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] andContentType:STRING_REQUEST_KEY_CONTENT_TYPE_IMAGE_JPEG forKey:STRING_REQUEST_KEY_FILE];
        }
        
// Trong Vu - Request Queue
- (void)queueWithType:(ENUM_API_REQUEST_TYPE)type andRootURL:(NSString *)rootURL andPostMethodKind:(BOOL)methodKind andParams:(NSMutableDictionary *)params andDelegate:(id)delegate
{
    if (delegate == nil) {
        return;
    }
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    m_StringURL = STRING_REQUEST_ROOT;
    
    VKLog(@"rootURL: %@", rootURL);
    {
        m_ASIFormRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:rootURL]];
        [m_ASIFormRequest setDelegate:self];
        
        if (methodKind == YES) {
            [m_ASIFormRequest setRequestMethod:@"POST"];
            
            VKLog(@"POST ");
        }
        if (params) {
            for (int i = 0; i < [params allKeys].count; i++) {
                [m_ASIFormRequest setPostValue:[[params allValues] objectAtIndex:i]  forKey:[[params allKeys] objectAtIndex:i]];
                VKLog(@"VALUE: %@; KEY: %@", [[params allValues] objectAtIndex:i], [[params allKeys] objectAtIndex:i]);
            }
        }
        m_ASIFormRequest.tag = type;
        m_ASIRequest.tag = type; 
        [m_ASIRequest setValidatesSecureCertificate:NO];
		[m_ASIFormRequest setTimeOutSeconds:TIMER_REQUEST_TIMEOUT];
        
        [m_networkQueue addOperation:m_ASIFormRequest];
    }
}

-(void) startQueue {
    [m_networkQueue go];
    }

// Trong Vu - Upload Object to S3
- (void)uploadToAS3Job:(ENUM_API_REQUEST_TYPE)type andPathName:(NSString *)pathName andFileName:(NSString *)fileName andData:(NSData *)objectData andTimeOut:(int)timeout andDelegate:(id)delegate
{
    [ASIS3Request setSharedSecretAccessKey:S3_SHARED_SECRECT_ACCESS_KEY_TEST];
    
    [ASIS3Request setSharedAccessKey:S3_SHARED_ACCESS_KEY_TEST];
    
    ASIS3ObjectRequest *request = [ASIS3ObjectRequest PUTRequestForData:objectData withBucket:S3_BUCKET_NAME_TEST key:[NSString stringWithFormat:@"%@/%@",pathName,fileName]];
    
    [request setShouldCompressRequestBody:YES]; //gzip compression
    
    m_RequestType = type;
    m_Delegate = delegate;
    m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST;
    
    request.delegate = self;
    request.tag = type;
    request.timeOutSeconds = timeout;
    [request startAsynchronous];
    
//    [request startSynchronous];    
//    if ([request error]) {
//        
//        VKLog(@"%@",[[request error] localizedDescription]);
//        
//    }

}

#pragma mark - APIRequester Protocol
- (void)update
{
    switch (m_RequestStep) {
        case ENUM_API_REQUESTER_STEP_REQUEST:
            m_TimerRequest = CFAbsoluteTimeGetCurrent();
            m_RequestStep = ENUM_API_REQUESTER_STEP_REQUEST_WAITING;
            break;
        case ENUM_API_REQUESTER_STEP_REQUEST_WAITING:
            if (CFAbsoluteTimeGetCurrent() - m_TimerRequest > TIMER_REQUEST_TIMEOUT) {
                m_RequestStep = ENUM_API_REQUESTER_STEP_TIMEOUT;
            }
            break;
        case ENUM_API_REQUESTER_STEP_FAILED:
            [m_AlertFail show];
            m_RequestStep = ENUM_API_REQUESTER_STEP_ALERT_SHOWING;
            break;
        case ENUM_API_REQUESTER_STEP_FINISHED:
            
            break;
        case ENUM_API_REQUESTER_STEP_TIMEOUT:
            NSLog(@" ENUM_API_REQUESTER_STEP_TIMEOUT ");
            [m_ASIRequest clearDelegatesAndCancel];
            if ([m_Delegate respondsToSelector:@selector(requestTimeoutWithType:)]) {
                [m_Delegate requestTimeoutWithType:m_RequestType];
            }
            m_RequestStep = ENUM_API_REQUESTER_STEP_FAILED;
            break;
        case ENUM_API_REQUESTER_STEP_END:
            
            break;
            
        default:
            break;
    }
}
- (void)cancelRequest
{
    [m_ASIRequest clearDelegatesAndCancel];
    [m_ASIFormRequest clearDelegatesAndCancel];
    
    m_RequestStep = ENUM_API_REQUESTER_STEP_END;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([m_Delegate respondsToSelector:@selector(requestRetried:)]) {
            [m_Delegate requestRetried:m_RequestType];
        }
        [self requestWithType:m_RequestType andURL:m_StringURL andDelegate:m_Delegate];
    }
}
static APIRequester *m_Instance;
+ (APIRequester *)Shared
{
    if ( !m_Instance ) {
        m_Instance = [[APIRequester alloc] init];
    }
    return m_Instance;
}
@end
