//
//  FBFunLoginDialog.h
//  FBFun
//
//  Created by chinhlt on 7/13/10.
//  Copyright 2010 Vitalify Asia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STRING_FB_REDIRECT_URL                                      @"https://www.facebook.com/connect/login_success.html"

@protocol FBFunLoginDialogDelegate
@optional
- (void)accessTokenFound:(NSString *)apiKey;
- (void)displayRequired;
- (void)loginFail;
- (void)clickBack;
@end

@interface FBFunLoginDialog : UIViewController <UIWebViewDelegate> {
    UIWebView *_webView;
    NSString *_apiKey;
    NSString *_requestedPermissions;
    id <FBFunLoginDialogDelegate> _delegate;
	
	BOOL isFinishLoading;
    
    UIView *m_LoadingView;
}

@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *apiKey;
@property (copy) NSString *requestedPermissions;
@property (assign) id <FBFunLoginDialogDelegate> delegate;

- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<FBFunLoginDialogDelegate>)delegate;

- (void)login;
- (void)logout;

- (void)checkForAccessToken:(NSString *)urlString;
- (void)checkLoginRequired:(NSString *)urlString;

- (IBAction)clickBack:(id)sender;
- (void)isLoadingView:(BOOL)isLoading;
@end
