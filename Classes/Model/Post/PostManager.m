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

@end
