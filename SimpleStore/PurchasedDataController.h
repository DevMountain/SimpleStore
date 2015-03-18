//
//  PurchasedDataController.h
//  SimpleStore
//
//  Created by Caleb Hicks on 3/17/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchasedDataController : NSObject

@property (assign, nonatomic, readonly) NSInteger gold;
@property (assign, nonatomic, readonly) BOOL goldStar;
@property (assign, nonatomic, readonly) BOOL adsRemoved;

+ (PurchasedDataController *)sharedInstance;

@end
