//
//  PrivateMessageTableViewCell.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PrivateMessageTableViewCell : UITableViewCell {
    
}

+ (NSString*)getCellIdentifier;
+ (PrivateMessageTableViewCell*)createCell;
+ (CGFloat)getCellHeight;

@end
