//
//  ViewController.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "ViewController.h"
#import "RRUtilities.h"

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *errorController = [RRUtilities alertWithTitle:@"Couldn't access location" message:@"Revirant doesn't have access to your location. Your location will be automatically set to our default location - Toronto, CA" okayHandler:nil];
    [self presentViewController:errorController animated:YES completion:nil];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    if ([locations lastObject] != nil) {
        CLLocation *location = [locations lastObject];
        NSLog(@"Latitude: %f, Logitude: %f", location.coordinate.latitude, location.coordinate.longitude);
        [self.locationManager stopUpdatingLocation];
    }
}

@end
