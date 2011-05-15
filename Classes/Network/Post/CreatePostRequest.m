//
//  CreatePost.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "CreatePostRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation CreatePostInput

@synthesize userId;
@synthesize contentType;
@synthesize textContent;
@synthesize latitude;
@synthesize longitude;
@synthesize userLatitude;
@synthesize userLongitude;
@synthesize syncSNS;
@synthesize placeId;        
@synthesize appId;

- (void)dealloc
{
	[appId release];
	[userId	release];
	[textContent release];
	[placeId release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_CREATEPOST];	
	str = [str stringByAddQueryParameter:PARA_USERID value:userId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_CONTENT_TYPE intValue:contentType];
	str = [str stringByAddQueryParameter:PARA_TEXT_CONTENT value:textContent];
	str = [str stringByAddQueryParameter:PARA_LATITUDE doubleValue:latitude];
	str = [str stringByAddQueryParameter:PARA_LONGTITUDE doubleValue:longitude];
	str = [str stringByAddQueryParameter:PARA_USER_LATITUDE doubleValue:userLatitude];
	str = [str stringByAddQueryParameter:PARA_USER_LONGITUDE doubleValue:userLongitude];
	str = [str stringByAddQueryParameter:PARA_SYNC_SNS boolValue:syncSNS];
	str = [str stringByAddQueryParameter:PARA_PLACEID value:placeId];
	
	return str;
}

@end

@implementation CreatePostOutput

@synthesize postId;

- (void)dealloc
{
	[postId release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, postId];
}

@end



@implementation CreatePostRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[CreatePostRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[CreatePostInput class]]){
		CreatePostInput* obj = (CreatePostInput*)input;
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
	NSLog(@"CreatePostRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[CreatePostOutput class]]){
		
		CreatePostOutput* obj = (CreatePostOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			
            
			// TODO
			// obj.userId = xxxx			
			NSLog(@"CreatePostRequest result=%d, data=%@", obj.resultCode, [obj description]);						
			return YES;
		}
		else {
			NSLog(@"CreatePostRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (CreatePostOutput*)send:(NSString*)serverURL userId:(NSString*)userId appId:(NSString*)appId 
              contentType:(int)contentType textContent:(NSString*)textContent
                 latitude:(double)latitude longitude:(double)longitude
             userLatitude:(double)userLatitude userLongitude:(double)userLongitude
                  syncSNS:(BOOL)syncSNS placeId:(NSString*)placeId
{
	int result = ERROR_SUCCESS;
	CreatePostInput* input = [[CreatePostInput alloc] init];
	CreatePostOutput* output = [[[CreatePostOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = userId;
	input.appId = appId;
    input.appId = appId;
    input.contentType = contentType;
    input.textContent = textContent;
    input.latitude = latitude;
    input.longitude = longitude;
    input.userLatitude = userLatitude;
    input.userLongitude = userLongitude;
    input.syncSNS = syncSNS;
    input.placeId = placeId;
	
	if ([[CreatePostRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[CreatePostRequest send:SERVER_URL userId:@"benson" appId:@"appId" contentType:CONTENT_TYPE_TEXT textContent:@"hello, this is a 测试帖子" latitude:111.11f longitude:11133.f userLatitude:222.55f userLongitude:333.3f syncSNS:YES placeId:@"test_place_id"];
}
@end

