//
//  FBFunLoginDialog.m
//  FBFun
//
//  Created by chinhly on 7/13/10.
//  Copyright 2010 Vitalify Asia. All rights reserved.
//

#import "FBFunLoginDialog.h"
#import "Define.h"

@implementation FBFunLoginDialog
@synthesize webView = _webView;
@synthesize apiKey = _apiKey;
@synthesize requestedPermissions = _requestedPermissions;
@synthesize delegate = _delegate;

#pragma mark - Main

- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<FBFunLoginDialogDelegate>)delegate {
    if ((self = [super initWithNibName:@"FBFunLoginDialog" bundle:[NSBundle mainBundle]])) {
        self.apiKey = apiKey;
        self.requestedPermissions = requestedPermissions;
        self.delegate = delegate;
    }
    return self;    
}

- (void)dealloc {
    self.webView = nil;
    self.apiKey = nil;
    self.requestedPermissions = nil;
    RELEASE_SAFE(m_LoadingView);
    [super dealloc];
}
- (void)isLoadingView:(BOOL)isLoading
{
    if (isLoading) {
        if (!m_LoadingView) {
            m_LoadingView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_TOOL_BAR, WIDTH_IPHONE, HEIGHT_IPHONE - HEIGHT_TOOL_BAR)];
            m_LoadingView.alpha = 0.4;
            UIActivityIndicatorView *actIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
            actIndicator.center = m_LoadingView.center;
            actIndicator.frame = FRAME_BOTTOM(actIndicator, 4*HEIGHT_TOOL_BAR);
            [actIndicator startAnimating];
            [m_LoadingView addSubview:actIndicator];
            [m_LoadingView setBackgroundColor:[UIColor blueColor]];
        }
        [self.view addSubview:m_LoadingView];
    }
    else
        [m_LoadingView removeFromSuperview];
}

#pragma mark - Login / Logout functions

- (void)login {
    [self isLoadingView:YES];
    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
       
    NSString *authFormatString = @"https://www.facebook.com/dialog/oauth/?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch&response_type=token";
       
    NSString *urlString = [NSString stringWithFormat:authFormatString, _apiKey, STRING_FB_REDIRECT_URL, _requestedPermissions];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];
    [_webView loadRequest:request];	
}

-(void)logout {    

    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
}

- (void)logintimeout:(id)sender {
	
	if (isFinishLoading) {
		return;
	}
	[_delegate loginFail];
	
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self isLoadingView:YES];
    
    NSString *urlString = request.URL.absoluteString;
	NSLog(@"shouldStartLoadWithRequest: %@", urlString);
    [self checkForAccessToken:urlString];    
    [self checkLoginRequired:urlString];
	
    if (((NSString *)[[request.URL.absoluteString componentsSeparatedByString:STRING_FB_REDIRECT_URL] objectAtIndex:0]).length == 0) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	isFinishLoading = YES;
    [_delegate loginFail];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self isLoadingView:NO];
}


#pragma mark - Helper functions

-(void)checkForAccessToken:(NSString *)urlString {
    NSError *error;
    //NSLog(@"urlString checkToken=%@",urlString);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
			isFinishLoading = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_delegate accessTokenFound:accessToken];
        }
    }
}

-(void)checkLoginRequired:(NSString *)urlString {
    //NSLog(@"urlString checkLoginRequired=%@",urlString);
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound) {
        isFinishLoading = YES;
        [_delegate displayRequired];
    } else {
		if ([urlString rangeOfString:@"about:blank"].location != NSNotFound) {
			return;
		}		
		
		if ([urlString rangeOfString:@"facebook.com"].location == NSNotFound) {
			isFinishLoading = YES;
			[_delegate loginFail];
		}		
	}
    if ([urlString rangeOfString:@"login.php?m=m"].location!=NSNotFound) {
		isFinishLoading = NO;

		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(logintimeout:) object:nil];
		[self performSelector:@selector(logintimeout:) withObject:nil afterDelay:20.0];

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)clickBack:(id)sender
{
    [_webView stopLoading];
    [_delegate clickBack];
}
@end
