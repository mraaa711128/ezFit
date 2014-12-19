//
//  UIAlertController+CustomAlertController.h
//  ezFit
//
//  Created by Stanley on 12/18/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (CustomAlertController)

+ (UIAlertController*)getScaleConnectAlertController;
+ (UIAlertController*)getOnlyAlertControllerWithTitle:(NSString*)title Message:(NSString*)message;

@end
