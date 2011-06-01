//
//  PostController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostController.h"
#import "CreatePostController.h"
#import "UserManager.h"
#import "AppManager.h"
#import "GetPostRelatedPostRequest.h"
#import "ResultUtils.h"
#import "PostControllerUtils.h"

enum{
    SECTION_POST_ITSELF,
    SECTION_RELATED_POST,
    SECTION_NUM
};


@implementation PostController

@synthesize actionToolbar;
@synthesize post;

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
    [post release];
    [actionToolbar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadPostRelatedPost
{
    if ([UserManager isUserRegistered] == NO)
        return;
    
    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    
    dispatch_async(workingQueue, ^{        
        GetPostRelatedPostOutput* output = [GetPostRelatedPostRequest send:SERVER_URL userId:userId 
                                                                     appId:appId 
                                                                    postId:post.srcPostId
                                                           beforeTimeStamp:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){
                self.dataList = output.postArray;
                [self.dataTableView reloadData];
            }
            else{
                NSLog(@"<requestNearbyPlaceData> failure, result code=%d", output.resultCode);            
                
            }                
        });
    });
    
}

- (void)initActionToolbar
{	
    UIBarButtonItem* replyButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                    UIBarButtonSystemItemReply target:self action:@selector(replyPost)] autorelease];
        
    UIBarItem* spaceButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                         UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];    
    
    actionToolbar.items = [NSArray arrayWithObjects:replyButton, spaceButton, nil];
}

- (void)viewDidLoad
{
    supportRefreshHeader = YES;    
    [self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
    
    [self initActionToolbar];    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self loadPostRelatedPost];

}

- (void)viewDidUnload
{
    
    [self setActionToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [super viewDidDisappear:animated];
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
    switch (indexPath.section) {
        case SECTION_POST_ITSELF:
            return [PostControllerUtils getCellHeight];
            
        case SECTION_RELATED_POST:
            return [PostControllerUtils getCellHeight];
            
        default:            
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return SECTION_NUM;			

}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SECTION_POST_ITSELF:
            return 1;
            break;
            
        case SECTION_RELATED_POST:
            return [dataList count];
            break;

        default:            
            return 0;
    }    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
        
        [PostControllerUtils setCellStyle:cell];        
	}
	
    switch (indexPath.section) {
        case SECTION_POST_ITSELF:
        {
            [PostControllerUtils setCellInfoWithPost:post cell:cell];
        }
            break;
            
        case SECTION_RELATED_POST:
        {
            int row = [indexPath row];	
            int count = [dataList count];
            if (row >= count){
                NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
                return cell;
            }            
            
            NSDictionary* dict = [dataList objectAtIndex:row];
            [PostControllerUtils setCellInfoWithDict:dict cell:cell];
                    
        }
            break;
            
        default:            
            break;
    }    

	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row > [dataList count] - 1)
		return;
	    
}

#pragma Pull Refresh Delegate

- (void) reloadTableViewDataSource
{
    [self loadPostRelatedPost];
}

#pragma Button Actions

- (void)replyPost
{
    CreatePostController* vc = [[CreatePostController alloc] init];
    vc.srcPostId = post.postId;
    vc.srcPlaceId = post.placeId;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)clickBack:(id)sender
{
    int count = [self.navigationController.viewControllers count];
    if (count >= 2){
        UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:count-2];
        vc.hidesBottomBarWhenPushed = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
