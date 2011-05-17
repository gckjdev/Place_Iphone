//
//  PostManager.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PostManager : NSObject {
    
}

@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * textContent;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * contentType;
@property (nonatomic, retain) NSDate   * createDate;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * totalView;
@property (nonatomic, retain) NSNumber * totalForward;
@property (nonatomic, retain) NSNumber * totalQuote;
@property (nonatomic, retain) NSNumber * totalReply;


+ (NSArray*)getPostByPlace:(NSString*)placeId;
+ (BOOL)deletePostByPlace:(NSString*)placeId;
+ (BOOL)createPost:(NSString*)postId placeId:(NSString*)placeId userId:(NSString*)userId
       textContent:(NSString*)textContent imageURL:(NSString*)imageURL 
       contentType:(int)contentType createDate:(NSDate*)createDate
          longitude:(double)longitude latitude:(double)latitude
          userLongitude:(double)userLongitude userLatitude:(double)userLatitude
         totalView:(int)totalView totalForward:(int)totalForward
        totalQuote:(int)totalQuote totalReply:(int)totalReply;

@end
