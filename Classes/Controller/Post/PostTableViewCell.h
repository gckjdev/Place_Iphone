//
//  PostTableViewCell.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"

@class Post;

@interface PostTableViewCell : UITableViewCell <HJManagedImageVDelegate> {
    
    HJManagedImageV *userAvatarImage;
    UILabel *userNickNameLabel;
    UILabel *createDateLabel;
    UILabel *textContentLabel;
    UILabel *totalReplyLabel;
    HJManagedImageV *contentImage;
}
@property (nonatomic, retain) IBOutlet HJManagedImageV *userAvatarImage;
@property (nonatomic, retain) IBOutlet UILabel *userNickNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *createDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *textContentLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalReplyLabel;
@property (nonatomic, retain) IBOutlet HJManagedImageV *contentImage;

+ (PostTableViewCell*)createCell;
+ (NSString*)getCellIdentifier;

- (void)setCellInfoWithDict:(NSDictionary*)dict;
- (void)setCellInfoWithPost:(Post*)post;
+ (CGFloat)getCellHeight;

@end
