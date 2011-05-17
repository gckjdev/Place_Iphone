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

#define kOAuthConsumerKey				@"1528146353"
#define kOAuthConsumerSecret			@"4815b7938e960380395e6ac1fe645a5c"	

@implementation RegisterController
@synthesize loginidField;

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
}

- (void)registerUser:(NSString*)loginId loginIdType:(int)loginIdType
{
    NSString* appId = @"test_app_id";
    NSString* deviceToken = @"";
    
    [self showActivityWithText:NSLS(@"kRegisteringUser")];
    dispatch_async(workingQueue, ^{
        RegisterUserOutput* output = [RegisterUserRequest send:SERVER_URL loginId:loginId loginIdType:loginIdType deviceToken:deviceToken appId:appId];
//        output.resultCode = ERROR_SUCCESS;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save user data locally
                [UserManager setUser:loginId 
                         loginIdType:loginIdType 
                              userId:output.userId];
                
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
    [self registerUser:loginidField.text loginIdType:LOGINID_OWN];    

}

- (IBAction)clickSinaLogin:(id)sender{
    NSURL *url = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/request_token"];
    NSString *queryString = [OAuthCore queryStringWithUrl:url
                                                   method:@"GET"
                                               parameters:nil
                                              consumerKey:kOAuthConsumerKey
                                           consumerSecret:kOAuthConsumerSecret
                                                    token:nil
                                              tokenSecret:nil];
    NSLog(@"queryString: %@", queryString);
}

@end
