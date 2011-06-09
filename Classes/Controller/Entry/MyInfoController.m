//
//  MyInfoController
//  Dipan
//
//  Created by qqn_pipi on 11-4-30.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "MyInfoController.h"
#import "UserManager.h"
#import "DipanAppDelegate.h"
#import "User.h"
#import "UserService.h"

@implementation MyInfoController

@synthesize loginIdLabel;
@synthesize loginIdTypeLabel;
@synthesize avatarView;
@synthesize nicknameLabel;

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
    [super viewDidLoad];
    User *user = [UserManager getUser];
    loginIdLabel.text = user.userLoginId;
//    loginIdTypeLabel.text = [NSString stringWithFormat:@"%d",  [user.loginIdType intValue]];
    nicknameLabel.text = user.nickName;
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
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)clickLogout:(id)sender {

    
    UserService* userService = GlobalGetUserService();
    [userService logoutUser];
    
    DipanAppDelegate *delegate = (DipanAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate removeMainView];
    [delegate addRegisterView];
}

@end
