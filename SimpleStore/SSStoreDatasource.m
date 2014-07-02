//
//  SSStoreDatasource.m
//  SimpleStore
//
//  Created by Joshua Howland on 7/2/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "SSStoreDatasource.h"
#import "SSInAppPurchaseController.h"

#import <StoreKit/StoreKit.h>

@implementation SSStoreDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[SSInAppPurchaseController sharedInstance].products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"product"];
    if (!cell) {
        cell = [UITableViewCell new];
    }
    SKProduct *product = [SSInAppPurchaseController sharedInstance].products[indexPath.row];
    cell.textLabel.text = product.productIdentifier;
    
    return cell;
}

@end
