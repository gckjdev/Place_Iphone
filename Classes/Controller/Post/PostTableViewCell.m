//
//  PostTableViewCell.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostTableViewCell.h"
#import "Post.h"
#import "ResultUtils.h"
#import "LocaleUtils.h"
#import <Three20/Three20.h>
#import "HJManagedImageV.h"
#import "DipanAppDelegate.h"
#import "TimeUtils.h"
#import "UIImageUtil.h"
#import "ContollerConstants.h"


@implementation PostTableViewCell

@synthesize userAvatarImage;
@synthesize userNickNameLabel;
@synthesize createDateLabel;
@synthesize textContentLabel;
@synthesize totalReplyLabel;
@synthesize contentImage;
@synthesize placeNameButton;
@synthesize placeNameLabel;
@synthesize indexPath;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;		   
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [userAvatarImage release];
    [userNickNameLabel release];
    [createDateLabel release];
    [textContentLabel release];
    [totalReplyLabel release];
    [contentImage release];
    [placeNameLabel release];
    [placeNameButton release];
    [indexPath release];
    [userAvatarButton release];
    [super dealloc];
}

+ (PostTableViewCell*)createCell:(id<PostTableViewCellDelegate>)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"<createPostTableViewCell> but cannot find cell object");
        return nil;
    }
    
    ((PostTableViewCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (PostTableViewCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"PostCommonCell";
}

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		   
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
}

- (void)awakeFromNib{
    [self setCellStyle];
}

- (BOOL)exist:(NSString*)image
{
    return (image != nil && [image length] > 0);
}

- (NSURL*)bundleURL:(NSString*)filename
{
	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
	NSURL* url = [NSURL fileURLWithPath:path];	    
    return url;
}

// TODO : move as common utils
- (NSString*)getDateDisplayText:(NSDate*)date
{
    if (date == nil)
        return @"";
    
    int second = abs([date timeIntervalSinceNow]);
    
    if (second < 60){
        return [NSString stringWithFormat:NSLS(@"kDateBySecond"), second];
    }
    else if (second < 60*60){
        return [NSString stringWithFormat:NSLS(@"kDateByMinute"), second/(60)];        
    }
    else if (second < 60*60*24){
        return [NSString stringWithFormat:NSLS(@"kDateByHour"), second/(60*60)];                
    }
    else if (second < 60*60*24*3){
        return [NSString stringWithFormat:NSLS(@"kDateByDay"), second/(60*60*24)];                
    }
    else{
        return dateToStringByFormat(date, @"yyyy-MM-dd");                               
    }    
}

- (void)setCellInfoWithTextContent:(NSString*)textContent 
                      userNickName:(NSString*)userNickName 
                        createDate:(NSDate*)createDate
                        totalRelated:(int)totalRelated
                        userAvatar:(NSString*)userAvatar
                      contentImage:(NSString*)imageURL
                         placeName:(NSString*)placeName
                       indexPath:(NSIndexPath*)indexPathValue

{
    self.indexPath = indexPathValue;
    
    [self.placeNameButton setTitle:placeName forState:UIControlStateNormal];
    
    self.userNickNameLabel.text = userNickName;    
    self.textContentLabel.text = textContent;
    if (totalRelated > 1){
        self.totalReplyLabel.text = [NSString stringWithFormat:NSLS(@"kTotalRelated"), totalRelated-1];
    }
    else{
        self.totalReplyLabel.text = [NSString stringWithFormat:NSLS(@"kTotalRelated"), 0];
    }
    
    self.createDateLabel.text = [self getDateDisplayText:createDate];
    
    [self.userAvatarImage clear];
    if ([self exist:userAvatar]){
        self.userAvatarImage.url = [NSURL URLWithString:userAvatar];
    }
    else{
        self.userAvatarImage.url = [self bundleURL:DEFAULT_AVATAR];
    }
    [GlobalGetImageCache() manage:self.userAvatarImage];

    [self.contentImage clear];
    if ([self exist:imageURL]){
        NSString* thumbImageURL = [imageURL stringByReplacingOccurrencesOfString:@".png" withString:@"_s.png"]; // hard code ,no good here
        thumbImageURL = [imageURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"];
        self.contentImage.url = [NSURL URLWithString:thumbImageURL];
        self.contentImage.callbackOnSetImage = self;
        [GlobalGetImageCache() manage:self.contentImage];
    }
    
    
}

-(void) managedImageSet:(HJManagedImageV*)mi
{
    CGRect origRect = self.contentImage.frame;    
    self.contentImage.frame = [UIImage shrinkFromOrigRect:origRect imageSize:mi.image.size];    
}

- (void)setCellInfoWithPost:(Post*)post indexPath:(NSIndexPath*)indexPathValue
{
    
    [self setCellInfoWithTextContent:post.textContent
                        userNickName:post.userNickName
                          createDate:post.createDate
                          totalRelated:[post.totalRelated intValue]
                          userAvatar:post.userAvatar
                        contentImage:post.imageURL
                           placeName:post.placeName
                           indexPath:indexPathValue];
    
}

- (void)setCellInfoWithDict:(NSDictionary*)dict indexPath:(NSIndexPath*)indexPathValue
{
    [self setCellInfoWithTextContent:[ResultUtils textContent:dict]
                        userNickName:[ResultUtils nickName:dict]
                          createDate:[ResultUtils createDate:dict]
                          totalRelated:[ResultUtils totalRelated:dict]
                          userAvatar:[ResultUtils userAvatar:dict]
                        contentImage:[ResultUtils imageURL:dict]
                           placeName:[ResultUtils placeName:dict]
                           indexPath:indexPathValue
     
     ];
}

+ (CGFloat)getCellHeight
{
    return 130.0f;
}

-(void) managedImageCancelled:(HJManagedImageV*)mi
{
    
}

- (IBAction)clickPlaceNameButton:(id)sender
{
    if (delegate != nil && [delegate respondsToSelector:@selector(clickPlaceNameButton:atIndexPath:)]){
        [delegate clickPlaceNameButton:sender atIndexPath:indexPath];
    }
}

- (IBAction)clickUserAvatarButton:(id)sender
{
    if (delegate != nil && [delegate respondsToSelector:@selector(clickUserAvatarButton:atIndexPath:)]){
        [delegate clickUserAvatarButton:sender atIndexPath:indexPath];
    }
    
}


@end
