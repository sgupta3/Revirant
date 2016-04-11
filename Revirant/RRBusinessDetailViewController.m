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
#import "RRUtilities.h"

@implementation RRBusinessDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void) setupView {
    self.businessNameLabel.text = self.businessSummary.name;
    self.businessAddressLabel.text = self.businessSummary.address;
    [self.businessSummary businessPhotoWithCompletion:^(UIImage *image) {
        self.businessImageView.image = image;
    }];
    
    [self fetchBusinessInfoWithBusinessID:self.businessSummary.businessID
                               completion:^(NSDictionary *businessDetails) {
                                   self.businessReviewTextView.text = businessDetails[@"reviews"][0][@"excerpt"] ? businessDetails[@"reviews"][0][@"excerpt"] : @"Not available";
                               }];
}

#pragma mark - Data Fethcher

-(void) fetchBusinessInfoWithBusinessID:(NSString *)businessID completion:(void (^)(NSDictionary *businessDetails))completion {
    YelpAPINetworkClient *client = [[YelpAPINetworkClient alloc] init];
    [client queryBusinessesWithbusinessID:businessID withSuccess:^(NSDictionary *businessesInfo) {
        completion(businessesInfo);
    } error:^(NSError *error) {
        NSLog(@"Error caused while fetching business details. Error: %@, %@",error.userInfo, error.description);
        [self showErrorAlert];
    } always:nil
    session:[NSURLSession sharedSession]];
}

#pragma mark - Helpers

-(void)showErrorAlert {
    UIAlertController *alert= [RRUtilities alertWithTitle:@"Unable to fetch the details" message:@"Reverant is unable to fetch details for this business. Please try again." okayHandler:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
