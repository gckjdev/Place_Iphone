//
//  GetNearbyPost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetNearbyPostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       beforeTimeStamp;
    int             maxCount;
    double          longitude;
    double          latitude;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     beforeTimeStamp;
@property (nonatomic, assign) int           maxCount;
@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) double        latitude;

@end

@interface GetNearbyPostOutput : CommonOutput
{
    NSArray*        postArray;
}

@property (nonatomic, retain) NSArray* postArray;

- (NSString*)postId:(NSDictionary*)post;
- (NSString*)userId:(NSDictionary*)post;
- (double)longitude:(NSDictionary*)post;
- (double)latitude:(NSDictionary*)post;
- (double)userLongitude:(NSDictionary*)post;
- (double)userLatitude:(NSDictionary*)post;
- (NSString*)textContent:(NSDictionary*)post;
- (NSString*)imageURL:(NSDictionary*)post;
- (int)contentType:(NSDictionary*)post;
- (NSDate*)createDate:(NSDictionary*)post;
- (int)totalView:(NSDictionary*)post;
- (int)totalForward:(NSDictionary*)post;
- (int)totalQuote:(NSDictionary*)post;
- (int)totalReply:(NSDictionary*)post;
- (NSString*)placeId:(NSDictionary*)post;

@end

@interface GetNearbyPostRequest : NetworkRequest {
	
}

+ (GetNearbyPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId beforeTimeStamp:(NSString*)beforeTimeStamp longitude:(double)longitude latitude:(double)latitude;

+ (void)test;

@end
