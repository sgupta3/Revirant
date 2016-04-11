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
        #warning Type safe all of these
        self.businessID = dictionary[@"id"];
        self.imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];
        self.name = dictionary[@"name"];
        self.address = dictionary[@"location"][@"address"][0];
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

@end
