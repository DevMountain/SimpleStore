//
//  ViewController.m
//  SimpleStore
//
//  Created by Caleb Hicks on 3/17/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "ViewController.h"
#import "PurchasedDataController.h"
@import iAd;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goldStarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureWithPurchases];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWithPurchases {
    
    self.goldLabel.text = [NSString stringWithFormat:@"%ld gold",(long)[PurchasedDataController sharedInstance].gold];

    if ([PurchasedDataController sharedInstance].adsRemoved) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    
    if ([PurchasedDataController sharedInstance].goldStar) {
        self.goldStarView.image = [UIImage imageNamed:@"GoldStar"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
