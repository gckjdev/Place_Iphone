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

+ (BOOL)setUser:(NSString*)loginId loginIdType:(int)loginIdType userId:(NSString*)userId
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
    if (nil == user) {
        user = [dataManager insert:@"User"];
    }
	user.loginId = loginId;
	user.queryId = DEFAULT_USER_QUERY_ID;
    user.userId = userId;
    user.loginIdType = [NSNumber numberWithInt:loginIdType];
    
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
