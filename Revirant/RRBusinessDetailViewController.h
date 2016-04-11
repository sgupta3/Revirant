//
//  RRBusinessDetailViewController.h
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-11.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRBusinessSummary.h"

@interface RRBusinessDetailViewController : UIViewController
@property(nonatomic, strong) RRBusinessSummary *businessSummary;
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessAddressLabel;
@property (weak, nonatomic) IBOutlet UITextView *businessReviewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *businessImageView;
@end
