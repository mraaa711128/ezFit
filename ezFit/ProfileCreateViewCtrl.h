//
//  ProfileCreateViewCtrl.h
//  ezFit
//
//  Created by Stanley on 11/22/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCreateViewCtrl : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UITextField *txtNickname;
@property (weak, nonatomic) IBOutlet UITextField *txtSex;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthdate;
@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtWaist;
@property (weak, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actProfileUpdate;

- (IBAction)buttonRegisterClick:(id)sender;
- (IBAction)buttonCancelClick:(id)sender;
@end
