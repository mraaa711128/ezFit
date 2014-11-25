//
//  LoginViewCtrl.m
//  ezFit
//
//  Created by Stanley on 11/22/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import <SystemConfiguration/CaptiveNetwork.h>

#import "LoginViewCtrl.h"

@interface LoginViewCtrl ()

@end

@implementation LoginViewCtrl {
    BOOL registrationMode;
}

@synthesize txtEmail;
@synthesize txtPassword;
@synthesize txtRePassword;
@synthesize btnLogin;
@synthesize btnRegister;
@synthesize btnNextStep;
@synthesize btnCancel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    registrationMode = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
    [self.actLoading stopAnimating];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"segueProfileCreate"]) {
        if ([self.txtEmail.text containsString:@"@"]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)btnLoginClick:(id)sender {
    [self.actLoading startAnimating];
    [self.btnRegister setHidden:YES];
    [self.btnCancel setHidden:NO];
}

- (IBAction)btnRegisterClick:(id)sender {
    registrationMode = YES;
    [self prepareRegistration:registrationMode];
}

- (IBAction)btnNextStepClick:(id)sender {
    [self.actLoading startAnimating];
}

- (IBAction)btnCancelClick:(id)sender {
    [self.actLoading stopAnimating];
    registrationMode = NO;
    [self prepareRegistration:registrationMode];
}

- (IBAction)txtRePasswordEditingChanged:(id)sender {
    if ([self.txtPassword.text isEqualToString:self.txtRePassword.text]) {
        [self.btnNextStep setHidden:NO];
    } else {
        [self.btnNextStep setHidden:YES];
    }
}

- (void)prepareRegistration:(BOOL)isReg {
    [self.txtEmail setText:@""];
    [self.txtPassword setText:@""];
    [self.txtRePassword setText:@""];
    
    [self.txtRePassword setHidden:!isReg];
    //[self.btnNextStep setHidden:!isReg];
    [self.btnCancel setHidden:!isReg];
    [self.btnLogin setHidden:isReg];
    [self.btnRegister setHidden:isReg];
}


@end
