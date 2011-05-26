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

@interface PostMainController : PPViewController {
    NearbyPostController    *nearbyPostController;
    FollowPostController    *followPostController;
}

@property (nonatomic, retain) NearbyPostController    *nearbyPostController;
@property (nonatomic, retain) FollowPostController    *followPostController;

@end
