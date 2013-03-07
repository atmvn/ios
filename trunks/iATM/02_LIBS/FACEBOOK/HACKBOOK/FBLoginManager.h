//
//  FBLoginManager.h
//  VFA_QUEUENCE
//
//  Created by Phan Ba Minh on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface FBLoginManager : UIViewController <FBRequestDelegate, FBSessionDelegate>
{
    NSArray                 *permissions;
    Facebook                *facebook;
    
    UILabel                 *nameLabel;
    UIImageView             *profilePhotoImageView;
    NSMutableDictionary     *userPermissions;
    
    int                     currentAPICall;
    UILabel                 *messageLabel;
    UIView                  *messageView;
}
@property (nonatomic, retain) Facebook *facebook;
- (void)showLoggedIn;
- (void)showLoggedOut;
- (void)login;
- (void)logout;
+ (FBLoginManager *)Shared;
@end
