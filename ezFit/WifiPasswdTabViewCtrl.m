//
//  WifiPasswdTabViewCtrl.m
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import "AppDelegate.h"
#import "ezFitService.h"

#import "WifiPasswdTabViewCtrl.h"

#import "UIAlertController+CustomAlertController.h"

@interface WifiPasswdTabViewCtrl ()

@end

@implementation WifiPasswdTabViewCtrl {
    BOOL setupSuccess;
    NSMutableDictionary* wifiInfoObj;
    NSArray* pickerOptions;
    UITextField* currentEditing;
}

@synthesize txtSSID;
@synthesize txtSecurityType;
//@synthesize txtSignalStrength;
@synthesize txtEncrypt;
@synthesize txtOtherInfo;
@synthesize txtPassword;
@synthesize imgWifiSignal;
@synthesize btnConfirm;
@synthesize btnCancel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    setupSuccess = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (wifiInfoObj == nil) {
        wifiInfoObj = [NSMutableDictionary dictionaryWithDictionary:@{@"ssid":@"",@"security":@"None",@"encrypt":@"None",@"other":@"None/None"}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    [self showWifiInfo:wifiInfoObj];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"segueConfirmPasswd"]) {
        if (setupSuccess == YES) {
            return YES;
        }
        return NO;
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtSSID) {
        [txtSecurityType becomeFirstResponder];
    } else if (textField == txtPassword) {
        [txtPassword resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    currentEditing = textField;
    BOOL showPickerView = NO;
    if (textField == txtSecurityType) {
        pickerOptions = @[@{@"option":@"None"},@{@"option":@"WPA"},@{@"option":@"WPA2"},@{@"option":@"WPA/WPA2"}];
        showPickerView = YES;
    } else if (textField == txtEncrypt) {
        pickerOptions = @[@{@"option":@"None"},@{@"option":@"TKIP"},@{@"option":@"AES"},@{@"option":@"TKIP/AES"}];
        showPickerView = YES;
    } else if (textField == txtOtherInfo) {
        pickerOptions = @[@{@"option":@"None/None"},@{@"option":@"WPS Enable/None"},@{@"option":@"None/Shared Enable"},@{@"option":@"WPS Enable/Shared Enable"}];
        showPickerView = YES;
    }
    if (showPickerView == YES) {
        UIPickerView* pickerView = [[UIPickerView alloc] init];
        [pickerView setDataSource:self];
        [pickerView setDelegate:self];
        UIToolbar* pickerTool = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
        UIBarButtonItem* barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerButtonDoneClick)];
        UIBarButtonItem* barButtonNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(pickerButtonNextClick)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [pickerTool setItems:@[barButtonNext,flexibleSpace,barButtonDone]];
        [textField setInputView:pickerView];
        [textField setInputAccessoryView:pickerTool];
    }
}

#pragma mark PickerView DataSource & Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[pickerOptions objectAtIndex:row] objectForKey:@"option"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [currentEditing setText:[[pickerOptions objectAtIndex:row] objectForKey:@"option"]];
}

- (void)pickerButtonDoneClick {
    [currentEditing resignFirstResponder];
}

- (void)pickerButtonNextClick {
    switch (currentEditing.tag) {
        case 1:
            [txtEncrypt becomeFirstResponder];
            break;
        case 2:
            [txtOtherInfo becomeFirstResponder];
            break;
        case 3:
            [txtPassword becomeFirstResponder];
            break;
        default:
            break;
    }
}

- (IBAction)txtPasswdEditingChange:(id)sender {
    if ([txtPassword.text isEqualToString:@""] == NO) {
        [btnConfirm setEnabled:YES];
    } else {
        [btnConfirm setEnabled:NO];
    }
}

- (IBAction)btnConfirmClick:(id)sender {
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [currentEditing resignFirstResponder];
    [wifiInfoObj setObject:txtSSID.text forKey:@"ssid"];
    [wifiInfoObj setObject:txtSecurityType.text forKey:@"security"];
    [wifiInfoObj setObject:txtEncrypt.text forKey:@"encrypt"];
    [wifiInfoObj setObject:txtOtherInfo.text forKey:@"other"];
    
    ezFitService* service = [ezFitService sharedService];
    [service setWifiPasswordWithWifiInfo:wifiInfoObj AndPassword:txtPassword.text Success:^(NSDictionary* result){
        setupSuccess = YES;

        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ScaleConnectRunning"] != nil) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ScaleConnectRunning"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }    
        
        [app switchRootViewToStoryboard:@"Main" WithIdentifier:@"MainView"];
    } Fail:^(NSError* error){
        setupSuccess = NO;
        UIAlertController* alert = [UIAlertController getOnlyAlertControllerWithTitle:@"Setup Error" Message:@"Wifi Ap password setup fail !"];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertController* alertScale = [UIAlertController getScaleConnectAlertController];
        [self presentViewController:alertScale animated:YES completion:nil];
    }];
}

- (IBAction)btnCancelClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setWifiInfo:(NSDictionary *)wifiInfo {
    wifiInfoObj = [NSMutableDictionary dictionaryWithDictionary:wifiInfo];
}

- (void)showWifiInfo:(NSDictionary*)wifiInfo {
    [txtSSID setText:[wifiInfo objectForKey:@"ssid"]];
    [txtSecurityType setText:[wifiInfo objectForKey:@"security"]];
    [txtEncrypt setText:[wifiInfo objectForKey:@"encrypt"]];
//    [txtSignalStrength setText:[NSString stringWithFormat:@"%@ dBm",[wifiInfo objectForKey:@"strength"]]];
    [txtOtherInfo setText:[NSString stringWithFormat:@"%@",[wifiInfo objectForKey:@"other"]]];
    NSString* signalStrength = [wifiInfo objectForKey:@"strength"];
    [imgWifiSignal setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Wifi-%@",signalStrength]]];
}
@end
