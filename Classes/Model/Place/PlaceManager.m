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
          longitude:(double)longitude latitude:(double)latitude createUser:(NSString*)createUser
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    
    Place *place = [dataManager insert:@"Place"];
    place.placeId = placeId;
    place.name = name;
    place.desc = desc;
    place.longitude = [NSNumber numberWithDouble:longitude];
    place.latitude = [NSNumber numberWithDouble:latitude];
    place.createUser = createUser;
    
    NSLog(@"Create Place: %@", [place description]);
    
    return [dataManager save];
}

+ (NSArray*)getAllPlaces
{
    CoreDataManager *dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getAllPlaces"];
}

@end
