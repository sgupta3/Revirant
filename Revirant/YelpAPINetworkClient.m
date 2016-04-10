//
//  YelpAPINetworkClient.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "YelpAPINetworkClient.h"
#import "NSURLRequest+OAuth.h"

/**
 Default paths and search terms used in this example
 */
static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"10";
static NSString * const kMockCoordinates   = @"43.653226,-79.383184";

@implementation YelpAPINetworkClient

- (NSURLSessionTask *) queryBusinessesWithTerm:(NSString *)term
                                      location:(CLLocation *)location
                                   withSuccess:(void (^)(NSArray *businesses))successHandler
                                         error:(void (^)(NSError *error))errorHandler
                                        always:(void (^)())alwaysHandler
                                       session:(NSURLSession *)session {
  
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term location:location];
    NSURLSessionTask *task = [session dataTaskWithRequest:searchRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            [self callHandlerIfNotNil:successHandler withArgument:businessArray];
        } else {
            [self callHandlerIfNotNil:errorHandler withArgument:error];
        }
        
        [self callHandlerIfNotNil:alwaysHandler];
    }];
    
    [task resume];
    return task;
}

- (NSURLSessionTask *) queryBusinessesWithbusinessID:(NSString *)businessID
                                         withSuccess:(void (^)(NSDictionary *businessInfo))successHandler
                                               error:(void (^)(NSError *error))errorHandler
                                              always:(void (^)())alwaysHandler
                                             session:(NSURLSession *)session {
    
    NSURLRequest *businessInfoRequest = [self _businessInfoRequestForID:businessID];
    NSURLSessionTask *task = [session dataTaskWithRequest:businessInfoRequest
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                            
                                            if(!error && httpResponse.statusCode == 200) {
                                                NSDictionary *businessInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                [self callHandlerIfNotNil:successHandler withArgument:businessInfo];
                                            } else {
                                                [self callHandlerIfNotNil:errorHandler withArgument:error];
                                            }
                                        }];
    [self callHandlerIfNotNil:alwaysHandler];
    [task resume];
    return task;
}

#pragma mark - API Request Builders

/**
 Builds a request to hit the search endpoint with the given parameters.
 
 @param term The term of the search, e.g: dinner
 @param location The CLLocationObject
 
 @return The NSURLRequest needed to perform the search
 */
- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term location:(CLLocation *)location {
    
    NSString *coordinates = location == nil ? kMockCoordinates : [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    
    NSDictionary *params = @{
                             @"term": term,
                             @"ll": coordinates,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

/**
 Builds a request to hit the business endpoint with the given business ID.
 
 @param businessID The id of the business for which we request informations
 
 @return The NSURLRequest needed to query the business info
 */
- (NSURLRequest *)_businessInfoRequestForID:(NSString *)businessID {
    
    NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
    return [NSURLRequest requestWithHost:kAPIHost path:businessPath];
}

#pragma mark - Hepler Methods

- (void)callHandlerIfNotNil:(void(^)())handler
{
    if(handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler();
        });
    }
}

- (void)callHandlerIfNotNil:(void(^)(id arg))handler withArgument:(id)argument
{
    if(handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(argument);
        });
    }
}


@end
