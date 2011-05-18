//
//  PlaceManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NEARBY_USER_ID      @"$$NEARBY_USER_ID$$"       // it's just for internal implementation usage


@interface PlaceManager : NSObject {
    
}

+ (BOOL)createPlace:(NSString*)placeId name:(NSString*)name desc:(NSString*)desc
          longitude:(double)longitude latitude:(double)latitude 
         createUser:(NSString*)createUser followUserId:(NSString*)followUserId;

+ (NSArray*)getAllPlacesByFollowUser:(NSString*)followUserId;

+ (BOOL)deletePlaceByFollowUser:(NSString*)followUserId;
+ (BOOL)deleteNearbyPlaces;

+ (NSArray*)getAllPlacesNearby;

@end
