//
//  UIView+CustomVisualization.m
//  ezFit
//
//  Created by Stanley on 12/17/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import "UIView+CustomVisualization.h"

@implementation UIView (CustomVisualization)

- (void)setBorderWidth:(CGFloat)width {
    [self.layer setBorderWidth:width];
}

- (void)setBorderColor:(UIColor *)color {
    [self.layer setBorderColor:color.CGColor];
}

- (void)setCornerRadius:(CGFloat)radius {
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

@end
