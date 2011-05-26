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
#import "AppManager.h"

#define _THREE20_		1
#define kAppId			@"388419035"					// To be changed for each project
#define kMobClickKey	@"4dba296b112cf77d98000015"		// To be changed for each project

@interface DipanAppDelegate : PPApplication <UIApplicationDelegate, UITabBarControllerDelegate, MobClickDelegate, LocalDataServiceDelegate> {

    UIWindow			*window;
    UITabBarController	*tabBarController;
	CoreDataManager		*dataManager;	
    
    LocalDataService    *localDataService;
    LocationService     *locationService;
    RegisterController *registerController;
}

@property (nonatomic, retain) IBOutlet UIWindow				*window;
@property (nonatomic, retain) IBOutlet UITabBarController	*tabBarController;
@property (nonatomic, retain) CoreDataManager				*dataManager;
@property (nonatomic, retain) LocalDataService              *localDataService;
@property (nonatomic, retain) LocationService               *locationService;

- (void)addRegisterView;
- (void)removeRegisterView;
- (void)addMainView;
- (void)removeMainView;


@end

extern LocalDataService*  GlobalGetLocalDataService();
extern LocationService*   GlobalGetLocationService();
