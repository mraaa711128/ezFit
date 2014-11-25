//
//  WifiPasswdTabViewCtrl.m
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import "ezFitService.h"

#import "WifiPasswdTabViewCtrl.h"

@interface WifiPasswdTabViewCtrl ()

@end

@implementation WifiPasswdTabViewCtrl {
    BOOL setupSuccess;
    NSDictionary* wifiInfoObj;
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

- (IBAction)txtPasswdEditingChange:(id)sender {
    if ([txtPassword.text isEqualToString:@""] == NO) {
        [btnConfirm setEnabled:YES];
    } else {
        [btnConfirm setEnabled:NO];
    }
}

- (IBAction)btnConfirmClick:(id)sender {
    ezFitService* service = [ezFitService sharedService];
    [service setWifiPasswordWithWifiInfo:wifiInfoObj AndPassword:txtPassword.text Success:^(NSDictionary* result){
        setupSuccess = YES;
    } Fail:^(NSError* error){
        setupSuccess = NO;
    }];
}

- (IBAction)btnCancelClick:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setWifiInfo:(NSDictionary *)wifiInfo {
    wifiInfoObj = wifiInfo;
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
