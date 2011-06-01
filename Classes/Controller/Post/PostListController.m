//
//  PostListController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright 2011骞�__MyCompanyName__. All rights reserved.
//

#import "CreatePostController.h"
#import "PostListController.h"
#import "PostManager.h"
#import "UserManager.h"
#import "PlaceManager.h"
#import "Post.h"
#import "LocalDataService.h"
#import "DipanAppDelegate.h"
#import "UserFollowPlaceRequest.h"
#import "UserUnfollowPlaceRequest.h"
#import "PostController.h"
#import "PostControllerUtils.h"

@implementation PostListController

@synthesize place;

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
    [place release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadPostList
{
    // load post list from local DB
    self.dataList = [PostManager getPostByPlace:place.placeId];
    LocalDataService* dataService = GlobalGetLocalDataService();
    [dataService requestLatestPlacePostData:self placeId:place.placeId];
}

- (void)placePostDataRefresh:(int)result
{
    self.dataList = [PostManager getPostByPlace:place.placeId];
    [self.dataTableView reloadData];
}

- (void)viewDidLoad
{
    [self setNavigationRightButton:NSLS(@"kNewPost") action:@selector(clickCreatePost:)];
    //[self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
    
    //    [self loadPostList];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self loadPostList];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	
	
    //	switch (section) {
    //		case <#constant#>:
    //			<#statements#>
    //			break;
    //		default:
    //			break;
    //	}
	
	return sectionHeader;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	return [self getSectionView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return sectionImageHeight;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//	return [self getFooterView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return footerImageHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return [PostControllerUtils getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
	
	// return [groupData totalSectionCount];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataList count];			// default implementation
	
	// return [groupData numberOfRowsInSection:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [PostControllerUtils setCellStyle:cell];
	}
		
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    //	[self setCellBackground:cell row:row count:count];
    
    Post* post = [dataList objectAtIndex:row];
    [PostControllerUtils setCellInfoWithPost:post cell:cell];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	// do select row action
    [PostControllerUtils gotoPostController:self 
                                       post:[dataList objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row < 0 || indexPath.row > [dataList count] - 1)
			return;
        
		// take delete action below, update data list
		// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];		
		
		// update table view
		
	}
	
}

#pragma Button Action

- (void)clickCreatePost:(id)sender
{
    CreatePostController* vc = [[CreatePostController alloc] init];
    vc.place = self.place;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)followPlace:(NSString*)userId placeId:(NSString*)placeId
{
    NSString* appId = [AppManager getPlaceAppId];
    
    [self showActivityWithText:NSLS(@"kFollowingPlace")];
    dispatch_async(workingQueue, ^{
        
        UserFollowPlaceOutput* output = [UserFollowPlaceRequest send:SERVER_URL userId:userId placeId:placeId appId:appId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // save place data locally
                [PlaceManager createPlace:place.placeId name:place.name desc:place.desc longitude:[place.longitude doubleValue] latitude:[place.latitude doubleValue] createUser:place.createUser followUserId:userId
                                   useFor:PLACE_USE_FOLLOW];
            }
            else if (output.resultCode == ERROR_NETWORK){
                [UIUtils alert:NSLS(@"kSystemFailure")];
                // for test, TO BE REMOVED
                
            }
            else{
                // other error TBD
                // for test, TO BE REMOVED
            }
        });        
    });    
    
}

- (void)unfollowPlace:(NSString*)userId placeId:(NSString*)placeId
{
    NSString* appId = [AppManager getPlaceAppId];
    
    [self showActivityWithText:NSLS(@"kFollowingPlace")];
    dispatch_async(workingQueue, ^{
        
        UserUnfollowPlaceOutput* output = [UserUnfollowPlaceRequest send:SERVER_URL userId:userId placeId:placeId appId:appId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // save place data locally
                
                
            }
            else if (output.resultCode == ERROR_NETWORK){
                [UIUtils alert:NSLS(@"kSystemFailure")];
                // for test, TO BE REMOVED
                
            }
            else{
                // other error TBD
                // for test, TO BE REMOVED
            }
        });        
    });    
    
}

- (IBAction)clickFollow:(id)sender
{
    NSString* userId = [UserManager getUserId];
    [self followPlace:userId placeId:place.placeId];
}

- (IBAction)clickUnFollow:(id)sender
{
    NSString* userId = [UserManager getUserId];
    [self unfollowPlace:userId placeId:place.placeId];
}

@end
