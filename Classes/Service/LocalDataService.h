//
//  LocalDataService.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalDataServiceDelegate <NSObject>

@optional

- (void)followPlaceDataRefresh;
- (void)placePostDataRefresh;

@end

@interface LocalDataService : NSObject {

    dispatch_queue_t                workingQueue;
    id<LocalDataServiceDelegate>    delegate;
}

@property (nonatomic, assign) dispatch_queue_t workingQueue;
@property (nonatomic, assign) id<LocalDataServiceDelegate>    delegate;

- (id)initWithDelegate:(id<LocalDataServiceDelegate>)delegate;
- (void)requestPlaceData;
- (void)requestLatestPlacePostData:(id<LocalDataServiceDelegate>)delegateObject 
                     placeId:(NSString*)placeId;
- (void)requestDataWhileEnterForeground;
- (void)requestDataWhileLaunch;

@end
