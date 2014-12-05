//
//  ezFitService.m
//  ezFit
//
//  Created by Stanley on 11/23/14.
//  Copyright (c) 2014 Stanley. All rights reserved.
//

#import "ezFitService.h"

#import "AFHTTPSessionManager.h"

#if DEBUG
    static NSString* const ezFitServiceUrl = @"http://localhost/ezFit";
    static NSString* const ezFitScaleUrl = @"http://localhost/ezFitScale/scan_results.txt";
//    static NSString* const ezFitScalePasswordUrl = @"http://locahost/ezFitScale/connect?as0=[SSID]&at0=[WIFITYPE]&ap0=[PASSWORD]";
    static NSString* const ezFitScalePasswordUrl = @"http://locahost/ezFitScale/connect";
#else
    static NSString* const ezFitServiceUrl = @"http://54.169.109.166/ezFit";
    static NSString* const ezFitScaleUrl = @"http://192.168.0.1/../scan_results.txt";
//    static NSString* const ezFitScalePasswordUrl = @"http://192.168.0.1/connect?as0=[SSID]&at0=[WIFITYPE]&ap0=[PASSWORD]";
    static NSString* const ezFitScalePasswordUrl = @"http://192.168.0.1/connect";
#endif

NSString* const ezWifiListEmptyDomain = @"There is no Wifi nearby !";

static ezFitService* instance;
static AFHTTPSessionManager* manager;

@implementation ezFitService {

}

+ (ezFitService *)sharedService {
    if (instance == nil) {
        instance = [[ezFitService alloc] init];
    }
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        serviceInfo = [[NSMutableDictionary alloc] init];
        
        manager = [AFHTTPSessionManager manager];
    }
    return self;
}

+ (id)getHttpSessionManager {
    if (manager == nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[ezFitServiceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    return manager;
}

- (void)getWifiScanListSuccess:(successBlockType)success Fail:(failBlockType)fail {
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [mgr GET:ezFitScaleUrl parameters:nil success:^(NSURLSessionDataTask* task, id responseObject){
        NSLog(@"%@",responseObject);
        NSData* responseData = [NSData dataWithData:responseObject];
        NSRange range = {6,[responseData length]-6};
        responseData = [responseData subdataWithRange:range];
        NSString* scanString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
        if ([scanString isEqualToString:@""]) {
            if (fail) {
                fail([NSError errorWithDomain:ezWifiListEmptyDomain code:200 userInfo:nil]);
            }
        } else {
            NSDictionary* result = [self processWifiScanListByScanString:scanString];
            if (success) {
                success(result);
            }
        }
    } failure:^(NSURLSessionDataTask* task, NSError* error){
        if (fail) {
            fail(error);
        }
    }];
}

- (NSDictionary*)processWifiScanListByScanString:(NSString*)scanstring {
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    NSMutableArray* returnList = [[NSMutableArray alloc] init];
    NSArray* arrList = [scanstring componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [arrList count] - 1; i += 8) {
        NSMutableDictionary* listItem = [[NSMutableDictionary alloc] init];
        [listItem setObject:[arrList objectAtIndex:i] forKey:@"seq"];
        NSString* SSID = [self stringFromHexString:[arrList objectAtIndex:(i+1)]];
        [listItem setObject:SSID forKey:@"ssid"];
        NSInteger type = [(NSString*)[arrList objectAtIndex:(i+2)] integerValue];
        [listItem setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"wifitype"];
        NSString* hexStr = [NSString stringWithFormat:@"%08lx",(long)type];
        NSString* wps = [hexStr substringWithRange:NSMakeRange(0, 1)];
        NSString* shared = [hexStr substringWithRange:NSMakeRange(4, 1)];
        NSString* security = [hexStr substringWithRange:NSMakeRange(2, 1)];
        NSString* encrypt = [hexStr substringWithRange:NSMakeRange(7, 1)];
        if (wps.intValue == 1) {
            wps = @"WPS Enable";
        } else {
            wps = @"";
        }
        if (shared.intValue == 8) {
            shared = @"Shared Enable";
        } else {
            shared = @"";
        }
        switch (security.intValue / 2) {
            case 0:
                security = @"None";
                break;
            case 1:
                security = @"WPA";
                break;
            case 2:
                security = @"WPA2";
                break;
            case 3:
                security = @"WPA/WPA2";
                break;
            default:
                security = @"Error";
                break;
        }
        switch (encrypt.intValue / 2) {
            case 0:
                encrypt = @"None";
                break;
            case 1:
                encrypt = @"TKIP";
                break;
            case 2:
                encrypt = @"AES";
                break;
            case 3:
                encrypt = @"TKIP/AES";
                break;
            default:
                encrypt = @"Error";
                break;
        }
        [listItem setObject:security forKey:@"security"];
        [listItem setObject:encrypt forKey:@"encrypt"];
        [listItem setObject:[NSString stringWithFormat:@"%@/%@",wps,shared] forKey:@"other"];
        NSInteger signal = [(NSString*)[arrList objectAtIndex:(i+4)] integerValue]+100;
        [listItem setObject:[NSString stringWithFormat:@"%ld",(long)(signal / 20)] forKey:@"strength"];
        [returnList addObject:listItem];
    }
    [result setObject:returnList forKey:@"result"];
    return result;
}

- (NSString*)getWifiTypeWithWps:(NSString*)wps AndShared:(NSString*)shared AndSecurity:(NSString*)security AndEncrypt:(NSString*)encrypt {
    if ([wps isEqualToString:@"WPS Enable"]) {
        wps = @"1";
    } else {
        wps = @"0";
    }
    if ([shared isEqualToString:@"Shared Enable"]) {
        shared = @"8";
    } else {
        shared = @"0";
    }
    if ([security isEqualToString:@"None"]) {
        security = @"0";
    } else if ([security isEqualToString:@"WPA"]) {
        security = @"2";
    } else if ([security isEqualToString:@"WPA2"]) {
        security = @"4";
    } else if ([security isEqualToString:@"WPA/WPA2"]) {
        security = @"6";
    } else {
        security = @"0";
    }
    if ([encrypt isEqualToString:@"None"]) {
        encrypt = @"0";
    } else if ([encrypt isEqualToString:@"TKIP"]) {
        encrypt = @"2";
    } else if ([encrypt isEqualToString:@"AES"]) {
        encrypt = @"4";
    } else if ([encrypt isEqualToString:@"TKIP/AES"]) {
        encrypt = @"6";
    } else {
        encrypt = @"0";
    }
    unsigned int wifitype = 0;
    NSScanner* scanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"0x%@0%@0%@00%@",wps,security,shared,encrypt]];
    [scanner scanHexInt:&wifitype];
    return [NSString stringWithFormat:@"%u",wifitype];
}

