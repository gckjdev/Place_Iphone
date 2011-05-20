//
//  GetPlacePost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetPlacePostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       placeId;
    NSString*       afterTimeStamp;
    int             maxCount;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     placeId;
@property (nonatomic, retain) NSString*     afterTimeStamp;
@property (nonatomic, assign) int           maxCount;

@end

@interface GetPlacePostOutput : CommonOutput
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

@end

@interface GetPlacePostRequest : NetworkRequest {
	
}

+ (GetPlacePostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId placeId:(NSString*)placeId afterTimeStamp:(NSString*)afterTimeStamp;

+ (void)test;

@end
