//
//  YelpAPINetworkClient.h
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YelpAPINetworkClient : NSObject


- (NSURLSessionTask *) queryBusinessesWithTerm:(NSString *)term
                                    location:(CLLocation *)location
                                     withSuccess:(void (^)(NSArray *businesses))successHandler
                                    error:(void (^)(NSError *error))errorHandler
                                    always:(void (^)())alwaysHandler
                                    session:(NSURLSession *)session;


@end
