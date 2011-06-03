//
//  DipanAppDelegate.m
//  Dipan
//
//  Created by qqn_pipi on 11-4-30.
//  Copyright QQN-PIPI.com 2011. All rights reserved.
//

#import "DipanAppDelegate.h"
#import "UIUtils.h"
#import "ReviewRequest.h"

// optional header files
#import "AboutViewController.h"
#import "PPViewController.h"
#import "TestPPViewController.h"
#import "SelectItemViewController.h"
#import "FlurryAPI.h"

#import "MyInfoController.h"
#import "InviteController.h"
#import "FeedbackController.h"
#import "PlaceMainController.h"
#import "PostMainController.h"

#import "UserManager.h"
#import "RegisterController.h"
#import "DeviceLoginRequest.h"

#define kDbFileName			@"AppDB"

LocalDataService* GlobalGetLocalDataService()
{
    DipanAppDelegate* delegate = (DipanAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return [delegate localDataService];
}

LocationService*   GlobalGetLocationService()
{
    DipanAppDelegate* delegate = (DipanAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return [delegate locationService];

}

@implementation DipanAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize dataManager;
@synthesize localDataService;
@synthesize locationService;

#pragma mark -
#pragma mark Application lifecycle

- (void)initTabViewControllers
{
	NSMutableArray* controllers = [[NSMutableArray alloc] init];

	[UIUtils addViewController:[PlaceMainController alloc]
					 viewTitle:NSLS(@"Nearby")
					 viewImage:@"app_globe_24.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
	
	[UIUtils addViewController:[PostMainController alloc]
					 viewTitle:NSLS(@"Follow")				 
					 viewImage:@"comment_24.png"
			  hasNavController:YES			
			   viewControllers:controllers];	

	[UIUtils addViewController:[MyInfoController alloc]
					 viewTitle:NSLS(@"Setting")				 
					 viewImage:@"man_24.png"
			  hasNavController:YES			
			   viewControllers:controllers];	

	[UIUtils addViewController:[InviteController alloc]
					 viewTitle:NSLS(@"Invite")				 
					 viewImage:@"mail_24.png"
			  hasNavController:YES			
			   viewControllers:controllers];	

	[UIUtils addViewController:[FeedbackController alloc]
					 viewTitle:NSLS(@"Feedback")				 
					 viewImage:@"help_24.png"
			  hasNavController:YES			
			   viewControllers:controllers];	
	
	tabBarController.viewControllers = controllers;
	
	[controllers release];
}

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (void)initFlurry
{
	[FlurryAPI startSession:@"L82L9IVN6MYU1B42QJJL"];	// the ID shall be changed for each application
	
//	[FlurryAPI logEvent:@"EVENT_NAME"];
//	[FlurryAPI logEvent:@"EVENT_NAME" withParameters:YOUR_NSDictionary];
//	[FlurryAPI logEvent:@"EVENT_NAME" timed:YES];
//	[FlurryAPI logError:@"ERROR_NAME" message:@"ERROR_MESSAGE" exception:e];
//	[FlurryAPI setUserID:[[UIDevice currentDevice] uniqueIdentifier]];
//	[FlurryAPI setAge:21];
//	[FlurryAPI countPageViews:navigationController];
//	[FlurryAPI countPageView];
}

- (void)initMobClick
{
	[MobClick setDelegate:self];
	[MobClick appLaunched];	
}

- (void)initLocalDataService
{
    self.localDataService = [[LocalDataService alloc] initWithDelegate:self];
}

- (void)initLocationService
{
    self.locationService = [[LocationService alloc] init];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    	
	NSLog(@"Application starts, launch option = %@", [launchOptions description]);	
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);	
	
	[self initMobClick];
    [self initLocalDataService];    
    [self initLocationService];
    [self initImageCacheManager];
    
    [locationService asyncGetLocation];
    
	// Init Core Data
	self.dataManager = [[CoreDataManager alloc] initWithDBName:kDbFileName dataModelName:nil];
    workingQueue = dispatch_queue_create("main working queue", NULL);    
    
    [self checkDevice];
    
    [window makeKeyAndVisible];
	
	// Ask For Review
	[ReviewRequest startReviewRequest:kAppId appName:GlobalGetAppName() isTest:NO];

	// Test
	// [RegisterUserRequest test];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
		
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	NSLog(@"applicationWillResignActive");	
	[MobClick appTerminated];

}

- (void)stopAudioPlayer
{
	if (player && [player isPlaying]){
		[player stop];
	}	
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
	NSLog(@"applicationDidEnterBackground");	
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self releaseResourceForAllViewControllers];	
	[self stopAudioPlayer];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
	NSLog(@"applicationWillEnterForeground");	
	
	[self initMobClick];
    [localDataService requestDataWhileEnterForeground];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
	NSLog(@"applicationDidBecomeActive");	
	
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */

	NSLog(@"applicationWillTerminate");	
	
	[MobClick appTerminated];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *host = [url host];
    if ([host isEqualToString:@"sina"]) {
        [registerController requestSinaAccessToken:[url query]];
    } else if ([host isEqualToString:@"qq"]) {
        [registerController requestQQAccessToken:[url query]];
    }
    
    return YES;
}

- (void)checkDevice {
    User *user = [UserManager getUser];
    if (nil != user){
        if ([user.loginStatus boolValue]) {

            NSLog(@"<checkDevice> local user found, status LOGIN, detect user in background");
            [self addMainView];
            
            dispatch_async(workingQueue, ^{
                DeviceLoginOutput* output = [DeviceLoginRequest send:SERVER_URL
                                                               appId:[AppManager getPlaceAppId]
                                                            deviceId:[[UIDevice currentDevice] uniqueIdentifier]
                                                      needReturnUser:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (output.resultCode == ERROR_SUCCESS) {
                        NSLog(@"<checkDevice> update user profile from remote return data");
                        [UserManager setUserWithUserId:output.userId
                                               loginId:output.loginId
                                              nickName:output.nickName
                                       sinaAccessToken:output.sinaAccessToken
                                 sinaAccessTokenSecret:output.sinaAccessTokenSecret
                                         qqAccessToken:output.qqAccessToken
                                   qqAccessTokenSecret:output.qqAccessTokenSecret
                                           loginStatus:[user.loginStatus boolValue]];
                    }
                    else{
                        // TODO, need to handle different error code
                    }
                });
            });
        } else {
            NSLog(@"<checkDevice> local user found, status LOGOUT, request user to login again");
            [self addRegisterView];
        }
    } else {
        NSLog(@"<checkDevice> local user not found, try to detect from server");
        DeviceLoginOutput* output = [DeviceLoginRequest send:SERVER_URL
                                                       appId:[AppManager getPlaceAppId]
                                                    deviceId:[[UIDevice currentDevice] uniqueIdentifier]
                                              needReturnUser:YES];
        if (output.resultCode == ERROR_SUCCESS) {
            NSLog(@"<checkDevice> get user from remote successfully, userId=%@, loginId=%@", output.userId, output.loginId);
            [UserManager setUserWithUserId:output.userId
                                   loginId:output.loginId
                                  nickName:output.nickName
                           sinaAccessToken:output.sinaAccessToken
                     sinaAccessTokenSecret:output.sinaAccessTokenSecret
                             qqAccessToken:output.qqAccessToken
                       qqAccessTokenSecret:output.qqAccessTokenSecret
                               loginStatus:YES];
            [self addMainView];
        } 
        else if (output.resultCode == ERROR_NETWORK){
            NSLog(@"<checkDevice> fail to get user from remote due to network faiure");            
            [self addRegisterView];
        }
        else
        {
            // TODO, need to show different error based on error code
            NSLog(@"<checkDevice> fail to get user from remote");
            [self addRegisterView];
        }
    }
}

