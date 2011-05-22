//
//  PlaceMainController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-11.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "PlaceMainController.h"
#import "CreatePlaceController.h"
#import "PlaceManager.h"
#import "Place.h"
#import "PostListController.h"
#import "UserManager.h"
#import "DipanAppDelegate.h"

#define kNearbyUpdateDate           @"kNearbyUpdateDate"
#define kUserPlaceUpdateDate        @"kUserPlaceUpdateDate"

enum SELECT_INDEX {
    SELECT_NEARBY = 0,
    SELECT_FOLLOW = 1
};

@implementation PlaceMainController

@synthesize createPlaceButton;
@synthesize createPlaceController;
@synthesize nearbyPlaceList;
@synthesize userPlaceList;
@synthesize nearbyUpdateDate;
@synthesize userPlaceUpdateDate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)createTitleToolbar
{    
    NSArray *items = [NSArray arrayWithObjects:NSLS(@"kAroundPlace"), NSLS(@"kMyPlace"), nil]; 
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:items];
    
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segSelectIndex = SELECT_NEARBY;
    segControl.selectedSegmentIndex = segSelectIndex;
    [segControl addTarget:self 
                   action:@selector(clickSegControl:) 
         forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segControl;    
    [segControl release];
}

- (void)showTableOrButton
{
    if (self.dataList == nil || [self.dataList count] == 0){
        dataTableView.hidden = YES;
        createPlaceButton.hidden = NO;
    }    
    else{
        dataTableView.hidden = NO;
        createPlaceButton.hidden = YES;
    }
}

// set the right data source and reload table view
- (void)setDataListBySelection
{
    if (segSelectIndex == SELECT_FOLLOW){
        self.dataList = self.userPlaceList;
    }
    else{
        self.dataList = self.nearbyPlaceList;
    }
}

- (void)updateTableRefreshViewDate
{
    if (segSelectIndex == SELECT_FOLLOW){
        [refreshHeaderView setLastRefreshDate:userPlaceUpdateDate];
    }
    else{
        [refreshHeaderView setLastRefreshDate:nearbyUpdateDate];
    }    
}

- (void)saveNearbyUpdateDate
{
    self.nearbyUpdateDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:nearbyUpdateDate forKey:kNearbyUpdateDate];
}

- (void)saveUserPlaceUpdateDate
{
    self.userPlaceUpdateDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:userPlaceUpdateDate forKey:kUserPlaceUpdateDate];
}

- (void)nearbyPlaceDataRefresh:(int)result // refresh done
{
    NSLog(@"nearbyPlaceDataRefresh, result=%d", result);    
    if (result == 0){   // success        
        [self saveNearbyUpdateDate];                                
        self.nearbyPlaceList = [PlaceManager getAllPlacesNearby];
        [self setDataListBySelection];
    }
    
    // refresh UI    
    [self updateTableRefreshViewDate];
    if ([self isReloading] && segSelectIndex == SELECT_NEARBY){
        [self dataSourceDidFinishLoadingNewData];
        [self.dataTableView reloadData];
    }
    else if (segSelectIndex == SELECT_NEARBY){
        [self.dataTableView reloadData];
    }
}

- (void)getNearbyPlace:(NSString*)userId
{
    LocalDataService* dataService = GlobalGetLocalDataService();
    [dataService requestNearbyPlaceData:self];
}

- (void)loadData
{
    NSString* userId = [UserManager getUserId];
    
    self.userPlaceList = [PlaceManager getAllFollowPlaces:userId];
    
    self.nearbyPlaceList = [PlaceManager getAllPlacesNearby];
    if (self.nearbyPlaceList == nil || [self.nearbyPlaceList count] == 0){
        [self getNearbyPlace:userId];
    }            
}

- (void)refreshDataListFromServer
{
    NSString* userId = [UserManager getUserId];;
    if (segSelectIndex == SELECT_NEARBY){
        [self getNearbyPlace:userId];
    }
    else{
    }    
}

- (void)initDataList
{
    [self loadData];
    [self setDataListBySelection];
    [self.dataTableView reloadData];
    [self showTableOrButton];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    supportRefreshHeader = YES;
    
    segSelectIndex = SELECT_NEARBY;
    
    [self.createPlaceButton setTitle:NSLS(@"kCreatePlace") forState:UIControlStateNormal];
    [self createTitleToolbar];
    [self setNavigationRightButton:NSLS(@"kCreatePlace") action:@selector(clickCreatePlaceButton:)];
        
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initDataList];
    [super viewDidAppear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
    if (self.navigationController.topViewController != self.createPlaceController){
        self.createPlaceController = nil;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [createPlaceButton release];
    [createPlaceController release];
    [nearbyPlaceList release];
    [userPlaceList release];
    [nearbyUpdateDate release];
    [userPlaceUpdateDate release];
    [super dealloc];
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
    
    
	
	Place* dataObject = [dataList objectAtIndex:row];
    cell.textLabel.text = dataObject.name;
    cell.detailTextLabel.text = dataObject.desc;
	// PPContact* contact = (PPContact*)[groupData dataForSection:indexPath.section row:indexPath.row];	
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row > [dataList count] - 1)
		return;
	
	// do select row action
	Place* place = [dataList objectAtIndex:indexPath.row];
    
    PostListController* postListController = [[PostListController alloc] init];
    postListController.place = place;
    [self.navigationController pushViewController:postListController animated:YES];
    [postListController release];
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
    [self refreshDataListFromServer];        
}

#pragma Title ToolBar Button Actions

- (void)clickSegControl:(id)sender
{
//    NSLog(@"click seg control");
    
    UISegmentedControl* segControl = sender;
    segSelectIndex = segControl.selectedSegmentIndex;

    if ([self isReloading]){
        [self dataSourceDidFinishLoadingNewData];
    }

    [self setDataListBySelection];
    [self.dataTableView reloadData];
}

- (void)clickCreatePlaceButton:(id)sender
{
    if (createPlaceController == nil){
        self.createPlaceController = [[CreatePlaceController alloc] init];    
    }
    
    [self.navigationController pushViewController:createPlaceController animated:YES];
}


@end
