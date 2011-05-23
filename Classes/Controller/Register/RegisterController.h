//
//  RegisterController.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@interface RegisterController : PPViewController {
    UITextField *loginIdField;
    NSString *token;
    NSString *tokenSecret;
}

@property (nonatomic, retain) IBOutlet UITextField *loginIdField;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *tokenSecret;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldDidBeginEditing:(id)sender;
- (IBAction)textFieldDidEndEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)clickRegister:(id)sender;
- (IBAction)clickSinaLogin:(id)sender;
- (void)requestSinaAccessToken:(NSString *)query;
- (IBAction)clickQQLogin:(id)sender;
- (void)requestQQAccessToken:(NSString *)query;

@end