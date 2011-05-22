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
@synthesize loginidField;
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
    [self setLoginidField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [loginidField release];
    [super dealloc];
    [token release];
    [tokenSecret release];
}

- (void)registerUser:(NSString*)loginId loginIdType:(int)loginIdType nickName:(NSString*)nickName
{
    NSString* appId = @"test_app_id";
    NSString* deviceToken = @"";
    
    [self showActivityWithText:NSLS(@"kRegisteringUser")];
    dispatch_async(workingQueue, ^{
        RegisterUserOutput* output = [RegisterUserRequest send:SERVER_URL loginId:loginId loginIdType:loginIdType deviceToken:deviceToken nickName:nickName appId:appId];
        output.resultCode = ERROR_SUCCESS;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                [UserManager setUser:loginId 
                         loginIdType:loginIdType 
                              userId:nickName];
                
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
    [self registerUser:loginidField.text 
           loginIdType:LOGINID_OWN 
              nickName:loginidField.text];    

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
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            [dict removeAllObjects];
            NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                           method:@"GET"
                                                       parameters:dict
                                                      consumerKey:sinaAppKey
                                                   consumerSecret:sinaAppSecret
                                                            token:self.token
                                                      tokenSecret:self.tokenSecret];
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [url description], queryString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivity];
                [[UIApplication sharedApplication] openURL:url];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivity];
            });
        }
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
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"RegisterController sina userinfo result: %@", result);
            if (200 == [response statusCode] && nil == error) {
                NSDictionary *info = [[SBJsonParser new] objectWithString:result];
                int userId = [[info objectForKey:@"id"] intValue];
                NSString *nickname = [info objectForKey:@"screen_name"];
                NSString *imageUrl = [info objectForKey:@"profile_image_url"];
                url = [NSURL URLWithString:imageUrl];
                request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                UIImage *image = [UIImage imageWithData:data];
                [self registerUser:[NSString stringWithFormat:@"%i", userId] loginIdType:LOGINID_SINA nickName:nickname];
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
                                                   parameters:[NSDictionary dictionaryWithObject:@"dipan://qq" forKey:@"oauth_callback"]
                                                  consumerKey:qqAppKey
                                               consumerSecret:qqAppSecret
                                                        token:nil
                                                  tokenSecret:nil];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [url description], queryString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            NSURL *url = [NSURL URLWithString:qqAuthorizeUrl];
            NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                           method:@"GET"
                                                       parameters:nil
                                                      consumerKey:qqAppKey
                                                   consumerSecret:qqAppSecret
                                                            token:self.token
                                                      tokenSecret:self.tokenSecret];
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [url description], queryString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivity];
                [[UIApplication sharedApplication] openURL:url];
            }); 
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActivity];
            }); 
        }
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
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"RegisterController qq userinfo result: %@", result);
            if (200 == [response statusCode] && nil == error) {
                NSDictionary *info = [[SBJsonParser new] objectWithString:result];
                if (0 == [[info objectForKey:@"ret"] intValue]) {
                    info = [info objectForKey:@"data"];
                    int userId = [[info objectForKey:@"name"] intValue];
                    NSString *nickname = [info objectForKey:@"nick"];
                    NSString *imageUrl = [info objectForKey:@"head"];
                    url = [NSURL URLWithString:imageUrl];
                    request = [NSURLRequest requestWithURL:url];
                    NSURLResponse *response = nil;
                    NSError *error = nil;
                    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                    UIImage *image = [UIImage imageWithData:data];
                    [self registerUser:[NSString stringWithFormat:@"%i", userId] loginIdType:LOGINID_QQ nickName:nickname];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
        });
    });
}

@end
