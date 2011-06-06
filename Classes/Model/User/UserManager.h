//
//  UserManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject {

}

+ (BOOL)isUserRegistered;
+ (BOOL)setUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
              loginIdType:(int)loginIdType
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
              loginStatus:(BOOL)loginStatus;
+ (BOOL)setUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
          sinaAccessToken:(NSString *)sinaAccessToken
    sinaAccessTokenSecret:(NSString *)sinaAccessTokenSecret
            qqAccessToken:(NSString *)qqAccessToken
      qqAccessTokenSecret:(NSString *)qqAccessTokenSecret
              loginStatus:(BOOL)loginStatus;
+ (BOOL)setUser:(User *)user;
+ (User*)getUser;
+ (BOOL)delUser;
+ (NSString*)getUserId;

+ (void)userLoginSuccess:(User*)user;

@end
