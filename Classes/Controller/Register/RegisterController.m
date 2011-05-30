//
//  RegisterController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "RegisterController.h"
#import "UserManager.h"
#import "DipanAppDelegate.h"
#import "RegisterUserRequest.h"
#import "OAuthCore.h"
#import "JSON.h"

#define sinaAppKey                      @"1528146353"
#define sinaAppSecret                   @"4815b7938e960380395e6ac1fe645a5c"
#define sinaRequestTokenUrl             @"http://api.t.sina.com.cn/oauth/request_token"
#define sinaAuthorizeUrl                @"http://api.t.sina.com.cn/oauth/authorize"
#define sinaAccessTokenUrl              @"http://api.t.sina.com.cn/oauth/access_token"
#define sinaUserInfoUrl                 @"http://api.t.sina.com.cn/account/verify_credentials.json"

#define qqAppKey                        @"7c78d5b42d514af8bb66f0200bc7c0fc"
#define qqAppSecret                     @"6340ae28094e66d5388b4eb127a2af43"
#define qqRequestTokenUrl               @"https://open.t.qq.com/cgi-bin/request_token"
#define qqAuthorizeUrl                  @"https://open.t.qq.com/cgi-bin/authorize"
#define qqAccessTokenUrl                @"https://open.t.qq.com/cgi-bin/access_token"
#define qqUserInfoUrl                   @"http://open.t.qq.com/api/user/info"

#define renrenAppKey                    @"cb2daa62b4ce4dc3948fa9246e4269ae"
#define renrenAppSecret                 @"60d5fe4a88b847be80cd7bd126cdfed2"

@implementation RegisterController

@synthesize loginIdField;
@synthesize token;
@synthesize tokenSecret;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    CGRect frame = self.view.frame;
    frame.origin.y = 20;
    self.view.frame = frame;
    
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.loginIdField = nil;
}


- (void)dealloc {
    [super dealloc];
    [loginIdField release];
    [token release];
    [tokenSecret release];
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[loginIdField resignFirstResponder];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [self.view.layer addAnimation:animation forKey:@"Reveal"];
    CGRect frame = self.view.frame;
    frame.origin.y = 20;
    self.view.frame = frame;
}

- (IBAction)textFieldDidBeginEditing:(id)sender
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    animation.fillMode = kCAFillModeRemoved;
    [self.view.layer addAnimation:animation forKey:@"Reveal"];
    CGRect frame = self.view.frame;
    frame.origin.y = -195;
    self.view.frame = frame;
}

- (IBAction)textFieldDidEndEditing:(id)sender
{
}

- (IBAction)backgroundTap:(id)sender {
	[loginIdField resignFirstResponder];
}

- (void)registerUserWithLoginId:(NSString*)loginId
                    loginIdType:(int)loginIdType
                       nickName:(NSString*)nickName
                         avatar:(NSString *)avatar
                    accessToken:(NSString *)accessToken
              accessTokenSecret:(NSString *)accessTokenSecret
                       province:(int)province
                           city:(int)city
                       location:(NSString *)location
                         gender:(NSString *)gender
                       birthday:(NSString *)birthday
                   sinaNickName:(NSString *)sinaNickName
                     sinaDomain:(NSString *)sinaDomain
                     qqNickName:(NSString *)qqNickName
                       qqDomain:(NSString *)qqDomain
{
    NSString* appId = [AppManager getPlaceAppId];
    NSString* deviceToken = @"";
    
    [self showActivityWithText:NSLS(@"kRegisteringUser")];
    dispatch_async(workingQueue, ^{
        RegisterUserOutput* output = [RegisterUserRequest send:SERVER_URL 
                                                       loginId:loginId
                                                   loginIdType:loginIdType
                                                   deviceToken:deviceToken
                                                      nickName:nickName
                                                        avatar:avatar
                                                   accessToken:accessToken
                                             accessTokenSecret:accessTokenSecret
                                                         appId:appId
                                                      province:province city:city 
                                                      location:location
                                                        gender:gender birthday:birthday
                                                  sinaNickName:sinaNickName
                                                    sinaDomain:sinaDomain
                                                    qqNickName:qqNickName
                                                      qqDomain:qqDomain];
        // for test
        // output.resultCode = ERROR_SUCCESS;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                [UserManager setUserWithUserId:output.userId
                                       loginId:loginId
                                   loginIdType:loginIdType
                                      nickName:nickName
                                        avatar:nil
                                   accessToken:accessToken
                             accessTokenSecret:accessTokenSecret
                                   loginStatus:YES];
                
                // show main tab view
                DipanAppDelegate *delegate = (DipanAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate removeRegisterView];
                [delegate addMainView];
            }
            else if (output.resultCode == ERROR_NETWORK){
                [UIUtils alert:NSLS(@"kSystemFailure")];
            }
            else {
                // TBD
            }
        });
    });
    
}

