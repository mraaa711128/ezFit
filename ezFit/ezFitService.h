//
//  ezFitService.h
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^successBlockType)(NSDictionary* result);
typedef void (^failBlockType)(NSError* error);


@interface ezFitService : NSObject {
    NSMutableArray* serviceDelegate;
    NSMutableDictionary* serviceInfo;
    NSMutableArray* serviceRequest;
    NSString* test;
}

+ (ezFitService*)sharedService;

- (void)getWifiScanListSuccess:(successBlockType)success Fail:(failBlockType)fail;

- (void)setWifiPasswordWithWifiInfo:(NSDictionary*)wifiInfo AndPassword:(NSString*)password Success:(successBlockType)success Fail:(failBlockType)fail;

- (void)loginWithUserAccount:(NSString*)useract Password:(NSString*)password Success:(successBlockType) successBlock Fail:(failBlockType)failBlock;

- (void)registerWithUserAccount:(NSString*)useract Password:(NSString*)password Success:(successBlockType)successBlock Fail:(failBlockType)failBlock;

- (void)updateProfileWithUserAccount:(NSString*)useract LoginToken:(NSString*)token ProfileInfo:(NSDictionary*)profile Success:(successBlockType)successBlock Fail:(failBlockType)failBlock;

- (void)getUserRecordsWithUserAccount:(NSString*)useract LoginToken:(NSString*)token Date:(NSString*)date Success:(successBlockType)successBlock Fail:(failBlockType) failBlock;

- (void)getLatestRecordWithUserAccount:(NSString*)useract LoginToken:(NSString*)token Success:(successBlockType) successBlock Fail:(failBlockType) failBlock;

@end
