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

@property (nonatomic, retain) NSString *loginId;
@property (nonatomic, retain) NSString *queryId;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSNumber *loginIdType;


@end



