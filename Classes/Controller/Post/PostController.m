//
//  PostController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostController.h"
#import "CreatePostController.h"

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
    [self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
    
    [self initActionToolbar];    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
            return 100;
            
        case SECTION_RELATED_POST:
            return 100;
            
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
		
		if (cellTextLabelColor != nil)
			cell.textLabel.textColor = cellTextLabelColor;
		else
			cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
		
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
	}
	
    switch (indexPath.section) {
        case SECTION_POST_ITSELF:
        {
            cell.textLabel.text = post.textContent;
            cell.detailTextLabel.numberOfLines = 3;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"By : %@\nDate : %@\nTotal Reply : %d",
                                         post.userId,
                                         [post.createDate description],
                                         [post.totalReply intValue]
                                         ];
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
            
            Post* postObj = [dataList objectAtIndex:row];

            cell.textLabel.text = postObj.textContent;
            cell.detailTextLabel.numberOfLines = 3;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"By : %@\nDate : %@\nTotal Reply : %d",
                                         postObj.userId,
                                         [postObj.createDate description],
                                         [postObj.totalReply intValue]
                                         ];
        
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
//    [self requestPostListFromServer];
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