#pragma Register View Management

- (void)addRegisterView {
    registerController = [[RegisterController alloc] init];
    [window addSubview:registerController.view];
}

- (void)removeRegisterView {
    [registerController.view removeFromSuperview];
    [registerController release];
    registerController = nil;
}

- (void)addMainView {
    // Init tab bar and window
	[self initTabViewControllers];
	[window addSubview:tabBarController.view];
}

- (void)removeMainView {
    [tabBarController.view removeFromSuperview];
}


#pragma mark Local Notification Handler

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {		
		
	NSLog(@"didReceiveLocalNotification, application state is %d", app.applicationState);	
	if (app.applicationState == UIApplicationStateActive){		
		// if application is in active state, simulate to popup an alert box
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GlobalGetAppName() 
															message:notif.alertBody 
														   delegate:self 
												  cancelButtonTitle:NSLS(@"Close") 
												  otherButtonTitles:notif.alertAction, nil];
		[alertView show];
		[alertView release];
	}
	else {		
		// TO DO, And Local Notification Handling Code Here
	}	
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController 
{
	
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed 
{

}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	
	// release UI objects
    [tabBarController release];
    [window release];
	
	// release data objects
	[dataManager release];
    [localDataService release];
    [locationService release];
	
    [super dealloc];
}

#pragma mark Mob Click Delegates

- (NSString *)appKey
{
	return kMobClickKey;	// shall be changed for each application
}

#pragma Local Data Service Delegate

- (void)followPlaceDataRefresh
{
    NSLog(@"<followPlaceDataRefresh>");
}


@end

