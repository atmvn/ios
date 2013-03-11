//
//  BankItem.h
//  iATM
//
//  Created by Tai Truong on 3/11/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef enum
{
    enumBankType_ATM = 0,
    enumBankType_Num
}enumBankType;

@interface BankItem : NSObject <MKAnnotation>

@property (assign, nonatomic) NSInteger         itemID;
@property (retain, nonatomic) NSString          *address;
@property (retain, nonatomic) NSString          *bankName;
@property (assign, nonatomic) enumBankType      type;
@property (retain, nonatomic) NSString          *city;
@property (retain, nonatomic) NSString          *locationName;
@property (assign, nonatomic) CLLocationCoordinate2D          location;
@property (retain, nonatomic) NSString          *phoneNumber;
@property (retain, nonatomic) NSString          *workingTime;
@property (assign, nonatomic) CGFloat           distance;

-(id)initWithData:(NSDictionary*)dataDic;
@end
