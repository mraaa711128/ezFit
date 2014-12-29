//
//  ProfileHeadCtrl.m
//  ezFit
//
//  Created by Stanley on 12/29/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import "ProfileHeadCtrl.h"

@implementation ProfileHeadCtrl

- (void)awakeFromNib {
    [self.imgProfile setImage:nil];
    [self.lblNickName setText:@""];
    [self.lblLastName setText:@""];
    [self.lblFirstName setText:@""];
    [self.lblHeight setText:@""];
    [self.lblWaist setText:@""];
}

- (void)setProfileInfo:(NSDictionary *)profileInfo {
    [self.lblNickName setText:[profileInfo objectForKey:@"nick_name"]];
    [self.lblLastName setText:[profileInfo objectForKey:@"last_name"]];
    [self.lblFirstName setText:[profileInfo objectForKey:@"first_name"]];
    [self.lblHeight setText:[NSString stringWithFormat:@"%@ (cm)",[profileInfo objectForKey:@"height"]]];
    [self.lblWaist setText:[NSString stringWithFormat:@"%@ (cm)",[profileInfo objectForKey:@"waist"]]];
}

@end
