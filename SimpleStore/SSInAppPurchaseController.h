//
//  SSInAppPurchaseController.h
//  SimpleStore
//
//  Created by Joshua Howland on 7/2/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kInAppPurchaseFetchedNotification;
static NSString * const kInAppPurchaseCompletedNotification; // UserInfo @"productId"
static NSString * const kInAppPurchaseRestoredNotification; // UserInfo @"productId"

@interface SSInAppPurchaseController : NSObject

@property (nonatomic, strong) NSArray *products;

+ (SSInAppPurchaseController *)sharedInstance;

- (void)requestProducts;
- (void)restorePurchases;
- (void)purchaseOptionSelectedObjectIndex:(NSUInteger)index;

@end
