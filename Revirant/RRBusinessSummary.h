//
//  RRBusinessSummary.h
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRBusinessSummary : NSObject

@property(nonatomic, strong) NSURL *imageUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *address;

-(id) initWithDictionary:(NSDictionary *)dictionary;
@end
