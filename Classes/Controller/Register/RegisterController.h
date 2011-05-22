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
    UITextField *loginidField;
    NSString *token;
    NSString *tokenSecret;
}

@property (nonatomic, retain) IBOutlet UITextField *loginidField;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *tokenSecret;

- (IBAction)clickRegister:(id)sender;
- (IBAction)clickSinaLogin:(id)sender;
- (void)requestSinaAccessToken:(NSString *)query;
- (IBAction)clickQQLogin:(id)sender;
- (void)requestQQAccessToken:(NSString *)query;

@end