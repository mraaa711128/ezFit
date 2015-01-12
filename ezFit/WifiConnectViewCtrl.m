//
//  WifiConnectViewCtrl.m
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import <SystemConfiguration/CaptiveNetwork.h>

#import "WifiConnectViewCtrl.h"
#import "WifiSelectTabViewCtrl.h"

#if DEBUG
    static NSString* const scaleWifiSSID = @"Test";
#else
    static NSString* const scaleWifiSSID = @"WICED Config";
#endif

static BOOL isJumpToSettings;

@interface WifiConnectViewCtrl ()

@end

@implementation WifiConnectViewCtrl {
    NSString* TestConnect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:YES];
    
    isJumpToSettings = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ScaleConnectRunning"] != nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ScaleConnectRunning"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: //Cancel ('OK') Button
            
            break;
        case 1: //Go Settings Button
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"ScaleConnectRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
#if DEBUG
            TestConnect = @"Test";
#endif
            break;
        default:
            break;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"segueWifiScan"]) {
        NSString* currentSSID = [self getCurrentSSID];
        if ([currentSSID isEqualToString:scaleWifiSSID] == NO) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
    return NO;
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)btnScanClick:(id)sender {
    NSString* currentSSID = [self getCurrentSSID];
    if ([currentSSID isEqualToString:scaleWifiSSID] == NO) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Switch Wifi" message:[NSString stringWithFormat:@"Switch wifi to '%@' ?",scaleWifiSSID] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Go Settings", nil];
        [alertView show];
    }
}


- (IBAction)btnDoneClick:(id)sender {
}

- (NSString*)getCurrentSSID {
    if ([TestConnect isEqualToString:@"Test"] == YES) {
        return @"Test";
    }
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    return [info objectForKey:@"SSID"];
}

@end
