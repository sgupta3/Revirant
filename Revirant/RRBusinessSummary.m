//
//  RRBusinessSummary.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "RRBusinessSummary.h"

@implementation RRBusinessSummary

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self){
        #warning Type safe all of these
        self.imageUrl = [NSURL URLWithString:dictionary[@"image_url"]];
        self.name = dictionary[@"name"];
        self.address = dictionary[@"location"][@"address"][0];
    }
    return self;
}

@end
