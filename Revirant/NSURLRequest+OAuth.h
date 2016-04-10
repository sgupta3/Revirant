//
//  NSURLRequest+OAuth.h
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (OAuth)

/**
 @param host The domain host
 @param path The path on the domain host
 @return Builds a NSURLRequest with all the OAuth headers field set with the host and path given to it.
 */
+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path;

/**
 @param host The domain host
 @param path The path on the domain host
 @param params The query parameters
 @return Builds a NSURLRequest with all the OAuth headers field set with the host, path, and query parameters given to it.
 */
+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params;

@end
