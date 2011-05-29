//
//  ResultUtils.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ResultUtils.h"
#import "NetworkRequestParameter.h"
#import "TimeUtils.h"

@implementation ResultUtils

+ (NSString*)postId:(NSDictionary*)post
{
    return [post objectForKey:PARA_POSTID];
}

+ (NSString*)placeId:(NSDictionary*)post
{
    return [post objectForKey:PARA_PLACEID];
}

+ (NSString*)userId:(NSDictionary*)post
{
    return [post objectForKey:PARA_USERID];    
}

+ (double)longitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_LONGTITUDE] doubleValue];        
}

+ (double)latitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_LATITUDE] doubleValue];            
}

+ (double)userLongitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_USER_LONGITUDE] doubleValue];            
}

+ (double)userLatitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_USER_LATITUDE] doubleValue];            
}

+ (NSString*)textContent:(NSDictionary*)post
{
    return [post objectForKey:PARA_TEXT_CONTENT];
}

+ (NSString*)nickName:(NSDictionary*)post
{
    return [post objectForKey:PARA_NICKNAME];
}

+ (NSString*)imageURL:(NSDictionary*)post
{
    return [post objectForKey:PARA_IMAGE_URL];
}

+ (int)contentType:(NSDictionary*)post
{
    return [[post objectForKey:PARA_CONTENT_TYPE] intValue];
}

+ (NSDate*)createDate:(NSDictionary*)post
{
    // TBD
    return dateFromUTCStringByFormat([post objectForKey:PARA_CREATE_DATE], DEFAULT_DATE_FORMAT);
}

+ (int)totalView:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_VIEW] intValue];    
}

+ (int)totalForward:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_FORWARD] intValue];    
}

+ (int)totalQuote:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_QUOTE] intValue];    
}

+ (int)totalReply:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_REPLY] intValue];    
}

+ (NSString*)name:(NSDictionary*)place
{
    return [place objectForKey:PARA_NAME];
}

+ (NSString*)description:(NSDictionary*)place
{
    return [place objectForKey:PARA_DESC];
}

+ (NSString*)createUserId:(NSDictionary *)place
{
    return [place objectForKey:PARA_CREATE_USERID];
}

@end
