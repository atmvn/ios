//
//  BankDetailView.m
//  iATM
//
//  Created by Tai Truong on 4/14/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "BankDetailView.h"
#import "Define.h"

typedef enum
{
    enumBankDetailViewSize_Small = 0,
    enumBankDetailViewSize_Medium,
    enumBankDetailViewSize_Full,
    enumBankDetailViewSize_Num
}enumBankDetailViewSize;

#define HEIGHT_OF_VIEW_SMALL 85
#define BANKDETAILVIEW_SUBTITLE_HEIGHT 27

@implementation BankDetailView
{
    enumBankDetailViewSize _viewSize;
    CGRect _movingViewOrigialRect;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:[self.class description] owner:self options:nil] objectAtIndex:0];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, HEIGHT_IPHONE, WIDTH_IPHONE, HEIGHT_IPHONE);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tapGesture];
        
        UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpHandle:)];
        swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeUpGesture];
        
        UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownHandle:)];
        swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeDownGesture];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setWorkingTime:(NSString *)workingTime
{
    self.workingTimeLbl.text = workingTime;
}

-(void)setPhoneNumber:(NSString *)phoneNumber
{
    NSArray* words = [phoneNumber componentsSeparatedByCharactersInSet :[NSCharacterSet characterSetWithCharactersInString:@"/-"]];
    phoneNumber = [words componentsJoinedByString:@"\n"];
    
    self.phoneTxtView.text = phoneNumber;
}

-(void)setMovingView:(UIView *)movingView
{
    _movingView = movingView;
    _movingViewOrigialRect = movingView.frame;
}

- (IBAction)routeTouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bankDetailViewRouteTouchUpInside:)]) {
        [self.delegate bankDetailViewRouteTouchUpInside:self];
    }
}

- (IBAction)callTouchUpInside:(UIButton *)sender {
    NSString *phoneNumber = self.phoneTxtView.text;
    NSArray* words = [phoneNumber componentsSeparatedByCharactersInSet :[NSCharacterSet characterSetWithCharactersInString:@". "]];
    phoneNumber = [words componentsJoinedByString:@""];
    NSLog(@"Phone = {%@}", phoneNumber);
    
    if (![phoneNumber isEqualToString:@""]) {
        NSString *phoneNumberStr = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberStr]];
    }
}

-(void)show
{
    // set view size
    _viewSize = enumBankDetailViewSize_Small;
    
    // set subtitle rect
    CGRect lbRect = self.subTitleLbl.frame;
    lbRect.size.height = BANKDETAILVIEW_SUBTITLE_HEIGHT;
    
    // show view
    CGRect r = self.frame;
    r.origin.y = HEIGHT_IPHONE - HEIGHT_STATUS_BAR - HEIGHT_OF_VIEW_SMALL;

    CGRect movingViewRect = self.movingView.frame;
    movingViewRect.origin.y = r.origin.y - movingViewRect.size.height + 10;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = r;
        self.subTitleLbl.frame = lbRect;
        self.movingView.frame = movingViewRect;
    } completion:nil];
}

-(void)hide
{
    CGRect r = self.frame;
    r.origin.y = HEIGHT_IPHONE;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = r;
        self.movingView.frame = _movingViewOrigialRect;
    } completion:nil];
}


-(void)showMediumView
{
    // set view size type
    _viewSize = enumBankDetailViewSize_Medium;
    
    // calculate subtitle rect for full text
    CGRect lbRect = self.subTitleLbl.frame;
    CGSize textSize = [self.subTitleLbl.text sizeWithFont:self.subTitleLbl.font constrainedToSize:CGSizeMake(lbRect.size.width, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    lbRect.size.height = textSize.height;
    
    // show view
    CGRect r = self.frame;
    r.origin.y = (HEIGHT_IPHONE - HEIGHT_STATUS_BAR) / 2;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = r;
        self.subTitleLbl.frame = lbRect;
    } completion:nil];
}


#pragma mark - UIGestureRecognizerDelegate
-(void)tapHandle:(UIGestureRecognizer*)recognizer
{
    if (_viewSize == enumBankDetailViewSize_Small) {
        [self showMediumView];
    }
}

-(void)swipeUpHandle:(UIGestureRecognizer*)recognizer
{
    if (_viewSize == enumBankDetailViewSize_Small) {
        [self showMediumView];
    }
}
-(void)swipeDownHandle:(UIGestureRecognizer*)recognizer
{
    if (_viewSize == enumBankDetailViewSize_Medium) {
        [self show];
    }
}

@end
