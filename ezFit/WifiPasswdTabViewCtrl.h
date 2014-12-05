//
//  WifiPasswdTabViewCtrl.h
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiPasswdTabViewCtrl : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtSSID;
@property (weak, nonatomic) IBOutlet UITextField *txtSecurityType;
//@property (weak, nonatomic) IBOutlet UITextField *txtSignalStrength;
@property (weak, nonatomic) IBOutlet UITextField *txtOtherInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEncrypt;
@property (weak, nonatomic) IBOutlet UIImageView *imgWifiSignal;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

- (IBAction)txtPasswdEditingChange:(id)sender;
- (IBAction)btnConfirmClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;

- (void)setWifiInfo:(NSDictionary*)wifiInfo;

@end