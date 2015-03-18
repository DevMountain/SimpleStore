//
//  SSStoreDatasource.m
//  SimpleStore
//
//  Created by Joshua Howland on 7/2/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "StoreViewDatasource.h"
#import "StorePurchaseController.h"

#import <StoreKit/StoreKit.h>

@implementation StoreViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[StorePurchaseController sharedInstance].products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"product"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"product"];;
    }
    
    SKProduct *product = [StorePurchaseController sharedInstance].products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", product.price, product.localizedDescription];
    
    return cell;
}

@end
