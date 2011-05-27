//
//  LocalDataService.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-16.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import "LocalDataService.h"
#import "GetUserPlaceRequest.h"
#import "PlaceManager.h"
#import "PostManager.h"
#import "UserManager.h"
#import "GetPlacePostRequest.h"
#import "GetNearbyPlaceRequest.h"
#import "GetNearbyPostRequest.h"
#import "GetUserFollowPostRequest.h"
#import "GetUserFollowPlaceRequest.h"
#import "TimeUtils.h"
#import "Post.h"
#import "AppManager.h"

@implementation LocalDataService

@synthesize workingQueue;
@synthesize delegate;

- (id)initWithDelegate:(id<LocalDataServiceDelegate>)delegateVal
{
    self = [super init];
    self.delegate = delegateVal;
    self.workingQueue = dispatch_queue_create("local data service queue", NULL);
    
    return self;
}

- (void)requestNearbyPostData:(id<LocalDataServiceDelegate>)delegateObject
              beforeTimeStamp:(NSString*)beforeTimeStamp
                    longitude:(double)longitude 
                     latitude:(double)latitude
                    cleanData:(BOOL)cleanData

{
    if ([UserManager isUserRegistered] == NO)
        return;
    
    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        GetNearbyPostOutput* output = [GetNearbyPostRequest send:SERVER_URL userId:userId appId:appId beforeTimeStamp:beforeTimeStamp longitude:longitude latitude:latitude];
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // delete all old data
                if (cleanData){
                    [PostManager deleteAllNearbyPost];
                }
                
                // insert new data
                NSArray* postArray = output.postArray;
                for (NSDictionary* post in postArray){
                    // save place into DB                                        
                    [PostManager createPost:[output postId:post] 
                                    placeId:[output placeId:post] 
                                     userId:userId 
                                textContent:[output textContent:post]
                                   imageURL:[output imageURL:post]
                                contentType:[output contentType:post]
                                 createDate:[output createDate:post] 
                                  longitude:[output longitude:post] 
                                   latitude:[output latitude:post]
                              userLongitude:[output userLongitude:post]
                               userLatitude:[output userLatitude:post]
                                  totalView:[output totalView:post]
                               totalForward:[output totalForward:post]
                                 totalQuote:[output totalQuote:post]
                                 totalReply:[output totalReply:post]
                                     useFor:POST_FOR_NEARBY];                    
                }
                
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(nearbyPostDataRefresh:)]){
                    [delegateObject nearbyPostDataRefresh:output.resultCode];
                }
            });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestNearbyPostData> failure, result code=%d", output.resultCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(nearbyPostDataRefresh:)]){
                    [delegateObject nearbyPostDataRefresh:output.resultCode];
                }
            });

        }
        
    });
    
}

- (void)requestUserFollowPostData:(id<LocalDataServiceDelegate>)delegateObject
                  beforeTimeStamp:(NSString*)beforeTimeStamp
                        cleanData:(BOOL)cleanData
{
    if ([UserManager isUserRegistered] == NO)
        return;
    
    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        GetUserFollowPostOutput* output = [GetUserFollowPostRequest send:SERVER_URL userId:userId appId:appId beforeTimeStamp:beforeTimeStamp];
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // delete all old data
                if (cleanData){
                    [PostManager deleteUserFollowPost];
                }
                
                // insert new data
                NSArray* postArray = output.postArray;
                for (NSDictionary* post in postArray){
                    // save place into DB                                        
                    [PostManager createPost:[output postId:post] 
                                    placeId:[output placeId:post] 
                                     userId:userId 
                                textContent:[output textContent:post]
                                   imageURL:[output imageURL:post]
                                contentType:[output contentType:post]
                                 createDate:[output createDate:post] 
                                  longitude:[output longitude:post] 
                                   latitude:[output latitude:post]
                              userLongitude:[output userLongitude:post]
                               userLatitude:[output userLatitude:post]
                                  totalView:[output totalView:post]
                               totalForward:[output totalForward:post]
                                 totalQuote:[output totalQuote:post]
                                 totalReply:[output totalReply:post]
                                     useFor:POST_FOR_FOLLOW];                    
                }
                
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(followPostDataRefresh:)]){
                    [delegateObject followPostDataRefresh:output.resultCode];
                }
            });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestUserFollowPostData> failure, result code=%d", 
                  output.resultCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(followPostDataRefresh:)]){
                    [delegateObject followPostDataRefresh:output.resultCode];
                }
            });
            
        }
        
    });

}


- (void)requestNearbyPlaceData:(id<LocalDataServiceDelegate>)delegateObject
{
    if ([UserManager isUserRegistered] == NO)
        return;
    
    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    double longitude = 111.22;
    double latitude = 233.44;
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        GetNearbyPlaceOutput* output = [GetNearbyPlaceRequest send:SERVER_URL userId:userId appId:appId
                                                         longitude:longitude latitude:latitude];
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // delete all old data
                [PlaceManager deleteAllPlacesNearby];
                
                // insert new data
                NSArray* placeArray = output.placeArray;
                for (NSDictionary* place in placeArray){
                    // save place into DB
                    NSString* placeId = [output placeId:place];
                    NSString* name = [output name:place];
                    NSString* desc = [output description:place];
                    double latitude = [output latitude:place];
                    double lonitude = [output longitude:place];
                    NSString* createUserId = [output createUserId:place];
                    NSString* followUserId = nil;
                    
                    [PlaceManager createPlace:placeId name:name desc:desc longitude:lonitude latitude:latitude createUser:createUserId followUserId:followUserId useFor:PLACE_USE_NEARBY];
                }
                
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(nearbyPlaceDataRefresh:)]){
                    [delegateObject nearbyPlaceDataRefresh:output.resultCode];
                }
            });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestNearbyPlaceData> failure, result code=%d", output.resultCode);            
            dispatch_async(dispatch_get_main_queue(), ^{
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(nearbyPlaceDataRefresh:)]){
                    [delegateObject nearbyPlaceDataRefresh:output.resultCode];
                }
            });
        }
        
    });
    
}

