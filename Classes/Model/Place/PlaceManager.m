//
//  PlaceManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import "PlaceManager.h"
#import "Place.h"
#import "CoreDataUtil.h"


@implementation PlaceManager

+ (BOOL)createPlace:(NSString*)placeId name:(NSString*)name desc:(NSString*)desc
          longitude:(double)longitude latitude:(double)latitude 
         createUser:(NSString*)createUser  followUserId:(NSString*)followUserId
             useFor:(int)useFor
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
    place.useFor = [NSNumber numberWithInt:useFor];
    
    NSLog(@"Create Place: %@", [place description]);
    
    return [dataManager save];
}

+ (NSArray*)getAllFollowPlaces:(NSString*)followUserId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllFollowPlaces" 
                         sortBy:@"name" 
                      ascending:YES];
}

+ (BOOL)deleteAllFollowPlaces:(NSString*)followUserId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [PlaceManager getAllFollowPlaces:followUserId];
    
    for (Place* place in placeArray){
        [dataManager del:place];
    }
    
    return [dataManager save];
}

+ (BOOL)deleteAllPlacesNearby
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [PlaceManager getAllPlacesNearby];
    
    for (Place* place in placeArray){
        [dataManager del:place];
    }
    
    return [dataManager save];
}

+ (NSArray*)getAllPlacesNearby
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getAllPlacesNearby" 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    return placeArray;
}


@end
