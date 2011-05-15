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

@interface PlaceMainController : PPTableViewController {

    IBOutlet UIButton       *createPlaceButton;
    CreatePlaceController    *createPlaceController;
}

@property (nonatomic, retain) IBOutlet UIButton       *createPlaceButton;
@property (nonatomic, retain) CreatePlaceController   *createPlaceController;

- (IBAction)clickCreatePlaceButton:(id)sender;


@end
