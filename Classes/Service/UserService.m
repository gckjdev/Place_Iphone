//
//  UserService.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"
#import "AppManager.h"
#import "PPViewController.h"

#import "RegisterUserRequest.h"
#import "DeviceLoginRequest.h"
#import "BindUserRequest.h"
#import "SNSConstants.h"

@implementation UserService

@synthesize user;
@synthesize delegate;



// you MUST call this method whenever you update the user data in database
- (void)updateUserCache
{
    userCurrentStatus= USER_STATUS_UNKNOWN;    
    self.user = [UserManager getUser];
    if (user == nil){
        userCurrentStatus = USER_NOT_EXIST_LOCAL;
    }
    else if ([user isLogin]){
        userCurrentStatus = USER_EXIST_LOCAL_STATUS_LOGIN;
    }
    else{
        userCurrentStatus = USER_EXIST_LOCAL_STATUS_LOGOUT;
    }
}

- (id)init
{
    self = [super init];

    workingQueue = dispatch_queue_create("user service queue", NULL);
    [self updateUserCache];
    
    return self;
}

- (void)dealloc
{
    dispatch_release(workingQueue);
    workingQueue = NULL;
    
    [user release];
    [super dealloc];
}

- (NSString*)userId
{
    return user.userId;
}

- (BOOL)isLocalUserDataExist
{
    return (user != nil);
}

- (void)checkDevice {

    int result;
    NSLog(@"<checkDevice> user current status is %d", userCurrentStatus);
    
    switch (userCurrentStatus) {
        case USER_STATUS_UNKNOWN:
        case USER_NOT_EXIST_LOCAL:
        {
            DeviceLoginOutput* output = [DeviceLoginRequest send:SERVER_URL
                                                           appId:[AppManager getPlaceAppId]
                                                  needReturnUser:YES];
            
            if (output.resultCode == ERROR_SUCCESS) {
                NSLog(@"<checkDevice> get user from remote successfully, userId=%@, loginId=%@", output.userId, output.loginId);
                
                // TODO combine two lines below into one method
                [UserManager setUserWithUserId:output.userId
                                       loginId:output.loginId
                                      nickName:output.nickName
                                        avatar:output.userAvatar
                               sinaAccessToken:output.sinaAccessToken
                         sinaAccessTokenSecret:output.sinaAccessTokenSecret
                                 qqAccessToken:output.qqAccessToken
                           qqAccessTokenSecret:output.qqAccessTokenSecret
                                   loginStatus:YES];
                [self updateUserCache];                
            } 
            else if (output.resultCode == ERROR_NETWORK){
                NSLog(@"<checkDevice> fail to get user from remote due to network faiure");  
                [UIUtils alert:NSLS(@"kSystemFailure")];
            }
            else
            {
                // TODO, need to show different error based on error code
                NSLog(@"<checkDevice> fail to get user from remote, error=%d", output.resultCode);
            }            
        }
            break;
            
        case USER_EXIST_LOCAL_STATUS_LOGIN:
        {
            NSLog(@"<checkDevice> local user found, status LOGIN, check user/device binding in background");
            dispatch_async(workingQueue, ^{
                DeviceLoginOutput* output = [DeviceLoginRequest send:SERVER_URL
                                                               appId:[AppManager getPlaceAppId]
                                                      needReturnUser:NO];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (output.resultCode == ERROR_SUCCESS) {
                        NSLog(@"<checkDevice> user status verified successful");
                    }
                    else{
                        // TODO, need to handle different error code
                    }
                });
                
            });                        
        }
            break;
            
        case USER_EXIST_LOCAL_STATUS_LOGOUT:
            NSLog(@"<checkDevice> local user found, status LOGOUT, do nothing");            
            break;
        default:
            break;
    }
        
    result = userCurrentStatus;
    if (delegate && [delegate respondsToSelector:@selector(checkDeviceResult:)]){
        [delegate checkDeviceResult:result];        
    }
}

