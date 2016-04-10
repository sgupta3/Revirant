//
//  RRUtilities.m
//  Revirant
//
//  Created by Sahil Gupta on 2016-04-10.
//  Copyright © 2016 Sahil Gupta. All rights reserved.
//

#import "RRUtilities.h"

@implementation RRUtilities

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message okayHandler:(void(^)(void))okay
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                             if(okay) { okay(); }
                                                         }];
    
    [alertController addAction:okayAction];
    
    return alertController;
}

@end
