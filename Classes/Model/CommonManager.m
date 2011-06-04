//
//  CommonManager.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonManager.h"
#import "PlaceManager.h"
#import "PostManager.h"

@implementation CommonManager

+ (void)cleanUpDeleteData
{
    int timeStamp = time(0) - 3600; // before 1 hour
    [PlaceManager cleanUpDeleteDataBefore:timeStamp];
    [PostManager cleanUpDeleteDataBefore:timeStamp];
}

@end
