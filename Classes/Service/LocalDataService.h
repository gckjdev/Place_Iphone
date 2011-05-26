//
//  LocalDataService.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-16.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalDataServiceDelegate <NSObject>

@optional

- (void)followPlaceDataRefresh:(int)result;
- (void)placePostDataRefresh:(int)result;
- (void)nearbyPlaceDataRefresh:(int)result;
- (void)followPostDataRefresh:(int)result;
- (void)nearbyPostDataRefresh:(int)result;

@end

@interface LocalDataService : NSObject {
    
    dispatch_queue_t                workingQueue;
    id<LocalDataServiceDelegate>    delegate;
}

@property (nonatomic, assign) dispatch_queue_t workingQueue;
@property (nonatomic, assign) id<LocalDataServiceDelegate>    delegate;

- (id)initWithDelegate:(id<LocalDataServiceDelegate>)delegate;
- (void)requestPlaceData;
- (void)requestNearbyPlaceData:(id<LocalDataServiceDelegate>)delegate;
- (void)requestUserFollowPlaceData:(id<LocalDataServiceDelegate>)delegate;

- (void)requestLatestPlacePostData:(id<LocalDataServiceDelegate>)delegateObject 
                           placeId:(NSString*)placeId;

- (void)requestNearbyPostData:(id<LocalDataServiceDelegate>)delegateObject
              beforeTimeStamp:(NSString*)beforeTimeStamp
                    longitude:(double)longitude 
                     latitude:(double)latitude
                    cleanData:(BOOL)cleanData;

- (void)requestUserFollowPostData:(id<LocalDataServiceDelegate>)delegateObject
              beforeTimeStamp:(NSString*)beforeTimeStamp
                    cleanData:(BOOL)cleanData;


- (void)requestDataWhileEnterForeground;
- (void)requestDataWhileLaunch;

@end
