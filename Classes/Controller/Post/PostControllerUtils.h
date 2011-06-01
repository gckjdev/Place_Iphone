//
//  PostControllerUtils.h
//  Dipan
//
//  Created by qqn_pipi on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post;

@interface PostControllerUtils : NSObject {
    
}

+ (void)setCellStyle:(UITableViewCell*)cell;
+ (void)setCellInfoWithDict:(NSDictionary*)dict cell:(UITableViewCell*)cell;
+ (void)setCellInfoWithPost:(Post*)post cell:(UITableViewCell*)cell;
+ (void)gotoPostController:(UIViewController*)superController post:(Post*)post;

@end
