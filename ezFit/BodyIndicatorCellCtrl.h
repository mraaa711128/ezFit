//
//  BodyIndicatorCellCtrl.h
//  ezFit
//
//  Created by Stanley on 12/29/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyIndicatorCellCtrl : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblIndicatorName;
@property (weak, nonatomic) IBOutlet UILabel *lblIndicatorValue;
@property (weak, nonatomic) IBOutlet UILabel *lblIndicatorUnit;

- (void)setIndicatorName:(NSString*)indName Value:(NSNumber*)indValue Unit:(NSString*)indUnit;

@end
