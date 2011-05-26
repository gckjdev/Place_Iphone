//
//  PlaceManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"

@interface PlaceManager : NSObject {
    
}

+ (BOOL)createPlace:(NSString*)placeId name:(NSString*)name desc:(NSString*)desc
          longitude:(double)longitude latitude:(double)latitude 
         createUser:(NSString*)createUser followUserId:(NSString*)followUserId
             useFor:(int)useFor;

+ (NSArray*)getAllFollowPlaces;
+ (BOOL)deleteAllFollowPlaces;

+ (BOOL)deleteAllPlacesNearby;
+ (NSArray*)getAllPlacesNearby;

@end
