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
#import "RegisterUserRequest.h"

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
					 viewImage:kViewSupportImage
			  hasNavController:YES			
			   viewControllers:controllers];	
	
	[UIUtils addViewController:[PostMainController alloc]
					 viewTitle:NSLS(@"Follow")				 
					 viewImage:kViewSupportImage
			  hasNavController:YES			
			   viewControllers:controllers];	

	[UIUtils addViewController:[MyInfoController alloc]
					 viewTitle:NSLS(@"Setting")				 
					 viewImage:kViewSupportImage
			  hasNavController:YES			
			   viewControllers:controllers];	

	[UIUtils addViewController:[InviteController alloc]
					 viewTitle:NSLS(@"Invite")				 
					 viewImage:kViewSupportImage
			  hasNavController:YES			
			   viewControllers:controllers];	

	[UIUtils addViewController:[FeedbackController alloc]
					 viewTitle:NSLS(@"Feedback")				 
					 viewImage:kViewSupportImage
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
    
    [locationService asyncGetLocation];
    
	// Init Core Data
	self.dataManager = [[CoreDataManager alloc] initWithDBName:kDbFileName dataModelName:nil];
		
    if ([UserManager isUserRegistered] == NO){
        [self addRegisterView];
    } else {
        [self addMainView];
    }
    
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

