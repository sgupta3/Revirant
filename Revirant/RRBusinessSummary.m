//
//  RRBusinessSummary.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "RRBusinessSummary.h"
#import "UIImage+StackBlur.h"

@implementation RRBusinessSummary

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self){
        self.businessID = [self sanitizeString:dictionary[@"id"]];
        self.imageUrl = [NSURL URLWithString:[self sanitizeString:dictionary[@"image_url"]]];
        self.name = [self sanitizeString:dictionary[@"name"]];
        self.address = [self santizeAddress:dictionary];
    }
    return self;
}

-(void) businessPhotoWithCompletion:(void (^)(UIImage *image))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageNamed:@"raining_tomatoes"];
        
        if(self.imageUrl){
            NSData *data = [NSData dataWithContentsOfURL:self.imageUrl];
            image = [UIImage imageWithData:data];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion([image stackBlur:5]);
        });
    });
}

#pragma mark - Sanitizers

- (NSString *) santizeAddress:(NSDictionary *)businessInfo {
    NSString *address = @"Not available";
    if ([businessInfo[@"location"][@"address"] count] > 0) {
        NSString *city = businessInfo[@"location"][@"city"] == nil ? @"" : businessInfo[@"location"][@"city"];
        address = [NSString stringWithFormat:@"%@, %@", businessInfo [@"location"][@"address"][0], city];
    }
    return address;
}

#pragma mark - Helpers

- (NSString *) sanitizeString:(NSString *)string {
    if ( string == (id)[NSNull null] || string.length == 0){
        return @"";
    }
    return string;
}

@end
