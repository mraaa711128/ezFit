//
//  BodyIndicatorCellCtrl.m
//  ezFit
//
//  Created by Stanley on 12/29/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import "BodyIndicatorCellCtrl.h"

@implementation BodyIndicatorCellCtrl

- (void)awakeFromNib {
    [self.lblIndicatorName setText:@""];
    [self.lblIndicatorUnit setText:@""];
    [self.lblIndicatorValue setText:@""];
}

- (void)setIndicatorName:(NSString *)indName Value:(NSNumber *)indValue Unit:(NSString *)indUnit {
    [self.lblIndicatorName setText:indName];
    [self.lblIndicatorUnit setText:indUnit];
    [self.lblIndicatorValue setText:[NSString stringWithFormat:@"%.2f",indValue.floatValue]];
}
@end
