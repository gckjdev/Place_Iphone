//
//  PostListController.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "Place.h"
#import "LocalDataService.h"

@interface PostListController : PPTableViewController <LocalDataServiceDelegate> {
    
    NSString    *placeId;
    Place       *place;
}

@property (nonatomic, retain) NSString    *placeId;
@property (nonatomic, retain) Place       *place;

@end
