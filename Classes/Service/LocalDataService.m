//
//  LocalDataService.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocalDataService.h"
#import "GetUserPlaceRequest.h"
#import "PlaceManager.h"
#import "PostManager.h"
#import "GetPlacePostRequest.h"

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

- (void)requestPlaceData
{
    NSString* userId = @"test_user_id";
    NSString* appId = @"test_app_id";
    
    dispatch_async(workingQueue, ^{

        // fetch user place data from server
        GetUserPlaceOutput* output = [GetUserPlaceRequest send:SERVER_URL userId:userId appId:appId];
        
        // For test
        output.resultCode = ERROR_SUCCESS;
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // delete all old data
                [PlaceManager deletePlaceByFollowUser:userId];
                
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
                    
                    [PlaceManager createPlace:placeId name:name desc:desc longitude:lonitude latitude:latitude createUser:createUserId followUserId:followUserId];
                }
                
                // notify UI to refresh data
                if (delegate != nil && [delegate respondsToSelector:@selector(followPlaceDataRefresh)]){
                    [delegate followPlaceDataRefresh];
                }
             });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestPlaceData> failure, result code=%d", output.resultCode);
        }
        
    });
}

- (void)requestLatestPlacePostData:(id<LocalDataServiceDelegate>)delegateObject placeId:(NSString*)placeId
{
    NSString* userId = @"test_user_id";
    NSString* appId = @"test_app_id";
    
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
                    
                    NSString* placeId = placeId;
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
                                  totalView:totalView totalForward:totalForward totalQuote:totalQuote totalReply:totalReply];
                }
                
                // notify UI to refresh data
                if (delegateObject != nil && [delegateObject respondsToSelector:@selector(placePostDataRefresh)]){
                    [delegate placePostDataRefresh];
                }
            });
        }
        else {
            // otherwize do nothing        
            NSLog(@"<requestPlaceData> failure, result code=%d", output.resultCode);
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
