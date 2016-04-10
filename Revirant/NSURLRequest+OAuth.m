//
//  NSURLRequest+OAuth.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "NSURLRequest+OAuth.h"
#import <TDOAuth/TDOAuth.h>

//Keys and Tokens to access YELP API
static NSString * const kConsumerKey       = @"4mb1hZGdPGuiwQMb2hsTQA";
static NSString * const kConsumerSecret    = @"_PtTeBYvuVOIkg09X0NMuypT3Tw";
static NSString * const kToken             = @"eiUamZBMDXg1cMToXNb_7KixIj9Co7bm";
static NSString * const kTokenSecret       = @"FJUsbp7SRbbZoGNAXMWTfjh5r_M";

@implementation NSURLRequest (OAuth)

+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path {
    return [self requestWithHost:host path:path params:nil];
}

+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params {
    
    return [TDOAuth URLRequestForPath:path
                        GETParameters:params
                               scheme:@"https"
                                 host:host
                          consumerKey:kConsumerKey
                       consumerSecret:kConsumerSecret
                          accessToken:kToken
                          tokenSecret:kTokenSecret];
}

@end
