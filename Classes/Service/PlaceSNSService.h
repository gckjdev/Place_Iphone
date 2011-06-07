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

@interface PlaceSNSService : SNSServiceHandler {
    
    SINAWeiboRequest    *sinaRequest;
    QQWeiboRequest      *qqRequest;
    
}

@property (nonatomic, retain) SINAWeiboRequest    *sinaRequest;
@property (nonatomic, retain) QQWeiboRequest      *qqRequest;


- (BOOL)sinaLoginForAuthorization;
- (BOOL)qqLoginForAuthorization;

@end
