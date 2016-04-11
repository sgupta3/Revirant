//
//  RRBusinessDetailViewController.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-11.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "RRBusinessDetailViewController.h"
#import "UIImage+StackBlur.h"
#import "YelpAPINetworkClient.h"

@implementation RRBusinessDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self fetchBusinessInfoWithBusinessID:self.businessSummary.businessID];
}

-(void) setupView {
    self.businessNameLabel.text = self.businessSummary.name;
    self.businessAddressLabel.text = self.businessSummary.address;
    [self.businessSummary businessPhotoWithCompletion:^(UIImage *image) {
        self.businessImageView.image = image;
    }];
}

-(void) fetchBusinessInfoWithBusinessID:(NSString *)businessID {
    YelpAPINetworkClient *client = [[YelpAPINetworkClient alloc] init];
    [client queryBusinessesWithbusinessID:businessID withSuccess:^(NSDictionary *businessesInfo) {
        self.businessReviewTextView.text = businessesInfo[@"reviews"][0][@"excerpt"] ? businessesInfo[@"reviews"][0][@"excerpt"] : @"Not available";
    } error:^(NSError *error) {
        
    } always:^{
        
    } session:[NSURLSession sharedSession]];
}

@end
