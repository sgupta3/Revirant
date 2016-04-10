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
#import "RRBusinessSummaryCollectionViewCell.h"
#import "RRBusinessSummary.h"

static const CGFloat kRRBusinessSummaryCellSpacing = 4.0;

@interface ViewController () <CLLocationManagerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSString *queryString;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *businessSummaries;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.businessSummaries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RRBusinessSummaryCollectionViewCell *cell = (RRBusinessSummaryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    RRBusinessSummary *currentSummary = [self.businessSummaries objectAtIndex:indexPath.row];
    [cell businessImageFromUrl:[currentSummary imageUrl]];
    cell.businessName.text = [currentSummary name];
    cell.businessAddress.text = [currentSummary address];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    RRBusinessSummaryCollectionViewCell *cell = (RRBusinessSummaryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.overlayView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RRBusinessSummaryCollectionViewCell *cell = (RRBusinessSummaryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

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
                            [self sortAndProccessBusinessesArray:businesses];
                        } error:^(NSError *error) {
                            NSLog(@"%@",error);
                        } always:^{
                            self.currentLocation = nil;
                        } session:[NSURLSession sharedSession]];
}

#pragma mark - Helpers
-(void) sortAndProccessBusinessesArray:(NSArray *)data {
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    data = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:brandDescriptor]];
    
    self.businessSummaries = [[NSMutableArray alloc] init];

    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RRBusinessSummary *summary = [[RRBusinessSummary alloc] initWithDictionary:obj];
        [self.businessSummaries addObject:summary];
    }];
    [self.collectionView reloadData];
}

#pragma mark - Collection view flow layout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numColumns = 2;
    
    CGFloat interitemSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    CGFloat totalInteritemSpacing = (numColumns - 1) * interitemSpacing;
    
    UIEdgeInsets sectionInset = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
    CGFloat totalSectionInsetSpacing = sectionInset.left + sectionInset.right;
    
    CGFloat size = (self.collectionView.frame.size.width - totalInteritemSpacing - totalSectionInsetSpacing) / (CGFloat)numColumns;
    return CGSizeMake(size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kRRBusinessSummaryCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kRRBusinessSummaryCellSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //    return UIEdgeInsetsZero;
    return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
}



@end
