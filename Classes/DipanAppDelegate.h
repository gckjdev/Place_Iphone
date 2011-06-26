//
//  DipanAppDelegate.h
//  Dipan
//
//  Created by qqn_pipi on 11-4-30.
//  Copyright QQN-PIPI.com 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataUtil.h"
#import "PPApplication.h"
#import "MobClick.h"
#import "LocalDataService.h"
#import "LocationService.h"
#import "RegisterController.h"
#import "EnterPlaceAppController.h"
#import "AppManager.h"
#import "UserService.h"

// TODO remove all depedency class header files

@class PlaceSNSService;
@class MessageService;

#define _THREE20_		1
#define kAppId			@"388419035"					// To be changed for each project
#define kMobClickKey	@"4dba296b112cf77d98000015"		// To be changed for each project

@interface DipanAppDelegate : PPApplication <UIApplicationDelegate, UITabBarControllerDelegate, MobClickDelegate, EnterPlaceAppDelegate,
LocalDataServiceDelegate, UserServiceDelegate> {

    UIWindow			*window;
    UITabBarController	*tabBarController;
	CoreDataManager		*dataManager;	
    
    LocalDataService    *localDataService;
    LocationService     *locationService;
    UserService         *userService;
    RegisterController  *registerController;
    PlaceSNSService     *snsService;
    MessageService      *messageService;

    EnterPlaceAppController *enterController;    
    NSString                *placeNameForRegistration;
    
    UIBackgroundTaskIdentifier backgroundTask;
}

@property (nonatomic, retain) IBOutlet UIWindow				*window;
@property (nonatomic, retain) IBOutlet UITabBarController	*tabBarController;
@property (nonatomic, retain) CoreDataManager				*dataManager;
@property (nonatomic, retain) LocalDataService              *localDataService;
@property (nonatomic, retain) LocationService               *locationService;
@property (nonatomic, retain) UserService                   *userService;
@property (nonatomic, retain) PlaceSNSService               *snsService;
@property (nonatomic, retain) MessageService                *messageService;
@property (nonatomic, retain) RegisterController            *registerController;
@property (nonatomic, retain) EnterPlaceAppController       *enterController;    
@property (nonatomic, retain) NSString                      *placeNameForRegistration;

- (BOOL)requireCreatePlace;
- (void)addEnterAppView;
- (void)removeEnterAppView;
- (void)addRegisterView;
- (void)removeRegisterView;
- (void)addMainView;
- (void)removeMainView;
- (void)dismissRegisterView;

@end


