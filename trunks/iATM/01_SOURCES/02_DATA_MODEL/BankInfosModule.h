//
//  BankInfosModule.h
//  iATM
//
//  Created by Tai Truong on 3/19/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BankInfosModule : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * bankID;
@property (nonatomic, retain) NSString * bankNameEN;
@property (nonatomic, retain) NSString * bankNameVN;
@property (nonatomic, retain) NSString * banktype;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSString * locationname;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * workingtime;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * itemID;

@end
