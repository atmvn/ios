//
//  BankItem.m
//  iATM
//
//  Created by Tai Truong on 3/11/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "BankItem.h"

@implementation BankItem

-(id)initWithData:(NSDictionary *)dataDic
{
    self = [super init];
    if (self) {
        self.distance = [[dataDic objectForKey:@"dis"] floatValue];
        NSDictionary *obj = [dataDic objectForKey:@"obj"];
        self.itemID = [obj objectForKey:@"_id"];
        self.address = [obj objectForKey:@"address"];
        self.bankName = [obj objectForKey:@"bankname"];
        if([[obj objectForKey:@"banktype"] isEqualToString:@"ATM"])
        {
            self.type = enumBankType_ATM;
        }
        self.city = [obj objectForKey:@"city"];
        self.locationName = [obj objectForKey:@"locationname"];
        self.phoneNumber = [obj objectForKey:@"phones"];
        self.workingTime = [obj objectForKey:@"workingtime"];
        CGFloat latitude = [[[obj objectForKey:@"loc"] objectAtIndex:0] floatValue];
        CGFloat longtitude = [[[obj objectForKey:@"loc"] objectAtIndex:1] floatValue];
        self.location = CLLocationCoordinate2DMake(latitude, longtitude);
    }
    
    return self;
}

-(NSString *)title
{
    return self.bankName;
}

-(NSString *)subtitle
{
    return self.address;
}

-(CLLocationCoordinate2D)coordinate
{
    return self.location;
}

//- (MKMapItem*)mapItem {
//    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
//    
//    MKPlacemark *placemark = [[MKPlacemark alloc]
//                              initWithCoordinate:self.coordinate
//                              addressDictionary:addressDict];
//    
//    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//    mapItem.name = self.title;
//    
//    return mapItem;
//}
@end