- (BOOL)verifyLoginId:(NSString*)loginId
{
    return ([user.loginId compare:[loginId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]                                                               
                          options:NSCaseInsensitiveSearch] == NSOrderedSame);
        
}

- (int)setLocalStatusLogin:(NSString*)loginId
{
    if ([self verifyLoginId:loginId] == NO)
        return LOGIN_RESULT_ID_NOT_MATCH;
    
    [UserManager userLoginSuccess:user];
    [self updateUserCache];

    return LOGIN_RESULT_SUCCESS;
}

- (void)registerUserWithLoginId:(NSString*)loginId viewController:(PPViewController*)viewController
{
    NSString* appId = [AppManager getPlaceAppId];
    NSString* nickName = loginId;
    NSString* deviceToken = @"";
    
    [viewController showActivityWithText:NSLS(@"kRegisteringUser")];    
    dispatch_async(workingQueue, ^{
        RegisterUserOutput* output = [RegisterUserRequest send:SERVER_URL 
                                                       loginId:nickName
                                                   loginIdType:LOGINID_OWN
                                                   deviceToken:deviceToken
                                                      nickName:loginId
                                                        avatar:nil
                                                   accessToken:nil
                                             accessTokenSecret:nil
                                                         appId:appId
                                                      province:PROVINCE_UNKNOWN
                                                          city:CITY_UNKNOWN
                                                      location:nil
                                                        gender:nil 
                                                      birthday:nil
                                                  sinaNickName:nil
                                                    sinaDomain:nil
                                                    qqNickName:nil
                                                      qqDomain:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                [UserManager setUserWithUserId:output.userId
                                       loginId:loginId
                                   loginIdType:LOGINID_OWN
                                      nickName:nickName
                                        avatar:nil
                                   accessToken:nil
                             accessTokenSecret:nil
                                   loginStatus:YES];
                [self updateUserCache];                 // MUST call this!!!
            }

            [delegate loginUserResult:output.resultCode];
        });
    });
    
}

- (int)getSNSType:(NSDictionary*)userInfo
{
    NSString* networkName = [userInfo objectForKey:SNS_NETWORK];
    if ([networkName isEqualToString:SNS_SINA_WEIBO]){
        return LOGINID_SINA;
    }
    else if ([networkName isEqualToString:SNS_QQ_WEIBO]){
        return LOGINID_QQ;
    }
    
    return LOGINID_SINA;
}

- (void)bindUserWithSNSUserInfo:(NSDictionary*)userInfo viewController:(PPViewController*)viewController
{
    NSString* userId = user.userId;
    NSString* appId = [AppManager getPlaceAppId];
    NSString* deviceToken = @"";    
    
    NSString* loginId = [userInfo objectForKey:SNS_USER_ID];
    int loginIdType = [self getSNSType:userInfo];
    
    [viewController showActivityWithText:NSLS(@"kRegisteringUser")];    
    dispatch_async(workingQueue, ^{
        
        BindUserOutput* output = [BindUserRequest send:SERVER_URL 
                                                userId:userId
                                               loginId:loginId
                                           loginIdType:loginIdType
                                           deviceToken:deviceToken
                                              nickName:[userInfo objectForKey:SNS_NICK_NAME]
                                                avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                           accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                                     accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]
                                                 appId:appId
                                              province:[[userInfo objectForKey:SNS_PROVINCE] intValue]
                                                  city:[[userInfo objectForKey:SNS_CITY] intValue]
                                              location:[userInfo objectForKey:SNS_LOCATION]
                                                gender:[userInfo objectForKey:SNS_GENDER]
                                              birthday:[userInfo objectForKey:SNS_BIRTHDAY]                                      
                                                domain:[userInfo objectForKey:SNS_DOMAIN]];        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                [UserManager setUserWithUserId:userId
                                       loginId:loginId
                                   loginIdType:loginIdType
                                      nickName:[userInfo objectForKey:SNS_NICK_NAME]
                                        avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                   accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                             accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]
                                   loginStatus:YES];
                [self updateUserCache];                 // MUST call this!!!
            }
            
            [delegate loginUserResult:output.resultCode];
        });
    });

}

