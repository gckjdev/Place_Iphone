//
//  UserService.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserManager.h"

@class PPViewController;

enum{
    USER_STATUS_UNKNOWN = 0,    
    USER_NOT_EXIST_LOCAL = 1100001,
    USER_EXIST_LOCAL_STATUS_LOGIN,
    USER_EXIST_LOCAL_STATUS_LOGOUT,
    
    
};

enum{
    LOGIN_RESULT_SUCCESS = 0,
    LOGIN_RESULT_UNKNOWN = 1200000,
    LOGIN_RESULT_ID_NOT_MATCH,  
    LOGIN_RESULT_NETWORK_ERROR,
};

@protocol UserServiceDelegate <NSObject>

- (void)checkDeviceResult:(int)result;
- (void)loginUserResult:(int)result;

@end



@interface UserService : NSObject {
    
    User                    *user;              // save and cache current user
    id<UserServiceDelegate> delegate;           
    dispatch_queue_t        workingQueue;
    int                     userCurrentStatus;
}

@property (nonatomic, retain) User        *user;
@property (nonatomic, assign) id<UserServiceDelegate> delegate; 

- (id)init;

- (NSString*)userId;

- (void)checkDevice;
- (void)loginUserWithLoginId:(NSString*)loginId viewController:(PPViewController*)viewController;


@end
