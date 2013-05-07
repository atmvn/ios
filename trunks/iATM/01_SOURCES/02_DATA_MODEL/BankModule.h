//
//  BankModule.h
//  iATM
//
//  Created by Tai Truong on 5/7/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BankModule : NSManagedObject

@property (nonatomic, retain) NSString * bankID;
@property (nonatomic, retain) NSString * bankNameEN;
@property (nonatomic, retain) NSString * bankNameVN;
@property (nonatomic, retain) NSString * icon;

@end
