//
//  RRBusinessSummaryCollectionViewCell.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "RRBusinessSummaryCollectionViewCell.h"
#import "UIImage+StackBlur.h"

@implementation RRBusinessSummaryCollectionViewCell

- (void) businessImageFromUrl:(NSURL *)imageUrl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:imageUrl];
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *originalImage = [UIImage imageWithData:data];
            self.businessImage.image = [originalImage stackBlur:5];
        });
    });
}

@end
