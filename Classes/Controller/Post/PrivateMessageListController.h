//
//  PrivateMessageListController.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface PrivateMessageListController : PPTableViewController     {
    
    UIViewController     *superController;
}

@property (nonatomic, retain) UIViewController     *superController;

@end
