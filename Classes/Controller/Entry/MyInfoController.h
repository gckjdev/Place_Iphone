//
//  MyInfoController.h
//  Dipan
//
//  Created by qqn_pipi on 11-4-30.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyInfoController : UIViewController {
    IBOutlet UILabel         *loginIdLabel;
    IBOutlet UILabel         *loginIdTypeLabel;
    IBOutlet UIImageView     *avatarView;
    IBOutlet UILabel         *nicknameLabel;
}

@property (nonatomic, retain) IBOutlet UILabel         *loginIdLabel;
@property (nonatomic, retain) IBOutlet UILabel         *loginIdTypeLabel;
@property (nonatomic, retain) IBOutlet UIImageView     *avatarView;
@property (nonatomic, retain) IBOutlet UILabel         *nicknameLabel;
- (IBAction)clickLogout:(id)sender;

@end