- (IBAction)clickRegister:(id)sender {
    [self registerUserWithLoginId:self.loginIdField.text
                      loginIdType:LOGINID_OWN
                         nickName:self.loginIdField.text
                           avatar:nil
                      accessToken:nil
                accessTokenSecret:nil
                         province:-1
                             city:-1
                         location:nil
                           gender:nil
                         birthday:nil
                     sinaNickName:nil
                       sinaDomain:nil
                       qqNickName:nil
                         qqDomain:nil
     ];

}

- (IBAction)clickSinaLogin:(id)sender{
    [self showActivityWithText:NSLS(@"kRegisteringUser")];
    dispatch_async(workingQueue, ^{
        NSURL *url = [NSURL URLWithString:sinaRequestTokenUrl];
        NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                       method:@"GET"
                                                   parameters:[NSDictionary dictionaryWithObject:@"dipan://sina" forKey:@"oauth_callback"]
                                                  consumerKey:sinaAppKey
                                               consumerSecret:sinaAppSecret
                                                        token:nil
                                                  tokenSecret:nil];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [url description], queryString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"RegisterController sina request token result: %@", result);
        if (200 == [response statusCode] && nil == error) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSArray *pairs = [result componentsSeparatedByString:@"&"];
            for(NSString *pair in pairs) {
                NSArray *keyValue = [pair componentsSeparatedByString:@"="];
                if([keyValue count] == 2) {
                    NSString *key = [keyValue objectAtIndex:0];
                    NSString *value = [keyValue objectAtIndex:1];
                    [dict setObject:value forKey:key];
                }
            }
            self.token = [dict objectForKey:@"oauth_token"];
            self.tokenSecret = [dict objectForKey:@"oauth_token_secret"];
            url = [NSURL URLWithString:sinaAuthorizeUrl];
            queryString = [OAuthCore queryStringWithUrl:url
                                                 method:@"GET"
                                             parameters:nil
                                            consumerKey:sinaAppKey
                                         consumerSecret:sinaAppSecret
                                                  token:self.token
                                            tokenSecret:self.tokenSecret];
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [url description], queryString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:url];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
        });
    });
}

