//
//  GetPlacePost.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "GetPlacePostRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation GetPlacePostInput

@synthesize userId;
@synthesize appId;
@synthesize placeId;
@synthesize afterTimeStamp;
@synthesize maxCount;

- (void)dealloc
{
	[appId release];
    [userId release];    
    [afterTimeStamp release];
    [placeId release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_GETPLACEPOST];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_PLACEID value:placeId];
	str = [str stringByAddQueryParameter:PARA_AFTER_TIMESTAMP value:afterTimeStamp];
	str = [str stringByAddQueryParameter:PARA_MAX_COUNT intValue:maxCount];
	
	return str;
}

@end

@implementation GetPlacePostOutput

@synthesize postArray;

- (void)dealloc
{
    [postArray release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, [postArray description]];
}

- (NSString*)postId:(NSDictionary*)post
{
    return [post objectForKey:PARA_POSTID];
}

- (NSString*)placeId:(NSDictionary*)post
{
    return [post objectForKey:PARA_PLACEID];
}

- (NSString*)userId:(NSDictionary*)post
{
    return [post objectForKey:PARA_USERID];    
}

- (double)longitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_LONGTITUDE] doubleValue];        
}

- (double)latitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_LATITUDE] doubleValue];            
}

- (double)userLongitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_USER_LONGITUDE] doubleValue];            
}

- (double)userLatitude:(NSDictionary*)post
{
    return [[post objectForKey:PARA_USER_LATITUDE] doubleValue];            
}

- (NSString*)textContent:(NSDictionary*)post
{
    return [post objectForKey:PARA_TEXT_CONTENT];
}

- (NSString*)imageURL:(NSDictionary*)post
{
    return [post objectForKey:PARA_IMAGE_URL];
}

- (int)contentType:(NSDictionary*)post
{
    return [[post objectForKey:PARA_CONTENT_TYPE] intValue];
}

- (NSDate*)createDate:(NSDictionary*)post
{
    // TBD
    return dateFromUTCStringByFormat([post objectForKey:PARA_CREATE_DATE], DEFAULT_DATE_FORMAT);
}

- (int)totalView:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_VIEW] intValue];    
}

- (int)totalForward:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_FORWARD] intValue];    
}



- (int)totalQuote:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_QUOTE] intValue];    
}

- (int)totalReply:(NSDictionary*)post
{
    return [[post objectForKey:PARA_TOTAL_REPLY] intValue];    
}

@end

@implementation GetPlacePostRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[GetPlacePostRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[GetPlacePostInput class]]){
		GetPlacePostInput* obj = (GetPlacePostInput*)input;
		NSString* url = [obj createUrlString:[self getBaseUrlString]];		
		return [url stringByURLEncode];
	}
	else {
		return nil;
	}
	
}

// virtual method
- (BOOL)parseToReponse:(NSData*)data output:(NSObject*)output
{
	const void* bytes = [data bytes];
	NSString* textData = [[[NSString alloc] initWithBytes:bytes length:[data length] encoding:NSUTF8StringEncoding] autorelease];		
	NSLog(@"GetPlacePostRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[GetPlacePostOutput class]]){
		
		GetPlacePostOutput* obj = (GetPlacePostOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO         
            obj.postArray = [obj arrayFromJSON:textData];
			NSLog(@"GetPlacePostRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"GetPlacePostRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
			return NO;		
		}
	}
	else {
		return NO;
	}	
	
}


+ (int)getdeviceOS
{
	return OS_IOS;
}

+ (GetPlacePostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId placeId:(NSString*)placeId afterTimeStamp:(NSString*)afterTimeStamp
{
    const int kMaxCount = 30;
    
	int result = ERROR_SUCCESS;
	GetPlacePostInput* input = [[GetPlacePostInput alloc] init];
	GetPlacePostOutput* output = [[[GetPlacePostOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.placeId = placeId;
    input.afterTimeStamp = afterTimeStamp;
    input.maxCount = kMaxCount;
	
	if ([[GetPlacePostRequest requestWithURL:serverURL] sendRequest:input output:output]){
		result = output.resultCode;
	}
	else{
		output.resultCode = ERROR_NETWORK;
	}
	
	[input release];
	
	return output;	
}

+ (void)test
{
	[GetPlacePostRequest send:SERVER_URL userId:@"test_user_id" appId:@"test_app"
     placeId:@"test_place_id" afterTimeStamp:@""];
}

@end

