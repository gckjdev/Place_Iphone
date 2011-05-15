//
//  CreatePostController.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "Place.h"

@interface CreatePostController : PPTableViewController {
    
    Place *place;
    
    UIButton *syncSNSButton;
    UIButton *selectPlaceButton;
    UIButton *selectPhotoButton;
    UIButton *selectCameraButton;
    UITextView *contentTextView;
    
    NSMutableArray *photoArray;
    BOOL            syncSNSStatus;
}
@property (nonatomic, retain) IBOutlet UIButton *syncSNSButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPlaceButton;
@property (nonatomic, retain) IBOutlet UIButton *selectPhotoButton;
@property (nonatomic, retain) IBOutlet UIButton *selectCameraButton;
@property (nonatomic, retain) IBOutlet UITextView *contentTextView;

@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) NSMutableArray *photoArray;

@end
