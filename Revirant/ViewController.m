//
//  ViewController.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "ViewController.h"
#import "RRUtilities.h"
#import "YelpAPINetworkClient.h"

@interface ViewController () <CLLocationManagerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSString *queryString;
@property (strong, nonatomic) CLLocation *currentLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

#pragma mark - Search Bar
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.queryString = self.searchBar.text;
    [self determineUserLocationAndFindBusinesses];
}

#pragma mark - Location Manager

-(void) determineUserLocationAndFindBusinesses {
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *errorController = [RRUtilities alertWithTitle:@"Couldn't access location" message:@"Revirant doesn't have access to your location. Your location will be automatically set to Toronto, CA. Please enable access to your location in Settings." okayHandler:^{
        [self fetchRestaurantsWithTerm:self.queryString location:nil];
    }];
    [self presentViewController:errorController animated:YES completion:nil];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    
    if ([locations lastObject] != nil && self.currentLocation == nil) {
        self.currentLocation = [locations lastObject];
        NSLog(@"%@",self.currentLocation);
        [self fetchRestaurantsWithTerm:self.queryString location:self.currentLocation];
    }
}

#pragma mark - Fetch Restaurants

-(void) fetchRestaurantsWithTerm:(NSString *)term location:(CLLocation *)location {
    YelpAPINetworkClient *client = [[YelpAPINetworkClient alloc] init];
    [client queryBusinessesWithTerm:term location:location
                        withSuccess:^(NSArray *businesses) {
                            NSLog(@"%@", businesses);
                        } error:^(NSError *error) {
                            NSLog(@"%@",error);
                        } always:^{
                            self.currentLocation = nil;
                        } session:[NSURLSession sharedSession]];
}

@end
