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
#import "BindUserRequest.h"
#import "OAuthCore.h"
#import "JSON.h"
#import "PlaceSNSService.h"

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

- (IBAction)clickRegister:(id)sender {
    
    UserService* userService = GlobalGetUserService();
    [userService loginUserWithLoginId:loginIdField.text viewController:self];     
}

- (IBAction)clickSinaLogin:(id)sender
{
    PlaceSNSService* snsService = GlobalGetSNSService();
    [snsService sinaInitiateLogin:self];
}

- (IBAction)clickQQLogin:(id)sender
{
    PlaceSNSService* snsService = GlobalGetSNSService();
    [snsService qqInitiateLogin:self];
}

AuthorizationSuccessHandler snsAuthorizeSuccess = ^(NSDictionary* userInfo, PPViewController* viewController){
    UserService* userService = GlobalGetUserService();
    [userService loginUserWithSNSUserInfo:userInfo viewController:viewController];            

};

- (void)sinaParseAuthorizationResponseURL:(NSString *)query {
    PlaceSNSService* snsService = GlobalGetSNSService();
    [snsService sinaParseAuthorizationResponseURL:query viewController:self successHandler:snsAuthorizeSuccess];
}

- (void)qqParseAuthorizationResponseURL:(NSString *)query {
    PlaceSNSService* snsService = GlobalGetSNSService();
    [snsService qqParseAuthorizationResponseURL:query viewController:self successHandler:snsAuthorizeSuccess];    
}

@end
