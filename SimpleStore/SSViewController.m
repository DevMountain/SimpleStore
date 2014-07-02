//
//  SSViewController.m
//  SimpleStore
//
//  Created by Joshua Howland on 7/2/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "SSViewController.h"
#import "SSStoreDatasource.h"
#import "SSInAppPurchaseController.h"

@interface SSViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SSStoreDatasource *datasource;

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.datasource = [SSStoreDatasource new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self.datasource;
    
    [[SSInAppPurchaseController sharedInstance] requestProducts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsRequested:) name:kInAppPurchaseFetchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kInAppPurchaseCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productRestored:) name:kInAppPurchaseRestoredNotification object:nil];
}

- (void)productsRequested:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)productPurchased:(NSNotification *)notification {
    
}

- (void)productRestored:(NSNotification *)notification {

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[SSInAppPurchaseController sharedInstance] purchaseOptionSelectedObjectIndex:indexPath.row];
    
}

@end
