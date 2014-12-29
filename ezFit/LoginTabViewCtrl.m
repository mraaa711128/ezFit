//
//  LoginTabViewCtrl.m
//  ezFit
//
//  Created by Stanley on 12/17/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import "AppDelegate.h"
#import "ezFitService.h"

#import "LoginTabViewCtrl.h"
#import "LoginInputCellCtrl.h"

#import "UIView+CustomVisualization.h"
#import "UIAlertController+CustomAlertController.h"

@interface LoginTabViewCtrl ()

@end

@implementation LoginTabViewCtrl {
    BOOL isRegMode;
    CGFloat keyboardOffsetHeight;
    UITextField* currentEdit;
    UITextField* txtUserId;
    UITextField* txtPasswd;
    UITextField* txtRePasswd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    isRegMode = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.viewUserInput setCornerRadius:5.f];

    [self.actLoginConfirm stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setUpInputViewSizeByRegMode:isRegMode];
    [self setUpButtonTitleByRegMode:isRegMode];
    [self setUpButtonClickEventByRegMode:isRegMode];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//    CGRect viewFrame = self.view.frame;
//    viewFrame.size.height -= kbSize.height;
//    [self.view setFrame:viewFrame];
//    [UIView animateWithDuration:0.3f animations:^{
//        [self.view layoutIfNeeded];
//    }];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:txtUserId]) {
        [txtPasswd becomeFirstResponder];
    } else if ([textField isEqual:txtPasswd]) {
        if (isRegMode == NO) {
            [txtPasswd resignFirstResponder];
        } else {
            [txtRePasswd becomeFirstResponder];
        }
    } else if ([textField isEqual:txtRePasswd]) {
        [txtRePasswd resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    currentEdit = textField;
    if ([textField isEqual:txtPasswd]) {
        if (isRegMode == NO) {
            [txtPasswd setReturnKeyType:UIReturnKeyDone];
        } else {
            [txtPasswd setReturnKeyType:UIReturnKeyNext];
        }
    }
}

#pragma mark - Button Click Action

- (void)buttonLoginClick:(UIButton*)sender {
    [currentEdit resignFirstResponder];
    [self setUpControlEnableByRequestMode:YES];
    [self.actLoginConfirm startAnimating];
    
    ezFitService* service = [ezFitService sharedService];
    [service loginWithUserAccount:txtUserId.text Password:txtPasswd.text Success:^(NSDictionary* result){
        NSLog(@"%@",result);
        
        NSDictionary* loginInfo = [result objectForKey:@"userinfo"];
        NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
        [settings setObject:loginInfo forKey:@"loginInfo"];
        [settings synchronize];
        
        NSDictionary* scaleInfo =[settings objectForKey:@"scaleInfo"];
        NSDictionary* profileInfo = [settings objectForKey:@"profileInfo"];
        if (scaleInfo == nil) {
            UIAlertController* alert = [UIAlertController getScaleConnectAlertController];
            [self presentViewController:alert animated:YES completion:nil];
            
//            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Scale Connection" message:@"There is no scales connection with this account ! Do you want connect your scale ?" delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"Start Connect", nil];
//            [alertView setTag:0];
//            [alertView show];
        } else {
            if (profileInfo == nil) {
                AppDelegate* app =(AppDelegate*)[UIApplication sharedApplication].delegate;
                [app switchRootViewToStoryboard:@"Login" WithIdentifier:@"ProfileCreateView"];
            } else {
                AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [app switchRootViewToStoryboard:@"Main" WithIdentifier:@"MainView"];
            }
        }
        [self.actLoginConfirm stopAnimating];
        [self setUpControlEnableByRequestMode:NO];
    } Fail:^(NSError* error){
        NSLog(@"%@",error);
        UIAlertController* alert = [UIAlertController getOnlyAlertControllerWithTitle:@"Login Error" Message:error.domain];
        [self presentViewController:alert animated:YES completion:nil];
        [self.actLoginConfirm stopAnimating];
        [self setUpControlEnableByRequestMode:NO];
    }];
    
}

- (void)buttonRegisterClick:(UIButton*)sender {
    isRegMode = YES;
    
    [self setUpInputViewSizeByRegMode:isRegMode];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view layoutIfNeeded];
        [self setUpButtonTitleByRegMode:isRegMode];
    }];
    [self setUpButtonClickEventByRegMode:isRegMode];
}

