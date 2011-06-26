//
//  PrivateMessageTableViewCell.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PrivateMessageTableViewCell.h"


@implementation PrivateMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"PrivateMessageCell";
}

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		   
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
}

- (void)awakeFromNib{
    [self setCellStyle];
}

+ (PrivateMessageTableViewCell*)createCell
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PrivateMessageCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"<createPrivateMessageTableViewCell> but cannot find cell object");
        return nil;
    }
        
    return (PrivateMessageTableViewCell*)[topLevelObjects objectAtIndex:0];
}

+ (CGFloat)getCellHeight
{
    return 60;
}

@end
