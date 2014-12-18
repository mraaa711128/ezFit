//
//  LoginTabViewCtrl.h
//  ezFit
//
//  Created by Stanley on 12/17/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTabViewCtrl : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *viewUserInput;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cstInputViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterCancel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actLoginConfirm;

@end
