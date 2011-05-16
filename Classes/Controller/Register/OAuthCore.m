//
//  OAuthCore.h
//
//  Created by Lizhang Peng on 5/16/11.
//  Copyright 2010 Orange. All rights reserved.
//

#import "OAuthCore.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (OAuthCore)

- (NSString *)urlencodeWithUTF8
{
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
	NSString *escapedStr = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, nil, forceEscaped, kCFStringEncodingUTF8);
    return [escapedStr autorelease];
}

@end

NSInteger SortParameter(NSString *key1, NSString *key2, void *context) {
	NSComparisonResult r = [key1 compare:key2];
	if(r == NSOrderedSame) {
		NSDictionary *dict = (NSDictionary *)context;
		NSString *value1 = [dict objectForKey:key1];
		NSString *value2 = [dict objectForKey:key2];
		return [value1 compare:value2];
	}
	return r;
}

@implementation OAuthCore

+ (NSData *)hmacSHA1WithString:(NSString *)value key:(NSString *)key
{
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [value UTF8String], [value length], buf);
	return [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
}

+ (NSString *)GUID
{
    CFUUIDRef u = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, u);
	CFRelease(u);
	return [(NSString *)s autorelease];
}

+ (NSString *)queryStringWithUrl:(NSURL *)url
                          method:(NSString *)method
                      parameters:(NSDictionary *)parameters
                     consumerKey:(NSString *)consumerKey
                  consumerSecret:(NSString *)consumerSecret
                           token:(NSString *)token
                     tokenSecret:(NSString *)tokenSecret
{
    NSString *nonce = [OAuthCore GUID];
	NSString *timestamp = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
	NSString *signatureMethod = @"HMAC-SHA1";
	NSString *version = @"1.0";
	
	NSMutableDictionary *authParameters = [NSMutableDictionary dictionary];
	[authParameters setObject:nonce forKey:@"oauth_nonce"];
	[authParameters setObject:timestamp forKey:@"oauth_timestamp"];
	[authParameters setObject:signatureMethod forKey:@"oauth_signature_method"];
	[authParameters setObject:version forKey:@"oauth_version"];
	[authParameters setObject:consumerKey forKey:@"oauth_consumer_key"];
	if(token)
		[authParameters setObject:token forKey:@"oauth_token"];
    if(parameters) [authParameters addEntriesFromDictionary:parameters];
	
	for(NSString *key in [authParameters allKeys]) {
		NSString *value = [authParameters objectForKey:key];
		[authParameters setObject:[value urlencodeWithUTF8] forKey:key];
    }
    
    NSArray *sortedKeys = [[authParameters allKeys] sortedArrayUsingFunction:SortParameter context:authParameters];
    
	NSMutableArray *parameterArray = [NSMutableArray array];
	for(NSString *key in sortedKeys) {
		[parameterArray addObject:[NSString stringWithFormat:@"%@=%@", key, [authParameters objectForKey:key]]];
	}
	NSString *normalizedParameterString = [parameterArray componentsJoinedByString:@"&"];
	
	NSString *normalizedURLString = [NSString stringWithFormat:@"%@://%@%@", [url scheme], [url host], [url path]];
	
	NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@",
                                     method,
                                     [normalizedURLString urlencodeWithUTF8],
                                     [normalizedParameterString urlencodeWithUTF8]];
	
	NSString *key = [NSString stringWithFormat:@"%@&%@", consumerSecret, nil == tokenSecret ? @"" : tokenSecret];
    
	NSData *signature = [OAuthCore hmacSHA1WithString:signatureBaseString key:key];
	NSString *base64Signature = [GTMBase64 stringByWebSafeEncodingData:signature padded:NO];
	[authParameters setObject:base64Signature forKey:@"oauth_signature"];
	
	NSMutableArray *queryItems = [NSMutableArray array];
	for(NSString *key in authParameters) {
		NSString *value = [authParameters objectForKey:key];
		[queryItems addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
	}
	
	return [queryItems componentsJoinedByString:@"&"];
}

@end
