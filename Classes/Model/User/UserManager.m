//
//  UserManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "UserManager.h"
#import "CoreDataUtil.h"
#import "VariableConstants.h"

#define DEFAULT_USER_QUERY_ID	@"DEFAULT_USER_QUERY_ID"

UserManager* userManager;

@implementation UserManager

+ (BOOL)isUserRegistered
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	NSObject* user = [dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];	
	return ( user != nil );
}

+ (BOOL)setUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
              loginIdType:(int)loginIdType
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
              loginStatus:(BOOL)loginStatus
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == user) {
        user = [dataManager insert:@"User"];
    }
    user.userId = userId;
    user.loginIdType = [NSNumber numberWithInt:loginIdType];
    user.queryId = DEFAULT_USER_QUERY_ID;
    user.nickName = nickName;
    user.avatar = avatar;
    if (LOGINID_OWN == loginIdType) {
        user.loginId = loginId;
    } else if (LOGINID_SINA == loginIdType) {
        user.sinaAccessToken = accessToken;
        user.sinaAccessTokenSecret = accessTokenSecret;
    } else if (LOGINID_QQ == loginIdType) {
        user.qqAccessToken = accessToken;
        user.qqAccessTokenSecret = accessTokenSecret;
    }
    user.loginStatus = [NSNumber numberWithBool:loginStatus];    
    
    NSLog(@"<setUser> user=%@", [user description]);
    
	return [dataManager save];
}

+ (BOOL)setUserWithUserId:(NSString *)userId
                  loginId:(NSString *)loginId
                 nickName:(NSString *)nickName
                   avatar:(NSString *)avatar
          sinaAccessToken:(NSString *)sinaAccessToken
    sinaAccessTokenSecret:(NSString *)sinaAccessTokenSecret
            qqAccessToken:(NSString *)qqAccessToken
      qqAccessTokenSecret:(NSString *)qqAccessTokenSecret
              loginStatus:(BOOL)loginStatus
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == user) {
        user = [dataManager insert:@"User"];
    }
    user.queryId = DEFAULT_USER_QUERY_ID;
    user.userId = userId;
    user.loginId = loginId;
    user.nickName = nickName;
    user.sinaAccessToken = sinaAccessToken;
    user.sinaAccessTokenSecret = sinaAccessTokenSecret;
    user.qqAccessToken = qqAccessToken;
    user.qqAccessTokenSecret = qqAccessTokenSecret;
    user.loginStatus = [NSNumber numberWithBool:loginStatus];
    user.avatar = avatar;
    
    NSLog(@"<setUser> user=%@", [user description]);
    
	return [dataManager save];
}

+ (BOOL)setUser:(User *)user
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* u = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == u) {
        u = [dataManager insert:@"User"];
    }
    u.userId = user.userId;
    u.loginId = user.loginId;
    u.loginIdType = user.loginIdType;
    u.queryId = user.queryId;
    u.nickName = user.nickName;
    u.avatar = user.avatar;
    u.sinaAccessToken = user.sinaAccessToken;
    u.sinaAccessTokenSecret = user.sinaAccessTokenSecret;
    u.qqAccessToken = user.qqAccessToken;
    u.qqAccessTokenSecret = user.qqAccessTokenSecret;
    u.loginStatus = user.loginStatus;
    
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