- (void)buttonConfirmClick:(UIButton*)sender {
    [currentEdit resignFirstResponder];
    [self setUpControlEnableByRequestMode:YES];
    [self.actLoginConfirm startAnimating];
    
    if ([txtPasswd.text isEqualToString:txtRePasswd.text] == NO) {
        UIAlertController* alert = [UIAlertController getOnlyAlertControllerWithTitle:@"Password Error" Message:@"Password validation fail ! Please type exactly the same for both !"];
        [self presentViewController:alert animated:YES completion:nil];
        [self.actLoginConfirm stopAnimating];
    } else {
        ezFitService* service = [ezFitService sharedService];
        [service registerWithUserAccount:txtUserId.text Password:txtPasswd.text Success:^(NSDictionary* result){
            NSLog(@"%@",result);
            
            NSDictionary* loginInfo = [result objectForKey:@"userinfo"];
            NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
            [settings setObject:loginInfo forKey:@"loginInfo"];
            [settings synchronize];
            
            UIViewController* nextViewCtrl = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileCreateView"];
            [self.navigationController pushViewController:nextViewCtrl animated:YES];
            
            [self.actLoginConfirm stopAnimating];
            [self setUpControlEnableByRequestMode:NO];
        } Fail:^(NSError* error){
            NSLog(@"%@",error);
            UIAlertController* alert = [UIAlertController getOnlyAlertControllerWithTitle:@"Register Error" Message:error.domain];
            [self presentViewController:alert animated:YES completion:nil];
            [self.actLoginConfirm stopAnimating];
            [self setUpControlEnableByRequestMode:NO];
        }];
    }
}

- (void)buttonCancelClick:(UIButton*)sender {
    isRegMode = NO;

    [self setUpInputViewSizeByRegMode:isRegMode];
    [UIView animateWithDuration:0.4f animations:^{
        [self.view layoutIfNeeded];
        [self setUpButtonTitleByRegMode:isRegMode];
    }];
    [self setUpButtonClickEventByRegMode:isRegMode];
}

- (void)setUpControlEnableByRequestMode:(BOOL)reqMode {
    [txtUserId setEnabled:!reqMode];
    [txtPasswd setEnabled:!reqMode];
    [txtRePasswd setEnabled:!reqMode];
    [self.btnLoginConfirm setEnabled:!reqMode];
    [self.btnRegisterCancel setEnabled:!reqMode];
}

- (void)setUpInputViewSizeByRegMode:(BOOL)regMode {
    if (regMode == NO) {
        [self.cstInputViewHeight setConstant:88.0];
        [self.viewUserInput updateConstraints];
    } else {
        [self.cstInputViewHeight setConstant:132.0];
        [self.viewUserInput updateConstraints];
    }
}

- (void)setUpButtonTitleByRegMode:(BOOL)regMode {
    [UIView animateWithDuration:0.2f animations:^{
        [self.btnLoginConfirm setAlpha:0.0];
        [self.btnRegisterCancel setAlpha:0.0];
    }];
    if (regMode == NO) {
        [self.btnLoginConfirm setTitle:@"Log In" forState:UIControlStateNormal];
        [self.btnRegisterCancel setTitle:@"Register" forState:UIControlStateNormal];
    } else {
        [self.btnLoginConfirm setTitle:@"Confirm" forState:UIControlStateNormal];
        [self.btnRegisterCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2f animations:^{
        [self.btnLoginConfirm setAlpha:1.0];
        [self.btnRegisterCancel setAlpha:1.0];
    }];
}

- (void)setUpButtonClickEventByRegMode:(BOOL)regMode {
    if (regMode == NO) {
        [self.btnLoginConfirm removeTarget:self action:@selector(buttonConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRegisterCancel removeTarget:self action:@selector(buttonCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnLoginConfirm addTarget:self action:@selector(buttonLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRegisterCancel addTarget:self action:@selector(buttonRegisterClick:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.btnLoginConfirm removeTarget:self action:@selector(buttonLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRegisterCancel removeTarget:self action:@selector(buttonRegisterClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnLoginConfirm addTarget:self action:@selector(buttonConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRegisterCancel addTarget:self action:@selector(buttonCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginInputCellCtrl* cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellUserId" forIndexPath:indexPath];
            txtUserId = cell.txtUserId;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellPasswd" forIndexPath:indexPath];
            txtPasswd = cell.txtPasswd;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellRePasswd" forIndexPath:indexPath];
            txtRePasswd = cell.txtRePasswd;
            break;
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
