//
//  WifiSelectTabCellCtrl.h
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiSelectTabCellCtrl : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtSSID;
@property (weak, nonatomic) IBOutlet UILabel *txtOtherInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignalStrength;
@end
