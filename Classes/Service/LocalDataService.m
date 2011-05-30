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
#import "ResultUtils.h"

@implementation LocalDataService

@synthesize workingQueue;
@synthesize defaultDelegate;

- (id)initWithDelegate:(id<LocalDataServiceDelegate>)delegateVal
{
    self = [super init];
    self.defaultDelegate = delegateVal;
    self.workingQueue = dispatch_queue_create("local data service queue", NULL);
    
    return self;
}

- (void)notifyDelegate:(id)delegate selector:(SEL)selector resultCode:(int)resultCode
{
    if (delegate != nil && [delegate respondsToSelector:selector]){
        
        NSMethodSignature *sig = [delegate methodSignatureForSelector:selector];
        if (sig){
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
            [inv setSelector:selector];
            [inv setTarget:delegate];
            [inv setArgument:&resultCode atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
            [inv invoke];        
        }
    }
}

- (void)createPost:(NSDictionary*)post userId:(NSString*)userId useFor:(int)useFor
{
    [PostManager createPost:[ResultUtils postId:post] 
                    placeId:[ResultUtils placeId:post] 
                     userId:userId 
                textContent:[ResultUtils textContent:post]
                   imageURL:[ResultUtils imageURL:post]
                contentType:[ResultUtils contentType:post]
                 createDate:[ResultUtils createDate:post] 
                  longitude:[ResultUtils longitude:post] 
                   latitude:[ResultUtils latitude:post]
              userLongitude:[ResultUtils userLongitude:post]
               userLatitude:[ResultUtils userLatitude:post]
                  totalView:[ResultUtils totalView:post]
               totalForward:[ResultUtils totalForward:post]
                 totalQuote:[ResultUtils totalQuote:post]
                 totalReply:[ResultUtils totalReply:post]
               userNickName:[ResultUtils nickName:post]
                  srcPostId:[ResultUtils srcPostId:post]
                 userAvatar:[ResultUtils userAvatar:post]
                     useFor:useFor];                    
    
}

- (void)createPlace:(NSDictionary*)place userId:(NSString*)userId useFor:(int)useFor
{
    NSString* placeId = [ResultUtils placeId:place];
    NSString* name = [ResultUtils name:place];
    NSString* desc = [ResultUtils description:place];
    double latitude = [ResultUtils latitude:place];
    double lonitude = [ResultUtils longitude:place];
    NSString* createUserId = [ResultUtils createUserId:place];
    NSString* followUserId = nil;
    
    [PlaceManager createPlace:placeId name:name desc:desc 
                    longitude:lonitude latitude:latitude 
                   createUser:createUserId followUserId:followUserId 
                       useFor:useFor];

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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){
                    
                // delete all old data
                if (cleanData){
                    [PostManager deleteAllNearbyPost];
                }
                
                // insert new data
                NSArray* postArray = output.postArray;
                for (NSDictionary* post in postArray){
                    [self createPost:post userId:userId useFor:POST_FOR_NEARBY];
                }
            }
                
            // notify UI to refresh data
            NSLog(@"<requestNearbyPostData> result code=%d", output.resultCode);
            [self notifyDelegate:delegateObject selector:@selector(nearbyPostDataRefresh:) resultCode:output.resultCode];
        });
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){                    
                // delete all old data
                if (cleanData){
                    [PostManager deleteUserFollowPost];
                }
                
                // insert new data
                NSArray* postArray = output.postArray;
                for (NSDictionary* post in postArray){
                    [self createPost:post userId:userId useFor:POST_FOR_FOLLOW];
                }                    
            }

            // notify UI to refresh data
            NSLog(@"<requestUserFollowPostData> result code=%d", 
                  output.resultCode);
            [self notifyDelegate:delegateObject selector:@selector(followPostDataRefresh:) resultCode:output.resultCode];
        });
            
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){
                
                // delete all old data
                [PlaceManager deleteAllPlacesNearby];
                
                // insert new data
                NSArray* placeArray = output.placeArray;
                for (NSDictionary* place in placeArray){
                    // save place into DB
                    [self createPlace:place userId:userId useFor:PLACE_USE_NEARBY];
                }
            }
            
            // notify UI to refresh data
            NSLog(@"<requestNearbyPlaceData> result code=%d", output.resultCode);            
            [self notifyDelegate:delegateObject selector:@selector(nearbyPlaceDataRefresh:) resultCode:output.resultCode];            
        });
        
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
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){
                    
                    // delete all old data
                    [PlaceManager deleteAllFollowPlaces];
                    
                    // insert new data
                    NSArray* placeArray = output.placeArray;
                    for (NSDictionary* place in placeArray){
                        [self createPlace:place userId:userId useFor:PLACE_USE_FOLLOW];
                    }
            }
                    
            [self notifyDelegate:defaultDelegate selector:@selector(followPlaceDataRefresh:) resultCode:output.resultCode];
        });
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){
                    
                    // delete all old data
                    [PlaceManager deleteAllFollowPlaces];
                    
                    // insert new data
                    NSArray* placeArray = output.placeArray;
                    for (NSDictionary* place in placeArray){
                        // save place into DB
                        [self createPlace:place userId:userId useFor:PLACE_USE_FOLLOW];
                    }
            }

            // notify UI to refresh data
            NSLog(@"<requestUserFollowPlaceData>, result code=%d", output.resultCode);
            [self notifyDelegate:delegateObject selector:@selector(followPlaceDataRefresh:) resultCode:output.resultCode];            
        });
        
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
        GetPlacePostOutput* output = [GetPlacePostRequest send:SERVER_URL userId:userId appId:appId placeId:placeId beforeTimeStamp:@""];
        
        // For test
        output.resultCode = ERROR_SUCCESS;
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){
                
                // delete all old data
                [PostManager deletePostByPlace:placeId];
                
                // insert new data
                NSArray* postArray = output.postArray;
                for (NSDictionary* post in postArray){
                    [self createPost:post userId:userId useFor:POST_FOR_PLACE];
                }
                
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(placePostDataRefresh:)]){
                    [delegateObject placePostDataRefresh:output.resultCode];
                }
            }

            // notify UI to refresh data
            NSLog(@"<requestPlaceData> result code=%d", output.resultCode);
            [self notifyDelegate:delegateObject selector:@selector(placePostDataRefresh:) resultCode:output.resultCode];            
        });        
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
