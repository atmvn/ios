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
    enumBankType_Branch,
    enumBankType_Num
}enumBankType;

@interface BankItem : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString          *itemID;
@property (copy, nonatomic) NSString          *address;
@property (copy, nonatomic) NSString          *bankName;
@property (assign, nonatomic) enumBankType      type;
@property (copy, nonatomic) NSString          *city;
@property (copy, nonatomic) NSString          *locationName;
@property (assign, nonatomic) CLLocationCoordinate2D          location;
@property (copy, nonatomic) NSString          *phoneNumber;
@property (copy, nonatomic) NSString          *workingTime;
@property (assign, nonatomic) CGFloat           distance;

-(id)initWithData:(NSDictionary*)dataDic;
@end
