//
//  RRBusinessSummaryCollectionViewCell.h
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRBusinessSummaryCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *businessImage;
@property (nonatomic, weak) IBOutlet UILabel *businessName;
@property (nonatomic, weak) IBOutlet UILabel *businessAddress;
@property (nonatomic, weak) IBOutlet UIView *overlayView;
@end
