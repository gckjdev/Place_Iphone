//
//  GetUserFollowPlace.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetUserFollowPlaceInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;

@end

@interface GetUserFollowPlaceOutput : CommonOutput
{
    NSArray*        placeArray;
}

@property (nonatomic, retain) NSArray* placeArray;

- (NSString*)name:(NSDictionary*)place;
- (NSString*)description:(NSDictionary*)place;
- (double)longitude:(NSDictionary*)place;
- (double)latitude:(NSDictionary*)place;
- (NSString*)createUserId:(NSDictionary*)place;
- (NSString*)placeId:(NSDictionary*)place;

@end

@interface GetUserFollowPlaceRequest : NetworkRequest {
	
}

+ (GetUserFollowPlaceOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId;

+ (void)test;

@end
