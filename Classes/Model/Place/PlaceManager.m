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

+ (BOOL)isPlaceFollowByUser:(NSString*)placeId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getPlaceUseForFollow"
                                        forKey:@"placeId" 
                                         value:placeId 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    if (placeArray != nil && [placeArray count] > 0)
        return YES;
    else    
        return NO;
}

+ (BOOL)userFollowPlace:(NSString*)userId place:(Place*)place
{
    if (place == nil)
        return YES;
    
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getPlaceUseForFollow"
                                        forKey:@"placeId" 
                                         value:place.placeId 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    if (placeArray != nil && [placeArray count] > 0)
        return YES;
    
    // not exist, copy place to follow list
    [PlaceManager createPlace:place.placeId
                         name:place.name 
                         desc:place.desc 
                    longitude:[place.longitude doubleValue]
                     latitude:[place.latitude doubleValue]
                   createUser:userId 
                 followUserId:nil 
                       useFor:PLACE_USE_FOLLOW];    
    
    return YES;    
}

+ (BOOL)userUnfollowPlace:(NSString*)userId placeId:(NSString*)placeId
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    NSArray* placeArray = [dataManager execute:@"getPlaceUseForFollow"
                                        forKey:@"placeId" 
                                         value:placeId 
                                        sortBy:@"placeId" 
                                     ascending:YES];
    
    if (placeArray != nil && [placeArray count] > 0){
        for (Place* place in placeArray){
            place.deleteFlag = [NSNumber numberWithInt:1];
        }
        [dataManager save];
    }
    
    return YES;
}


@end