- (void)registerUserWithSNSUserInfo:(NSDictionary*)userInfo viewController:(PPViewController*)viewController
{
    NSString* appId = [AppManager getPlaceAppId];
    NSString* deviceToken = @"";    
    
    NSString* loginId = [userInfo objectForKey:SNS_USER_ID];
    int loginIdType = [self getSNSType:userInfo];
    
    [viewController showActivityWithText:NSLS(@"kRegisteringUser")];    
    dispatch_async(workingQueue, ^{
        RegisterUserOutput* output = [RegisterUserRequest send:SERVER_URL 
                                                       loginId:loginId
                                                   loginIdType:loginIdType
                                                   deviceToken:deviceToken
                                                      nickName:[userInfo objectForKey:SNS_NICK_NAME]
                                                        avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                                   accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                                             accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]
                                                         appId:appId
                                                      province:[[userInfo objectForKey:SNS_PROVINCE] intValue]
                                                          city:[[userInfo objectForKey:SNS_CITY] intValue]
                                                      location:[userInfo objectForKey:SNS_LOCATION]
                                                        gender:[userInfo objectForKey:SNS_GENDER]
                                                      birthday:[userInfo objectForKey:SNS_BIRTHDAY]                                      
                                                        domain:[userInfo objectForKey:SNS_DOMAIN]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                [UserManager setUserWithUserId:output.userId
                                       loginId:loginId
                                   loginIdType:loginIdType
                                      nickName:[userInfo objectForKey:SNS_NICK_NAME]
                                        avatar:[userInfo objectForKey:SNS_USER_IMAGE_URL]
                                   accessToken:[userInfo objectForKey:SNS_OAUTH_TOKEN]
                             accessTokenSecret:[userInfo objectForKey:SNS_OAUTH_TOKEN_SECRET]
                                   loginStatus:YES];
                [self updateUserCache];                 // MUST call this!!!
            }
            
            [delegate loginUserResult:output.resultCode];
        });
    });
    
}


- (void)loginUserWithLoginId:(NSString*)loginId viewController:(PPViewController*)viewController
{
    int result = LOGIN_RESULT_UNKNOWN;
    
    switch (userCurrentStatus) {
        case USER_STATUS_UNKNOWN:
        case USER_NOT_EXIST_LOCAL:
            [self registerUserWithLoginId:loginId viewController:viewController];
            break;

        case USER_EXIST_LOCAL_STATUS_LOGIN:            
            // it's strange here, we just treat this as login locally again
            result = [self setLocalStatusLogin:loginId];
            break;
            
        case USER_EXIST_LOCAL_STATUS_LOGOUT:
            // compare local info and change local status
            result = [self setLocalStatusLogin:loginId];
            break;
            
        default:
            break;
    }
    
    if (result != LOGIN_RESULT_UNKNOWN){
        [delegate loginUserResult:result];
    }        
}

- (void)loginUserWithSNSUserInfo:(NSDictionary*)userInfo viewController:(PPViewController*)viewController
{
    switch (userCurrentStatus) {
        case USER_STATUS_UNKNOWN:
        case USER_NOT_EXIST_LOCAL:
            [self registerUserWithSNSUserInfo:userInfo viewController:viewController];
            break;
            
        case USER_EXIST_LOCAL_STATUS_LOGIN:            
            // it's strange here, we just treat this as login locally again
            [self bindUserWithSNSUserInfo:userInfo viewController:viewController];
            break;
            
        case USER_EXIST_LOCAL_STATUS_LOGOUT:
            [self bindUserWithSNSUserInfo:userInfo viewController:viewController];            
            break;
            
        default:
            break;
    }
    
}

@end
