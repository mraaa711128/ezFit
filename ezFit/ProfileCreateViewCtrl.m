//
//  ProfileCreateViewCtrl.m
//  ezFit
//
//  Created by Stanley on 11/22/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import "AppDelegate.h"
#import "ezFitService.h"

#import "ProfileCreateViewCtrl.h"

#import "UIAlertController+CustomAlertController.h"

@interface ProfileCreateViewCtrl ()

@end

@implementation ProfileCreateViewCtrl {
    UITextField* currentEdit;
    BOOL keyboardIsShown;
    CGFloat keyboardOffsetHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    keyboardIsShown = NO;
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.actProfileUpdate stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"New Width = %f & New Height = %f",size.width,size.height);
    [currentEdit resignFirstResponder];
}

#pragma mark - Keyboard Show Hide Notification

- (void)keyboardWillShow:(NSNotification*)kbNotification {
    CGSize kbSize = [[[kbNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (keyboardOffsetHeight <= 0) {
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height -= kbSize.height;
        [self.view setFrame:viewFrame];
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
        keyboardOffsetHeight = kbSize.height;
    } else {
        if (keyboardOffsetHeight > kbSize.height) {
            CGRect viewFrame = self.view.frame;
            viewFrame.size.height += (keyboardOffsetHeight - kbSize.height);
            [self.view setFrame:viewFrame];
            [UIView animateWithDuration:0.3f animations:^{
                [self.view layoutIfNeeded];
            }];
            keyboardOffsetHeight = kbSize.height;
        } else {
            CGRect viewFrame = self.view.frame;
            viewFrame.size.height -= (kbSize.height - keyboardOffsetHeight);
            [self.view setFrame:viewFrame];
            [UIView animateWithDuration:0.3f animations:^{
                [self.view layoutIfNeeded];
            }];
            keyboardOffsetHeight = kbSize.height;
        }
    }
}

- (void)keyboardWillHide:(NSNotification*)kbNotification {
    CGSize kbSize = [[[kbNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += kbSize.height;
    [self.view setFrame:viewFrame];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
    keyboardOffsetHeight = 0.0;
}

#pragma mark - Text Field Delegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    currentEdit = textField;
    UIToolbar* pickerTool = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
    UIBarButtonItem* btnNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(pickerToolButtonNextClick)];
    UIBarButtonItem* btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerToolButtonDoneClick)];
    UIBarButtonItem* flexSp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [pickerTool setItems:@[btnNext,flexSp,btnDone]];
    [currentEdit setInputAccessoryView:pickerTool];
    
    if ([currentEdit isEqual:self.txtSex]) {
        UIPickerView* pickerSex = [[UIPickerView alloc] init];
        [pickerSex setDataSource:self];
        [pickerSex setDelegate:self];
        [pickerSex setShowsSelectionIndicator:YES];
        if ([self.txtSex.text isEqualToString:@""] || [self.txtSex.text isEqualToString:@"M"]) {
            [pickerSex selectedRowInComponent:0];
        } else {
            [pickerSex selectedRowInComponent:1];
        }
        [currentEdit setInputView:pickerSex];
    }
    if ([currentEdit isEqual:self.txtBirthdate]) {
        UIDatePicker* pickerBirthdate = [[UIDatePicker alloc] init];
        [pickerBirthdate addTarget:self action:@selector(pickerDateViewDidSelect:) forControlEvents:UIControlEventValueChanged];
        [pickerBirthdate setDatePickerMode:UIDatePickerModeDate];
        if ([self.txtBirthdate.text isEqualToString:@""]) {
            [pickerBirthdate setDate:[NSDate date]];
        } else {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            [pickerBirthdate setDate:[dateFormat dateFromString:self.txtBirthdate.text]];
        }
        [currentEdit setInputView:pickerBirthdate];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    switch (nextTag) {
        case 1:
            [self.txtSex becomeFirstResponder];
            break;
        case 2:
            [self.txtBirthdate becomeFirstResponder];
            break;
        case 3:
            [self.txtHeight becomeFirstResponder];
            break;
        case 4:
            [self.txtWaist becomeFirstResponder];
            break;
        case 5:
            [self.txtLastname becomeFirstResponder];
            break;
        case 6:
            [self.txtFirstname becomeFirstResponder];
            break;
        default:
            [textField resignFirstResponder];
            break;
    }
//    [textField resignFirstResponder];
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    if (nextResponder != nil) {
//        [nextResponder becomeFirstResponder];
//    }
    return YES;
}

- (void)pickerToolButtonNextClick {
    [self textFieldShouldReturn:currentEdit];
//    if ([currentEdit isEqual:self.txtSex]) {
//        [self.txtBirthdate becomeFirstResponder];
//    }
//    if ([currentEdit isEqual:self.txtBirthdate]) {
//        [self.txtHeight becomeFirstResponder];
//    }
}

- (void)pickerToolButtonDoneClick {
    [currentEdit resignFirstResponder];
}

#pragma mark - Picker View Data Source & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"M";
            break;
        case 1:
            return @"F";
            break;
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString* sex;
    if (row == 0) {
        sex = @"M";
    } else {
        sex = @"F";
    }
    [self.txtSex setText:sex];
}

- (void)pickerDateViewDidSelect:(UIDatePicker*)pickerView {
    NSLog(@"%@",pickerView.date);
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString* selectDate = [dateFormat stringFromDate:pickerView.date];
    [self.txtBirthdate setText:selectDate];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonRegisterClick:(id)sender {
    [currentEdit resignFirstResponder];
    [self setUpControlEnableByRequestMode:YES];
    [self.actProfileUpdate startAnimating];
    
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    NSDictionary* loginInfo = [settings objectForKey:@"loginInfo"];
    
    NSDictionary* updateProfile = @{@"nick_name":self.txtNickname.text,@"sex":self.txtSex.text,@"birth_date":self.txtBirthdate.text,@"height":self.txtHeight.text,@"waist":self.txtWaist.text,@"last_name":self.txtLastname.text,@"first_name":self.txtFirstname.text};
    
    ezFitService* service = [ezFitService sharedService];
    [service updateProfileWithUserAccount:[loginInfo objectForKey:@"email"] LoginToken:[loginInfo objectForKey:@"auto_login_token"] ProfileInfo:updateProfile Success:^(NSDictionary* result){
        NSLog(@"%@",result);
        
        NSDictionary* profile = [result objectForKey:@"profile"];
        NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
        [settings setObject:profile forKey:@"profileInfo"];
        [settings synchronize];

        NSDictionary* scaleInfo =[settings objectForKey:@"scaleInfo"];
        if (scaleInfo == nil) {
            UIAlertController* alert = [UIAlertController getScaleConnectAlertController];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [app switchRootViewToStoryboard:@"Main" WithIdentifier:@"MainView"];
        }
        [self.actProfileUpdate stopAnimating];
        [self setUpControlEnableByRequestMode:NO];
    } Fail:^(NSError* error){
        NSLog(@"%@",error);
        UIAlertController* alert = [UIAlertController getOnlyAlertControllerWithTitle:@"Update Error" Message:error.domain];
        [self presentViewController:alert animated:YES completion:nil];
        [self.actProfileUpdate stopAnimating];
        [self setUpControlEnableByRequestMode:NO];
    }];
}

- (IBAction)buttonCancelClick:(id)sender {
    [self.actProfileUpdate stopAnimating];
    [self setUpControlEnableByRequestMode:NO];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpControlEnableByRequestMode:(BOOL)reqMode {
    [self.txtNickname setEnabled:!reqMode];
    [self.txtSex setEnabled:!reqMode];
    [self.txtBirthdate setEnabled:!reqMode];
    [self.txtHeight setEnabled:!reqMode];
    [self.txtWaist setEnabled:!reqMode];
    [self.txtLastname setEnabled:!reqMode];
    [self.txtFirstname setEnabled:!reqMode];
}

@end
