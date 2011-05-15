//
//  CreatePostController.m
//  Dipan
//
//  Created by qqn_pipi on 11-5-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CreatePostController.h"
#import "CreatePostRequest.h"

@implementation CreatePostController
@synthesize syncSNSButton;
@synthesize selectPlaceButton;
@synthesize selectPhotoButton;
@synthesize selectCameraButton;
@synthesize contentTextView;
@synthesize photoArray;
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
    [photoArray release];
    [syncSNSButton release];
    [selectPlaceButton release];
    [selectPhotoButton release];
    [selectCameraButton release];
    [contentTextView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)createTitleToolbar
{    
    NSArray *items = [NSArray arrayWithObjects:NSLS(@"kTextContent"), NSLS(@"kPhotoContent"), nil]; 
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:items];
    
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segControl addTarget:self 
                   action:@selector(clickSegControl:) 
         forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segControl;    
    [segControl release];
}

- (void)initData
{
    syncSNSStatus = YES;
}

- (void)viewDidLoad
{
    [self initData];
    
    [self createTitleToolbar];
    [self setNavigationLeftButton:NSLS(@"Back") action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"kSavePost") action:@selector(clickSavePost:)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSyncSNSButton:nil];
    [self setSelectPlaceButton:nil];
    [self setSelectPhotoButton:nil];
    [self setSelectCameraButton:nil];
    [self setContentTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createPost:(int)contentType textContent:(NSString*)textContent
                     latitude:(double)latitude longitude:(double)longitude
                 userLatitude:(double)userLatitude userLongitude:(double)userLongitude
                      syncSNS:(BOOL)syncSNS placeId:(NSString*)placeId
{
    // TODO
    NSString* userId = @"test_user_id";
    NSString* appId = @"test_app_id";
    
    [self showActivityWithText:NSLS(@"kCreatingPost")];
    dispatch_async(workingQueue, ^{
        
        CreatePostOutput* output = [CreatePostRequest send:SERVER_URL 
                                                     userId:userId 
                                                      appId:appId 
                                                contentType:contentType 
                                                textContent:textContent 
                                                   latitude:latitude 
                                                  longitude:longitude 
                                               userLatitude:userLatitude 
                                              userLongitude:userLongitude 
                                                    syncSNS:syncSNS 
                                                    placeId:placeId];
        
        // For Test Only
        output.postId = [NSString stringWithInt:time(0)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // save post data locally
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

- (int)getContentType
{
    int contentType = CONTENT_TYPE_TEXT;
    if (photoArray != nil && [photoArray count] > 0){
        contentType = CONTENT_TYPE_TEXT_PHOTO;
    }
    
    return contentType;
}

- (void)clickSavePost:(id)sender
{
    int contentType = [self getContentType];
    NSString* textContent = contentTextView.text;
    
    double userLongitude = 113.11f;     // TBD
    double userLatitude = 153.22f;
    
    [self createPost:contentType textContent:textContent latitude:[place.latitude doubleValue] longitude:[place.longitude doubleValue] userLatitude:userLatitude userLongitude:userLongitude syncSNS:syncSNSStatus placeId:place.placeId];
}

- (void)clickSegControl:(id)sender
{
    NSLog(@"click seg control");
}

@end
