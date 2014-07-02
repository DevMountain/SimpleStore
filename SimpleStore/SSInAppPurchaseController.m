//
//  SSInAppPurchaseController.m
//  SimpleStore
//
//  Created by Joshua Howland on 7/2/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "SSInAppPurchaseController.h"
#import <StoreKit/StoreKit.h>

static NSString * const kInAppPurchaseFetchedNotification = @"kInAppPurchaseFetchedNotification";
static NSString * const kInAppPurchaseCompletedNotification = @"kInAppPurchaseCompletedNotification";
static NSString * const kInAppPurchaseRestoredNotification = @"kInAppPurchaseCompletedNotification";

@interface SSInAppPurchaseController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, assign) BOOL productsRequested;

@end

@implementation SSInAppPurchaseController

+ (SSInAppPurchaseController *)sharedInstance {
    static SSInAppPurchaseController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SSInAppPurchaseController alloc] init];
        [sharedInstance loadStore];
    });
    return sharedInstance;
}


- (void)requestProducts {
    if (!self.productsRequest) {
        self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[self bundledProducts]];
        self.productsRequest.delegate = self;
    }

    if (!self.productsRequested) {
        [self.productsRequest start];
        self.productsRequested = YES;
    }
}

- (void) restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (NSSet *)bundledProducts {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *bundleProducts = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[bundle URLForResource:@"Products" withExtension:@"json"]] options:0 error:nil];
    if (bundleProducts) {
        NSSet *products = [NSSet setWithArray:bundleProducts];
        return products;
    }
    return nil;
}

#pragma mark - Actions

- (void)purchaseOptionSelectedObjectIndex:(NSUInteger)index {

    if ([SKPaymentQueue canMakePayments]) {
        if ([self.products count] > 0) {
            SKPayment *payment = [SKPayment paymentWithProduct:self.products[index]];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Unable to Purchase"
                                      message:@"This purchase is currently unavailable. Please try again later."
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Unable to Purchase"
                                  message:@"In-app purchases are disabled. You'll have to enable them to enjoy the full app."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
	}

}


#pragma mark - SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    self.productsRequested = NO;
    
    NSArray *products = response.products;
    self.products = products;
    for (SKProduct *validProduct in response.products) {
        NSLog(@"Found product: %@", validProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseFetchedNotification object:self userInfo:nil];
}


#pragma mark - Store Methods

- (void)loadStore {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self requestProducts];
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseCompletedNotification object:self userInfo:@{@"productId":transaction.originalTransaction.payment.productIdentifier}];
    [self finishTransaction:transaction wasSuccessful:YES];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Restore Upgrade"
                              message:@"Finished restoring. Enjoy!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseRestoredNotification object:self userInfo:@{@"productId":transaction.originalTransaction.payment.productIdentifier}];
    [self finishTransaction:transaction wasSuccessful:YES];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
		NSLog(@"Error: %@", [transaction error]);
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    } else {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	NSLog(@"Payment Queue method called");
	
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing:
				NSLog(@"payment purchasing");
				break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
				NSLog(@"payment purchased");
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
				NSLog(@"payment failed");
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
				NSLog(@"payment restored");
                break;
        }
    }
}


@end
