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

+ (BOOL)setUser:(NSString*)loginId
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = [dataManager insert:@"User"];
	user.loginId = loginId;
	user.queryId = DEFAULT_USER_QUERY_ID;
	return [dataManager save];
}

+ (User*)getUser
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	User* user = (User*)[dataManager execute:@"getUser" forKey:@"queryId" value:DEFAULT_USER_QUERY_ID];
	return user;
}

@end
