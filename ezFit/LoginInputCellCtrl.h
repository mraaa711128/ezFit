//
//  LoginInputCellCtrl.h
//  ezFit
//
//  Created by Stanley on 12/17/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginInputCellCtrl : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswd;
@property (weak, nonatomic) IBOutlet UITextField *txtRePasswd;
@end
