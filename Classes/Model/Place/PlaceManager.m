//
//  PlaceManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlaceManager.h"
#import "Place.h"
#import "CoreDataUtil.h"

@implementation PlaceManager

+ (BOOL)createPlace:(NSString*)placeId name:(NSString*)name desc:(NSString*)desc
          longitude:(double)longitude latitude:(double)latitude 
         createUser:(NSString*)createUser  followUserId:(NSString*)followUserId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    
    Place *place = [dataManager insert:@"Place"];
    place.placeId = placeId;
    place.name = name;
    place.desc = desc;
    place.longitude = [NSNumber numberWithDouble:longitude];
    place.latitude = [NSNumber numberWithDouble:latitude];
    place.createUser = createUser;
    place.followUser = followUserId;
    
    NSLog(@"Create Place: %@", [place description]);
    
    return [dataManager save];
}

+ (NSArray*)getAllPlacesByFollowUser:(NSString*)followUserId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllPlacesByFollowUser" forKey:@"followUserId" value:followUserId sortBy:@"name" ascending:YES];
}

+ (BOOL)deletePlaceByFollowUser:(NSString*)followUserId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getAllPlacesByFollowUser" forKey:@"followUserId" value:followUserId sortBy:@"placeId" ascending:YES];
    
    for (Place* place in placeArray){
        [dataManager del:place];
    }
    
    return [dataManager save];
}

@end
