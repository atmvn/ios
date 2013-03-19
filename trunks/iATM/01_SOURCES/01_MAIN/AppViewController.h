//
//  ViewController.h
//  aigo
//
//  Created by Tai Truong on 11/20/12.
//  Copyright (c) 2012 AIGO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreData/CoreData.h"
#import "Define.h"
#import "APIRequester.h"
#import "SBJSON.h"

@interface AppViewController : UIViewController {
    NSMutableArray                                  *_listOfViewController;
    UIView                                          *_requestingView;
    UIActivityIndicatorView                         *_requestingIndicator;
    
    NSTimer                                         *_timerCountDown;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) NSTimeInterval                backgroundTimeInterval;
@property (nonatomic) int                           remainingTime;

+ (AppViewController *)Shared;

#pragma mark - Indicator view animation
- (void)isRequesting:(BOOL)isRe andRequestType:(ENUM_API_REQUEST_TYPE)type andFrame:(CGRect)frame;

#pragma mark - App Protocol
- (void)update;

#pragma mark - Model
- (void)saveContext;
- (BOOL)validateLocalDatabase;
-(void)requestUpdateDeviceToken:(NSString*)oldToken;
#pragma mark - UIImage Picker View Controller
- (void)changeToPickerControllerWithSourceType:(UIImagePickerControllerSourceType)type andDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;
- (void)changeBackFromPickerController;

#pragma mark - Remote Notification
- (void)didReceiveRemoteNotification:(NSDictionary*)userInfo andNotificationType:(enumRemoveNotificationType)type;

#pragma mark - Popup Animation

@end
