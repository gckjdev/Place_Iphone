//
//  User.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface User :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *loginId;
@property (nonatomic, retain) NSNumber *loginIdType;
@property (nonatomic, retain) NSString *queryId;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *sinaAccessToken;
@property (nonatomic, retain) NSString *sinaAccessTokenSecret;
@property (nonatomic, retain) NSString *qqAccessToken;
@property (nonatomic, retain) NSString *qqAccessTokenSecret;
@property (nonatomic, assign) NSNumber *loginStatus;

@end



