//
//  PostMainController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostMainController.h"
#import "Post.h"
#import "PostManager.h"
#import "UserManager.h"
#import "NearbyPostController.h"


enum SELECT_POST_TYPE {
    SELECT_NEARBY = 0,
    SELECT_FOLLOW,
    SELECT_MINE,
    SELECT_PRIVATE_MESSAGE,
    };

@implementation PostMainController

@synthesize nearbyPostController;
@synthesize followPostController;
@synthesize privateMessageController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [nearbyPostController release];
    [followPostController release];
    [privateMessageController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)showNearbyPost
{
    if (self.nearbyPostController == nil){
        self.nearbyPostController = [[NearbyPostController alloc] init];
        [self.view addSubview:nearbyPostController.view];        
    }
    
    [self.view bringSubviewToFront:nearbyPostController.view];
    [nearbyPostController viewDidAppear:NO];
}

- (void)showFollowPost
{
    if (self.followPostController == nil){
        self.followPostController = [[FollowPostController alloc] init];
        [self.view addSubview:followPostController.view];        
    }
    
    [self.view bringSubviewToFront:followPostController.view];
    [followPostController viewDidAppear:NO];
}

- (void)showPrivateMessage
{
    if (self.privateMessageController == nil){
        self.privateMessageController = [[PrivateMessageListController alloc] init];
        [self.view addSubview:privateMessageController.view];                
    }

    [self.view bringSubviewToFront:privateMessageController.view];
    [privateMessageController viewDidAppear:NO];

}

- (void)viewDidLoad
{
    [self createNavigationTitleToolbar:
                    [NSArray arrayWithObjects:
                     NSLS(@"kNearbyPost"),
                     NSLS(@"kFollowPost"),
                     NSLS(@"kMyPost"),
                     NSLS(@"kMyPrivateMessage"),
                     nil]
                    defaultSelectIndex:SELECT_NEARBY];    

    [super viewDidLoad];
    [self showNearbyPost];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table View Delegate

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
//{
//	NSMutableArray* array = [NSMutableArray arrayWithArray:[ArrayOfCharacters getArray]];
//	[array addObject:kSectionNull];
//	return array;
//	
////		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
////		return nil;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [groupData sectionForLetter:title];
//}


#pragma Title ToolBar Button Actions

- (void)clickSegControl:(id)sender
{
    UISegmentedControl* segControl = sender;
    if (segControl.selectedSegmentIndex == SELECT_FOLLOW){
        [self showFollowPost];
    }
    else if (segControl.selectedSegmentIndex == SELECT_NEARBY){
        [self showNearbyPost];
    }
    else{
        [self showPrivateMessage];
    }
}

@end
