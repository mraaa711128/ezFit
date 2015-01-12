//
//  UIAlertController+CustomAlertController.m
//  ezFit
//
//  Created by Stanley on 12/18/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import "AppDelegate.h"

#import "UIAlertController+CustomAlertController.h"

@implementation UIAlertController (CustomAlertController)

+ (UIAlertController*)getScaleConnectAlertController {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Scale Connection" message:@"There is no scales connection with this account ! Do you want connect your scale ?" preferredStyle:UIAlertControllerStyleAlert];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIAlertAction* skipAction = [UIAlertAction actionWithTitle:@"Skip" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ScaleConnectRunning"] != nil) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ScaleConnectRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [app switchRootViewToStoryboard:@"Main" WithIdentifier:@"MainView"];
    }];
    UIAlertAction* connectAction = [UIAlertAction actionWithTitle:@"Start Connect" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [app switchRootViewToStoryboard:@"Connect" WithIdentifier:@"ScaleConnectView"];
    }];
    [alert addAction:skipAction];
    [alert addAction:connectAction];
    return alert;
}

+ (UIAlertController *)getOnlyAlertControllerWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

@end
