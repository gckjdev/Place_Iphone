//
//  PostManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostManager.h"
#import "CoreDataUtil.h"
#import "Post.h"

@implementation PostManager

+ (NSArray*)getPostByPlace:(NSString*)placeId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getPostByPlace" forKey:@"placeId" value:placeId sortBy:@"createDate" ascending:YES];
}

+ (BOOL)deletePostByPlace:(NSString*)placeId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    NSArray* postArray = [dataManager execute:@"getPostByPlace" forKey:@"placeId" value:placeId sortBy:@"createDate" ascending:YES];
    
    for (Post* post in postArray){
        [dataManager del:post];
    }
    
    return [dataManager save];
}

+ (BOOL)createPost:(NSString*)postId placeId:(NSString*)placeId userId:(NSString*)userId
       textContent:(NSString*)textContent imageURL:(NSString*)imageURL 
       contentType:(int)contentType createDate:(NSDate*)createDate
          longitude:(double)longitude latitude:(double)latitude
      userLongitude:(double)userLongitude userLatitude:(double)userLatitude
         totalView:(int)totalView totalForward:(int)totalForward
        totalQuote:(int)totalQuote totalReply:(int)totalReply
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    Post* post = [dataManager insert:@"Post"];
    post.postId = postId;
    post.placeId = placeId;
    post.userId = userId;
    post.textContent = textContent;
    post.imageURL = imageURL;
    post.contentType = [NSNumber numberWithInt:contentType];
    post.createDate = createDate;
    post.longitude = [NSNumber numberWithDouble:longitude];
    post.latitude = [NSNumber numberWithDouble:latitude];
    post.userLongitude = [NSNumber numberWithDouble:userLongitude];
    post.userLatitude = [NSNumber numberWithDouble:userLatitude];
    post.totalView = [NSNumber numberWithInt:totalView];
    post.totalForward = [NSNumber numberWithInt:totalForward];
    post.totalQuote = [NSNumber numberWithInt:totalQuote];
    post.totalReply = [NSNumber numberWithInt:totalReply];
    
    NSLog(@"<createPost> post=%@", [post description]);
    
    return [dataManager save];
}

+ (NSArray*)getAllFollowPost:(NSString*)userId
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return [dataManager execute:@"getFollowPostByUser" 
                         sortBy:@"createDate" 
                      ascending:YES];
    
}

@end
