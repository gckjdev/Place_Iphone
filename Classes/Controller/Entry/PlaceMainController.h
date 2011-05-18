//
//  PlaceMainController.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "CreatePlaceController.h"
#import "LocalDataService.h"

@interface PlaceMainController : PPTableViewController <LocalDataServiceDelegate> {

    IBOutlet UIButton       *createPlaceButton;
    CreatePlaceController    *createPlaceController;
    
    int                     segSelectIndex;
    BOOL                    loadingUser;
    
    NSArray                 *nearbyPlaceList;
    NSArray                 *userPlaceList;
}

@property (nonatomic, retain) IBOutlet UIButton       *createPlaceButton;
@property (nonatomic, retain) CreatePlaceController   *createPlaceController;

@property (nonatomic, retain) NSArray                 *nearbyPlaceList;
@property (nonatomic, retain) NSArray                 *userPlaceList;


- (IBAction)clickCreatePlaceButton:(id)sender;


@end
