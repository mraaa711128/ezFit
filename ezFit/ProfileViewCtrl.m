//
//  ProfileViewCtrl.m
//  ezFit
//
//  Created by Stanley on 12/29/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//
#import "ezFitService.h"

#import "ProfileViewCtrl.h"

#import "ProfileHeadCtrl.h"
#import "BodyIndicatorCellCtrl.h"

#import "UIAlertController+CustomAlertController.h"

@interface ProfileViewCtrl ()

@end

@implementation ProfileViewCtrl {
    NSDictionary* recordInfo;
}

static NSString * const headReuseId = @"headProfile";
static NSString * const cellReuseId = @"cellBodyIndicator";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[ProfileHeadCtrl class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headReuseId];
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseId];
    
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSDictionary* loginInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginInfo"];
    
    ezFitService* service = [ezFitService sharedService];
    [service getLatestRecordWithUserAccount:[loginInfo objectForKey:@"email"] LoginToken:[loginInfo objectForKey:@"auto_login_token"] Success:^(NSDictionary* result) {
        recordInfo = [result objectForKey:@"weightrawdata"];
        if (recordInfo != nil) {
            [self.collectionView reloadData];
        }
    } Fail:^(NSError* error) {
        UIAlertController* alert = [UIAlertController getOnlyAlertControllerWithTitle:@"Error" Message:error.domain];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ProfileHeadCtrl* headView;
    NSDictionary* profileInfo;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        headView = (ProfileHeadCtrl*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headReuseId forIndexPath:indexPath];
        profileInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileInfo"];
        if (profileInfo != nil) {
            [headView setProfileInfo:profileInfo];
        }
    }

    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BodyIndicatorCellCtrl* cellView = (BodyIndicatorCellCtrl*)[collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
    
    if (recordInfo != nil) {
        switch (indexPath.row) {
            case 0:
                [cellView setIndicatorName:@"Weight" Value:[recordInfo objectForKey:@"weight"] Unit:@"Kg"];
                break;
            case 1:
                [cellView setIndicatorName:@"Resistor" Value:[recordInfo objectForKey:@"resistor"] Unit:@""];
                break;
            default:
                break;
        }
    }
    
    // Configure the cell
    
    return cellView;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
