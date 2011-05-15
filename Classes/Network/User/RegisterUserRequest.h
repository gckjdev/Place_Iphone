//
//  RegisterUser.h
//  FacetimeAnyone
//
//  Created by Peng Lingzhe on 10/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"

@interface RegisterUserInput : NSObject
{
	NSString*		loginId;
	NSString*		appId;
	int				loginIdType;
	NSString*		deviceId;
	NSString*		deviceModel;	
	int				deviceOS;
	NSString*		countryCode;
	NSString*		language;
	NSString*		deviceToken;	
}

@property (nonatomic, retain) NSString*		loginId;
@property (nonatomic, assign) int			loginIdType;
@property (nonatomic, assign) int			deviceOS;
@property (nonatomic, retain) NSString*		deviceId;
@property (nonatomic, retain) NSString*		deviceModel;
@property (nonatomic, retain) NSString*		countryCode;
@property (nonatomic, retain) NSString*		language;
@property (nonatomic, retain) NSString*		appId;
@property (nonatomic, retain) NSString*		deviceToken;
@end

@interface RegisterUserOutput : CommonOutput
{
	NSString	*userId;
}

@property (nonatomic, retain) NSString	*userId;

@end

@interface RegisterUserRequest : NetworkRequest {
	
}

+ (RegisterUserOutput*)send:(NSString*)serverURL loginId:(NSString*)loginId loginIdType:(int)loginIdType deviceToken:(NSString*)deviceToken appId:(NSString*)appId;
+ (void)test;

@end
