//
//  RRUtilities.h
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RRUtilities : NSObject

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message okayHandler:(void(^)(void))okay;

@end