- (void)requestPlaceData
{
    if ([UserManager isUserRegistered] == NO)
        return;
    
    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        GetUserPlaceOutput* output = [GetUserPlaceRequest send:SERVER_URL userId:userId appId:appId];
        
        // For test
        output.resultCode = ERROR_SUCCESS;
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // delete all old data
                [PlaceManager deleteAllFollowPlaces];
                
                // insert new data
                NSArray* placeArray = output.placeArray;
                for (NSDictionary* place in placeArray){
                    // save place into DB
                    NSString* placeId = [output placeId:place];
                    NSString* name = [output name:place];
                    NSString* desc = [output description:place];
                    double latitude = [output latitude:place];
                    double lonitude = [output longitude:place];
                    NSString* createUserId = [output createUserId:place];
                    NSString* followUserId = userId;                    
                    
                    [PlaceManager createPlace:placeId name:name desc:desc longitude:lonitude latitude:latitude createUser:createUserId followUserId:followUserId useFor:PLACE_USE_FOLLOW];
                }
                
                // notify UI to refresh data
                if (delegate != nil && [delegate respondsToSelector:@selector(followPlaceDataRefresh:)]){
                    [delegate followPlaceDataRefresh:output.resultCode];
                }
            });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestPlaceData> failure, result code=%d", output.resultCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                // notify UI to refresh data
                if (delegate != nil && [delegate respondsToSelector:@selector(followPlaceDataRefresh:)]){
                    [delegate followPlaceDataRefresh:output.resultCode];
                }
            });

        }
        
    });
}

- (void)requestUserFollowPlaceData:(id<LocalDataServiceDelegate>)delegateObject
{
    if ([UserManager isUserRegistered] == NO)
        return;
    
    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        GetUserFollowPlaceOutput* output = [GetUserFollowPlaceRequest send:SERVER_URL userId:userId appId:appId];
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // delete all old data
                [PlaceManager deleteAllFollowPlaces];
                
                // insert new data
                NSArray* placeArray = output.placeArray;
                for (NSDictionary* place in placeArray){
                    // save place into DB
                    NSString* placeId = [output placeId:place];
                    NSString* name = [output name:place];
                    NSString* desc = [output description:place];
                    double latitude = [output latitude:place];
                    double lonitude = [output longitude:place];
                    NSString* createUserId = [output createUserId:place];
                    NSString* followUserId = userId;                    
                    
                    [PlaceManager createPlace:placeId name:name desc:desc longitude:lonitude latitude:latitude createUser:createUserId followUserId:followUserId useFor:PLACE_USE_FOLLOW];
                }
                
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(followPlaceDataRefresh:)]){
                    [delegateObject followPlaceDataRefresh:output.resultCode];
                }
            });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestUserFollowPlaceData> failure, result code=%d", output.resultCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(followPlaceDataRefresh:)]){
                    [delegateObject followPlaceDataRefresh:output.resultCode];
                }
            });
        }
        
    });    
}

- (void)requestLatestPlacePostData:(id<LocalDataServiceDelegate>)delegateObject placeId:(NSString*)placeId
{
    if ([UserManager isUserRegistered] == NO)
        return;
    
    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        GetPlacePostOutput* output = [GetPlacePostRequest send:SERVER_URL userId:userId appId:appId placeId:placeId afterTimeStamp:@""];
        
        // For test
        output.resultCode = ERROR_SUCCESS;
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // delete all old data
                [PostManager deletePostByPlace:placeId];
                
                // insert new data
                NSArray* postArray = output.postArray;
                for (NSDictionary* post in postArray){
                    // save place into DB
                    
                    NSString* postId = [output postId:post];
                    NSString* userId = [output userId:post];
                    double latitude = [output latitude:post];
                    double longitude = [output longitude:post];
                    double userLatitude = [output userLatitude:post];
                    double userLongitude = [output userLongitude:post];
                    NSString* textContent = [output textContent:post];
                    NSString* imageURL = [output imageURL:post];
                    int contentType = [output contentType:post];
                    NSDate* createDate = [output createDate:post];
                    int totalView = [output totalView:post];
                    int totalForward = [output totalForward:post];
                    int totalQuote = [output totalQuote:post];
                    int totalReply = [output totalReply:post];
                    
                    [PostManager createPost:postId placeId:placeId userId:userId 
                                textContent:textContent imageURL:imageURL 
                                contentType:contentType 
                                 createDate:createDate longitude:longitude latitude:latitude 
                              userLongitude:userLongitude userLatitude:userLatitude
                                  totalView:totalView totalForward:totalForward 
                                 totalQuote:totalQuote totalReply:totalReply
                                     useFor:POST_FOR_PLACE];
                }
                
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(placePostDataRefresh:)]){
                    [delegateObject placePostDataRefresh:output.resultCode];
                }
            });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestPlaceData> failure, result code=%d", output.resultCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(placePostDataRefresh:)]){
                    [delegateObject placePostDataRefresh:output.resultCode];
                }
            });

        }
        
    });
    
}



- (void)requestDataWhileEnterForeground
{
    [self requestPlaceData];
}

- (void)requestDataWhileLaunch
{
    
}

- (void)dealloc
{
    dispatch_release(workingQueue);
    workingQueue = NULL;
    
    [super dealloc];
}

@end
