//
//  PlaceSNSService.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSServiceHandler.h"
#import "SINAWeiboRequest.h"
#import "QQWeiboRequest.h"

@class PPViewController;

typedef void (^AuthorizationSuccessHandler)(NSDictionary*, PPViewController*);

@interface PlaceSNSService : SNSServiceHandler {
    
    SINAWeiboRequest    *sinaRequest;
    QQWeiboRequest      *qqRequest;
    dispatch_queue_t    workingQueue;

}

@property (nonatomic, retain) SINAWeiboRequest    *sinaRequest;
@property (nonatomic, retain) QQWeiboRequest      *qqRequest;

- (BOOL)hasQQCacheData;
- (BOOL)hasSinaCacheData;

- (void)sinaParseAuthorizationResponseURL:(NSString *)query viewController:(PPViewController*)viewController successHandler:(AuthorizationSuccessHandler)successHandler;
- (void)qqParseAuthorizationResponseURL:(NSString *)query viewController:(PPViewController*)viewController successHandler:(AuthorizationSuccessHandler)successHandler;
- (void)sinaInitiateLogin:(PPViewController*)viewController;
- (void)qqInitiateLogin:(PPViewController*)viewController;

@end


