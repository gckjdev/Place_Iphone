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
+ (BOOL)setUser:(NSString*)loginId loginIdType:(int)loginIdType userId:(NSString*)userId;
+ (User*)getUser;
+ (BOOL)delUser;
+ (NSString*)getUserId;

@end
