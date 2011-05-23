//
//  UserManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "UserManager.h"
#import "CoreDataUtil.h"

#define DEFAULT_USER_QUERY_ID	@"DEFAULT_USER_QUERY_ID"

UserManager* userManager;

@implementation UserManager

+ (BOOL)isUserRegistered
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	NSObject* user = [dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];	
	return ( user != nil );
}

+ (BOOL)setUserWithUserId:(NSString*)userId
                  loginId:(NSString*)loginId
              loginIdType:(int)loginIdType
                 nickname:(NSString *)nickname
                   avatar:(NSData *)avatar
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == user) {
        user = [dataManager insert:@"User"];
    }
    user.userId = userId;
	user.loginId = loginId;
    user.loginIdType = [NSNumber numberWithInt:loginIdType];
    user.queryId = DEFAULT_USER_QUERY_ID;
    user.nickname = nickname;
    user.avatar = avatar;
    user.accessToken = accessToken;
    user.accessTokenSecret = accessTokenSecret;
    
    NSLog(@"<setUser> user=%@", [user description]);
    
	return [dataManager save];
}

+ (User*)getUser
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
	return user;
}

+ (BOOL)delUser
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil != user) {
        [dataManager del:user];
    }
    return [dataManager save]; 
}

+ (NSString*)getUserId
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
	return user.userId;    
}

@end
