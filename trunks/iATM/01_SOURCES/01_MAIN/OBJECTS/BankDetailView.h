//
//  BankDetailView.h
//  iATM
//
//  Created by Tai Truong on 4/14/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BankDetailView;

@protocol BankDetailViewDelegate <NSObject>

@optional
-(void)bankDetailViewRouteTouchUpInside:(BankDetailView*)view;

@end
@interface BankDetailView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<BankDetailViewDelegate> delegate;
@property (weak, nonatomic) UIView *movingView;

@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *routeBtn;

- (IBAction)routeTouchUpInside:(id)sender;
-(void)show;
-(void)hide;
@end
