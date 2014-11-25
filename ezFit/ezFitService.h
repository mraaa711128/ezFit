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

- (void)loginWithUserId:(NSString*)userid Password:(NSString*)password Success:(successBlockType) successBlock Fail:(failBlockType)failBlock;

- (void)registerWithUserInfo:(NSDictionary*)userInfo Success:(successBlockType)successBlock Fail:(failBlockType)failBlock;

- (void)getUserRecordsWithUserId:(NSString*)userid LoginToken:(NSString*)token Date:(NSString*)date Success:(successBlockType)successBlock Fail:(failBlockType) failBlock;

@end
