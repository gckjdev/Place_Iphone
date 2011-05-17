//
//  RegisterUser.m
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "RegisterUserRequest.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation RegisterUserInput

@synthesize loginId;
@synthesize loginIdType;
@synthesize appId;
@synthesize deviceId;
@synthesize deviceOS;
@synthesize deviceModel;
@synthesize countryCode;
@synthesize language;
@synthesize deviceToken;

- (void)dealloc
{
	[appId release];
	[loginId	release];
	[deviceId release];
	[deviceModel release];
	[countryCode release];
	[language release];
	[deviceToken release];
	[super dealloc];	
}

- (NSString*)createUrlString:(NSString*)baseURL
{
	NSString* str = [NSString stringWithString:baseURL];
	
	str = [str stringByAddQueryParameter:METHOD value:METHOD_REGISTRATION];	
	str = [str stringByAddQueryParameter:PARA_LOGINID value:loginId];
	str = [str stringByAddQueryParameter:PARA_APPID value:appId];
	str = [str stringByAddQueryParameter:PARA_LOGINIDTYPE intValue:loginIdType];
	str = [str stringByAddQueryParameter:PARA_DEVICEID value:deviceId];
	str = [str stringByAddQueryParameter:PARA_DEVICEMODEL value:deviceModel];
	str = [str stringByAddQueryParameter:PARA_DEVICEOS intValue:deviceOS];
	str = [str stringByAddQueryParameter:PARA_COUNTRYCODE value:countryCode];
	str = [str stringByAddQueryParameter:PARA_LANGUAGE value:language];
	str = [str stringByAddQueryParameter:PARA_DEVICETOKEN value:deviceToken];
	
	return str;
}

@end

@implementation RegisterUserOutput

@synthesize userId;

- (void)dealloc
{
	[userId release];
	[super dealloc];	
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"resultCode=%d, data=%@", resultCode, userId];
}

@end



@implementation RegisterUserRequest

+ (id)requestWithURL:(NSString*)urlString
{
	NetworkRequest* request = [[[RegisterUserRequest alloc] init] autorelease];
	request.serverURL = urlString;
	return request;
}

// virtual method
- (NSString*)getRequestUrlString:(NSObject*)input
{	
	if ([input isKindOfClass:[RegisterUserInput class]]){
		RegisterUserInput* obj = (RegisterUserInput*)input;
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
	NSLog(@"RegisterUserRequest receive data=%@", textData);
	
	if ([output isKindOfClass:[RegisterUserOutput class]]){
		
		RegisterUserOutput* obj = (RegisterUserOutput*)output;
		
		// get result code and message
		[obj resultFromJSON:textData];										
		if (obj.resultCode == 0){			

			// TODO
            NSDictionary* data = [obj dictionaryDataFromJSON:textData];
			obj.userId = [data objectForKey:PARA_USERID];
			NSLog(@"RegisterUserRequest result=%d, data=%@", obj.resultCode, [data description]);						
			return YES;
		}
		else {
			NSLog(@"RegisterUserRequest result=%d, message=%@", obj.resultCode, obj.resultMessage);
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

+ (RegisterUserOutput*)send:(NSString*)serverURL loginId:(NSString*)loginId loginIdType:(int)loginIdType deviceToken:(NSString*)deviceToken appId:(NSString*)appId
{
	int result = ERROR_SUCCESS;
	RegisterUserInput* input = [[RegisterUserInput alloc] init];
	RegisterUserOutput* output = [[[RegisterUserOutput alloc] init] autorelease];
	
	// initlize all input data
	input.loginId = loginId;
	input.appId = appId;
	input.loginIdType = loginIdType;	
	input.deviceId = [[UIDevice currentDevice] uniqueIdentifier];
	input.deviceModel = [[UIDevice currentDevice] model];
	input.deviceOS = [RegisterUserRequest getdeviceOS];
	input.countryCode = [LocaleUtils getCountryCode];
	input.language = [LocaleUtils getLanguageCode];
	input.deviceToken = deviceToken;	
	
    // for test, to be removed
    input.deviceId = [NSString stringWithInt:time(0)];
    
	if ([[RegisterUserRequest requestWithURL:serverURL] sendRequest:input output:output]){
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
	[RegisterUserRequest send:SERVER_URL loginId:@"benson" loginIdType:LOGINID_OWN deviceToken:@"test_device_token" appId:@"test_app_id"];
}

@end