- (void)setWifiPasswordWithWifiInfo:(NSDictionary*)wifiInfo AndPassword:(NSString*)password Success:(successBlockType)success Fail:(failBlockType)fail {
    NSString* SSID = [wifiInfo objectForKey:@"ssid"];
    NSString* TYPE = [wifiInfo objectForKey:@"wifitype"];
    if (TYPE == nil) {
        NSString* other = [wifiInfo objectForKey:@"other"];
        NSArray* arrOther = [other componentsSeparatedByString:@"/"];
        NSString* wps = [arrOther objectAtIndex:0];
        NSString* shared = [arrOther objectAtIndex:1];
        TYPE = [self getWifiTypeWithWps:wps AndShared:shared AndSecurity:[wifiInfo objectForKey:@"security"] AndEncrypt:[wifiInfo objectForKey:@"encrypt"]];
    }
    NSMutableDictionary* paras = [[NSMutableDictionary alloc] init];
    [paras setObject:SSID forKey:@"as0"];
    [paras setObject:TYPE forKey:@"at0"];
    [paras setObject:password forKey:@"ap0"];
    /*
    NSString* passwordUrl = ezFitScalePasswordUrl;
    passwordUrl = [passwordUrl stringByReplacingOccurrencesOfString:@"[SSID]" withString:SSID];
    passwordUrl = [passwordUrl stringByReplacingOccurrencesOfString:@"[WIFITYPE]" withString:TYPE];
    passwordUrl = [passwordUrl stringByReplacingOccurrencesOfString:@"[PASSWORD]" withString:[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    */
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    [mgr setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [mgr GET:ezFitScalePasswordUrl parameters:paras success:^(NSURLSessionDataTask* task, id responseObject){
    } failure:^(NSURLSessionDataTask* task, NSError* error){
        NSLog(@"%@",error);
        if (fail) {
        }
    }];
    if (success) {
        NSDictionary* result = @{@"result":@{@"code":@"0",@"message":@"Success"}};
        success(result);
    }
}

- (void)loginWithUserId:(NSString *)userid Password:(NSString *)password Success:(successBlockType)successBlock Fail:(failBlockType)failBlock {
    
}

- (void)registerWithUserInfo:(NSDictionary *)userInfo Success:(successBlockType)successBlock Fail:(failBlockType)failBlock {
    
}

- (void)getUserRecordsWithUserId:(NSString *)userid LoginToken:(NSString *)token Date:(NSString *)date Success:(successBlockType)successBlock Fail:(failBlockType)failBlock {
    
}

- (NSString *)stringFromHexString:(NSString *)hexString {
    NSMutableString * newString = [[NSMutableString alloc] init];
    int i = 0;
    while (i < [hexString length])
    {
        NSString * hexChar = [hexString substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
        i+=2;
    }
    return newString;
}

@end
