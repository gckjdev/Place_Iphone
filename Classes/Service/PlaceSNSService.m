//
//  PlaceSNSService.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlaceSNSService.h"

#define SINA_APP_KEY                    @"1528146353"
#define SINA_APP_SECRET                 @"4815b7938e960380395e6ac1fe645a5c"
#define SINA_CALLBACK_URL               @"dipan://sina"

#define QQ_APP_KEY                      @"7c78d5b42d514af8bb66f0200bc7c0fc"
#define QQ_APP_SECRET                   @"6340ae28094e66d5388b4eb127a2af43"
#define QQ_CALLBACK_URL                 @"dipan://qq"

@implementation PlaceSNSService

@synthesize sinaRequest;
@synthesize qqRequest;

- (id)init
{
    self = [super init];
    
    self.sinaRequest = [[SINAWeiboRequest alloc] initWithAppKey:SINA_APP_KEY
                                                      appSecret:SINA_APP_SECRET
                                                    callbackURL:SINA_CALLBACK_URL
                                                     oauthToken:nil
                                               oauthTokenSecret:nil];
    
    self.qqRequest = [[QQWeiboRequest alloc] initWithAppKey:QQ_APP_KEY
                                                      appSecret:QQ_APP_SECRET
                                                    callbackURL:QQ_CALLBACK_URL
                                                     oauthToken:nil
                                               oauthTokenSecret:nil];
    
    return self;
}

- (void)dealloc
{
    [sinaRequest release];
    [qqRequest release];
    [super dealloc];
}

- (BOOL)sinaLoginForAuthorization
{
    return [self loginForAuthorization:sinaRequest];
}

- (BOOL)qqLoginForAuthorization
{
    return [self loginForAuthorization:qqRequest];
}

@end