- (void)requestSinaAccessToken:(NSString *)query {
    [self showActivityWithText:NSLS(@"kRegisteringUser")];
    dispatch_async(workingQueue, ^{
        NSLog(@"RegisterController sina authorize result: %@", query);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        for(NSString *pair in pairs) {
            NSArray *keyValue = [pair componentsSeparatedByString:@"="];
            if([keyValue count] == 2) {
                NSString *key = [keyValue objectAtIndex:0];
                NSString *value = [keyValue objectAtIndex:1];
                [dict setObject:value forKey:key];
            }
        }
        [dict removeObjectForKey:@"oauth_token"];
        NSURL *url = [NSURL URLWithString:sinaAccessTokenUrl];
        NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                       method:@"POST"
                                                   parameters:dict
                                                  consumerKey:sinaAppKey
                                               consumerSecret:sinaAppSecret
                                                        token:self.token
                                                  tokenSecret:self.tokenSecret];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"RegisterController sina access token result: %@", result);
        if (200 == [response statusCode] && nil == error) {
            pairs = [result componentsSeparatedByString:@"&"];
            [dict removeAllObjects];
            for(NSString *pair in pairs) {
                NSArray *keyValue = [pair componentsSeparatedByString:@"="];
                if([keyValue count] == 2) {
                    NSString *key = [keyValue objectAtIndex:0];
                    NSString *value = [keyValue objectAtIndex:1];
                    [dict setObject:value forKey:key];
                }
            }
            self.token = [dict objectForKey:@"oauth_token"];
            self.tokenSecret = [dict objectForKey:@"oauth_token_secret"];
            url = [NSURL URLWithString:sinaUserInfoUrl];
            queryString = [OAuthCore queryStringWithUrl:url
                                                 method:@"POST"
                                             parameters:nil
                                            consumerKey:sinaAppKey
                                         consumerSecret:sinaAppSecret
                                                  token:self.token
                                            tokenSecret:self.tokenSecret];
            request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
            response = nil;
            error = nil;
            data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"RegisterController sina userinfo result: %@", result);
            if (200 == [response statusCode] && nil == error) {
                NSDictionary *info = [[SBJsonParser new] objectWithString:result];
                int loginId = [[info objectForKey:@"id"] intValue];
                NSString *sinaNickName = [info objectForKey:@"screen_name"];
                NSString *sinaDomain = [info objectForKey:@"domain"];
                NSString *gender = [info objectForKey:@"gender"];
                int province = [[info objectForKey:@"province"] intValue];
                int city = [[info objectForKey:@"city"] intValue];
                NSString *location = [info objectForKey:@"location"];
                NSString *avatar = [info objectForKey:@"profile_image_url"];
                [self registerUserWithLoginId:[NSString stringWithFormat:@"%i", loginId]
                                  loginIdType:LOGINID_SINA
                                     nickName:sinaNickName
                                       avatar:avatar
                                  accessToken:token
                            accessTokenSecret:tokenSecret
                                     province:province
                                         city:city
                                     location:location
                                       gender:gender
                                     birthday:nil
                                 sinaNickName:sinaNickName
                                   sinaDomain:sinaDomain
                                   qqNickName:nil
                                     qqDomain:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
        });
    });
}

- (IBAction)clickQQLogin:(id)sender {
    [self showActivityWithText:NSLS(@"kRegisteringUser")];
    dispatch_async(workingQueue, ^{
        NSURL *url = [NSURL URLWithString:qqRequestTokenUrl];
        NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                       method:@"GET"
//                                                   parameters:[NSDictionary dictionaryWithObject:@"http://www.baidu.com" forKey:@"oauth_callback"]
//                                                   parameters:nil
                                                   parameters:[NSDictionary dictionaryWithObject:@"dipan://qq" forKey:@"oauth_callback"]
                                                  consumerKey:qqAppKey
                                               consumerSecret:qqAppSecret
                                                        token:nil
                                                  tokenSecret:nil];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [url description], queryString]];
        NSLog(@"Send QQ Login, URL=%@", url);
//        return;
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"RegisterController qq request token result: %@", result);
        if (200 == [response statusCode] && nil == error) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSArray *pairs = [result componentsSeparatedByString:@"&"];
            for(NSString *pair in pairs) {
                NSArray *keyValue = [pair componentsSeparatedByString:@"="];
                if([keyValue count] == 2) {
                    NSString *key = [keyValue objectAtIndex:0];
                    NSString *value = [keyValue objectAtIndex:1];
                    [dict setObject:value forKey:key];
                }
            }
            self.token = [dict objectForKey:@"oauth_token"];
            self.tokenSecret = [dict objectForKey:@"oauth_token_secret"];
            url = [NSURL URLWithString:qqAuthorizeUrl];
            queryString = [OAuthCore queryStringWithUrl:url
                                                 method:@"GET"
                                             parameters:nil
                                            consumerKey:qqAppKey
                                         consumerSecret:qqAppSecret
                                                  token:self.token
                                            tokenSecret:self.tokenSecret];
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [url description], queryString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:url];
            }); 
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
        });
    });
}

