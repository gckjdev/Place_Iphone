//
//  NearbyPostController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NearbyPostController.h"
#import "Post.h"
#import "PostManager.h"
#import "UserManager.h"
#import "LocalDataService.h"
#import "DipanAppDelegate.h"
#import "NetworkRequestResultCode.h"

@implementation NearbyPostController

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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)nearbyPostDataRefresh:(int)result
{    
    if (result == ERROR_SUCCESS){
        self.dataList = [PostManager getAllNearbyPost:nil];        
        [self.dataTableView reloadData];
    }

    if ([self isReloading]){
        [self dataSourceDidFinishLoadingNewData];
    }
}

- (void)requestPostListFromServer
{
    double longitude;
    double latitude;
    
    LocationService* locationService = GlobalGetLocationService();
    longitude = locationService.currentLocation.coordinate.longitude;
    latitude = locationService.currentLocation.coordinate.latitude;
    
    LocalDataService* localService = GlobalGetLocalDataService();
    [localService requestNearbyPostData:self beforeTimeStamp:nil longitude:longitude latitude:latitude cleanData:YES];
        
}

- (void)initDataList
{
    NSString* userId = [UserManager getUserId];
    self.dataList = [PostManager getAllNearbyPost:userId];
    [self requestPostListFromServer];    
}

- (void)viewDidLoad
{
    supportRefreshHeader = YES;
    
    [self initDataList];
    
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidAppear:(BOOL)animated
{
    self.dataList = [PostManager getAllNearbyPost:nil]; 
    [super viewDidAppear:YES];
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
	
	return 55;
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
		
		if (cellTextLabelColor != nil)
			cell.textLabel.textColor = cellTextLabelColor;
		else
			cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
		
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
	}
	
	cell.accessoryView = accessoryView;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    //	[self setCellBackground:cell row:row count:count];        
	
	Post* dataObject = [dataList objectAtIndex:row];
    cell.textLabel.text = dataObject.textContent;
    cell.detailTextLabel.text = dataObject.userId;
	// PPContact* contact = (PPContact*)[groupData dataForSection:indexPath.section row:indexPath.row];	
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row > [dataList count] - 1)
		return;
	
	[self updateSelectSectionAndRow:indexPath];
	[self reloadForSelectSectionAndRow:indexPath];	
	
	// do select row action
    //	Post* post = [dataList objectAtIndex:indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row > [dataList count] - 1)
			return;
		
		// take delete action below, update data list
		// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];		
		
		// update table view
		
	}
	
}

#pragma Pull Refresh Delegate

- (void) reloadTableViewDataSource
{
    [self requestPostListFromServer];
}

@end
