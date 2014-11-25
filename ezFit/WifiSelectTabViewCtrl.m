//
//  WifiSelectTabViewCtrl.m
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import "ezFitService.h"

#import "WifiSelectTabViewCtrl.h"
#import "WifiSelectTabCellCtrl.h"

#import "WifiPasswdTabViewCtrl.h"

@interface WifiSelectTabViewCtrl ()

@end

@implementation WifiSelectTabViewCtrl {
    NSArray* wifiReachableList;
    NSDictionary* wifiSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIRefreshControl* refreshCtrl = [[UIRefreshControl alloc] init];
    [refreshCtrl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Drop down to refresh Wifi list ..."]];
    [refreshCtrl addTarget:self action:@selector(refreshWifiList) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:refreshCtrl];
    
    [self refreshWifiList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [wifiReachableList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WifiSelectTabCellCtrl *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWifiSelectTab" forIndexPath:indexPath];
    // Configure the cell...
    NSDictionary* wifiInfo = [wifiReachableList objectAtIndex:indexPath.row];
    
    [cell.txtSSID setText:[wifiInfo objectForKey:@"ssid"]];
    NSString* otherInfo = [NSString stringWithFormat:@"Secrity: %@,Other: %@ %@", [wifiInfo objectForKey:@"security"],[wifiInfo objectForKey:@"encrypt"],[wifiInfo objectForKey:@"other"]];
    [cell.txtOtherInfo setText:otherInfo];
    NSString* signalStrength = [wifiInfo objectForKey:@"strength"];
    [cell.imgSignalStrength setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Wifi-%@",signalStrength]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    wifiSelected = [wifiReachableList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueWifiSelect" sender:self];
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


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (wifiSelected == nil) {
        return NO;
    } else {
        return YES;
    }
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WifiPasswdTabViewCtrl* destView = segue.destinationViewController;
    [destView setWifiInfo:wifiSelected];
    wifiSelected = nil;
}


- (void)refreshWifiList {
    UIRefreshControl* refreshCtrl = [self refreshControl];
    [refreshCtrl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Wifi List if refreshing ..."]];
    [refreshCtrl beginRefreshing];
    
    ezFitService* service = [ezFitService sharedService];
    [service getWifiScanListSuccess:^(NSDictionary* result){
        wifiReachableList = [result objectForKey:@"result"];
        [self refreshWifiListDone];
    } Fail:^(NSError* error){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Wifi Scan" message:error.domain delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self refreshWifiListDone];
    }];
}

- (void)refreshWifiListDone {
    UIRefreshControl* refreshCtrl = [self refreshControl];
    [refreshCtrl endRefreshing];
    [refreshCtrl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Drop down to refresh Wifi list ..."]];
    [self.tabWifiList reloadData];
}
@end