- (void)requestQQAccessToken:(NSString *)query {
    [self showActivityWithText:NSLS(@"kRegisteringUser")];
    dispatch_async(workingQueue, ^{
        NSLog(@"RegisterController qq authorize result: %@", query);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        for(NSString *pair in pairs) {
            NSArray *keyValue = [pair componentsSeparatedByString:@"="];
            if([keyValue count] == 2) {
                NSString *key = [keyValue objectAtIndex:0];
                NSString *value = [keyValue objectAtIndex:1];
                [dict setObject:value forKey:key];
            }
        }
        [dict removeObjectForKey:@"oauth_token"];
        NSURL *url = [NSURL URLWithString:qqAccessTokenUrl];
        NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                       method:@"POST"
                                                   parameters:dict
                                                  consumerKey:qqAppKey
                                               consumerSecret:qqAppSecret
                                                        token:self.token
                                                  tokenSecret:self.tokenSecret];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"RegisterController qq access token result: %@", result);
        if (200 == [response statusCode] && nil == error) {
            pairs = [result componentsSeparatedByString:@"&"];
            [dict removeAllObjects];
            for(NSString *pair in pairs) {
                NSArray *keyValue = [pair componentsSeparatedByString:@"="];
                if([keyValue count] == 2) {
                    NSString *key = [keyValue objectAtIndex:0];
                    NSString *value = [keyValue objectAtIndex:1];
                    [dict setObject:value forKey:key];
                }
            }
            self.token = [dict objectForKey:@"oauth_token"];
            self.tokenSecret = [dict objectForKey:@"oauth_token_secret"];
            url = [NSURL URLWithString:qqUserInfoUrl];
            queryString = [OAuthCore queryStringWithUrl:url
                                                 method:@"POST"
                                             parameters:[NSDictionary dictionaryWithObject:@"json" forKey:@"format"]
                                            consumerKey:qqAppKey
                                         consumerSecret:qqAppSecret
                                                  token:self.token
                                            tokenSecret:self.tokenSecret];
            request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
            response = nil;
            error = nil;
            data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"RegisterController qq userinfo result: %@", result);
            if (200 == [response statusCode] && nil == error) {
                NSDictionary *info = [[SBJsonParser new] objectWithString:result];
                if (0 == [[info objectForKey:@"ret"] intValue]) {
                    info = [info objectForKey:@"data"];
                    NSString *loginId = [info objectForKey:@"name"];
                    NSString *qqNickName = [info objectForKey:@"nick"];
                    NSString *gender = (1 == [[info objectForKey:@"sex"] intValue]) ? @"m" : @"f";
                    int province = [[info objectForKey:@"province_code"] intValue];
                    int city = [[info objectForKey:@"city_code"] intValue];
                    NSString *location = [info objectForKey:@"location"];
                    int day = [[info objectForKey:@"birth_day"] intValue];
                    int month = [[info objectForKey:@"birth_month"] intValue];
                    int year = [[info objectForKey:@"birth_year"] intValue];
                    NSString *birthday = [NSString stringWithFormat:@"%d-%02d-%02d", year, month, day];
                    NSString *avatar = [info objectForKey:@"head"];
                    avatar = [NSString stringWithFormat:@"%@/%d", avatar, 100];
                    [self registerUserWithLoginId:loginId
                                      loginIdType:LOGINID_QQ
                                         nickName:qqNickName
                                           avatar:avatar
                                      accessToken:token
                                accessTokenSecret:tokenSecret
                                         province:province
                                             city:city
                                         location:location
                                           gender:gender
                                         birthday:birthday
                                     sinaNickName:nil
                                       sinaDomain:nil
                                       qqNickName:qqNickName
                                         qqDomain:loginId];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
        });
    });
}

@end
