//
//  PostMainController.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "NearbyPostController.h"
#import "FollowPostController.h"
#import "PrivateMessageListController.h"
#import "AtMePostController.h"

@interface PostMainController : PPViewController {
    NearbyPostController    *nearbyPostController;
    FollowPostController    *followPostController;
    AtMePostController      *atMePostController;
}

@property (nonatomic, retain) NearbyPostController    *nearbyPostController;
@property (nonatomic, retain) FollowPostController    *followPostController;
@property (nonatomic, retain) PrivateMessageListController *privateMessageController;
@property (nonatomic, retain) AtMePostController      *atMePostController;
@end
