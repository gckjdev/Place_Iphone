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
+ (BOOL)setUserWithUserId:(NSString*)userId
                  loginId:(NSString*)loginId
              loginIdType:(int)loginIdType
                 nickName:(NSString *)nickName
                   avatar:(NSData *)avatar
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret;
+ (User*)getUser;
+ (BOOL)delUser;
+ (NSString*)getUserId;

@end
