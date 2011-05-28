//
//  GetPostRelatedPost.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface GetPostRelatedPostInput : NSObject
{
	NSString*		userId;
    NSString*       appId;
    NSString*       postId;
    NSString*       beforeTimeStamp;
    int             maxCount;
}

@property (nonatomic, retain) NSString*		userId;
@property (nonatomic, retain) NSString*     appId;
@property (nonatomic, retain) NSString*     postId;
@property (nonatomic, retain) NSString*     beforeTimeStamp;
@property (nonatomic, assign) int           maxCount;

@end

@interface GetPostRelatedPostOutput : CommonOutput
{
    NSArray*        postArray;
}

@property (nonatomic, retain) NSArray* postArray;

+ (NSString*)postId:(NSDictionary*)post;
+ (NSString*)userId:(NSDictionary*)post;
+ (double)longitude:(NSDictionary*)post;
+ (double)latitude:(NSDictionary*)post;
+ (double)userLongitude:(NSDictionary*)post;
+ (double)userLatitude:(NSDictionary*)post;
+ (NSString*)textContent:(NSDictionary*)post;
+ (NSString*)imageURL:(NSDictionary*)post;
+ (int)contentType:(NSDictionary*)post;
+ (NSDate*)createDate:(NSDictionary*)post;
+ (int)totalView:(NSDictionary*)post;
+ (int)totalForward:(NSDictionary*)post;
+ (int)totalQuote:(NSDictionary*)post;
+ (int)totalReply:(NSDictionary*)post;
+ (NSString*)placeId:(NSDictionary*)post;

@end 

@interface GetPostRelatedPostRequest : NetworkRequest {
	
}

+ (GetPostRelatedPostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId postId:(NSString*)postId beforeTimeStamp:(NSString*)beforeTimeStamp;

+ (void)test;

@end
