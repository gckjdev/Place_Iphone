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
    place.deleteFlag = [NSNumber numberWithBool:NO];
    
    NSLog(@"Create Place: %@", [place description]);
    
    return [dataManager save];
}

+ (NSArray*)getAllFollowPlaces
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllFollowPlaces" 
                         sortBy:@"name" 
                      ascending:YES];
}

+ (BOOL)deleteAllFollowPlaces
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [PlaceManager getAllFollowPlaces];
    
    for (Place* place in placeArray){
        place.deleteFlag = [NSNumber numberWithBool:YES];
    }
    
    return [dataManager save];
}

+ (BOOL)deleteAllPlacesNearby
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [PlaceManager getAllPlacesNearby];
    
    for (Place* place in placeArray){
        place.deleteFlag = [NSNumber numberWithBool:YES];
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
