//
//  PostControllerUtils.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostControllerUtils.h"
#import "ResultUtils.h"
#import "Post.h"
#import "PostController.h"

@implementation PostControllerUtils

+ (void)setCellStyle:(UITableViewCell*)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;		    
    cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			

}

+ (void)setCellInfo:(UITableViewCell*)cell 
        textContent:(NSString*)textContent 
       userNickName:(NSString*)userNickName 
         createDate:(NSDate*)createDate
         totalReply:(int)totalReply
{
    cell.textLabel.text = textContent;
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"By : %@\nDate : %@\nTotal Reply : %d",
                                 userNickName,
                                 [createDate description],
                                 totalReply
                                 ];
    
}

+ (void)setCellInfoWithPost:(Post*)post cell:(UITableViewCell*)cell
{
    
    [PostControllerUtils setCellInfo:cell
                         textContent:post.textContent
                        userNickName:post.userNickName
                          createDate:post.createDate
                          totalReply:[post.totalReply intValue]];
    
}

+ (void)setCellInfoWithDict:(NSDictionary*)dict cell:(UITableViewCell*)cell
{
    [PostControllerUtils setCellInfo:cell
                         textContent:[ResultUtils textContent:dict]
                        userNickName:[ResultUtils nickName:dict]
                          createDate:[ResultUtils createDate:dict]
                          totalReply:[ResultUtils totalReply:dict]];
}

+ (void)gotoPostController:(UIViewController*)superController post:(Post*)post
{
    PostController *vc = [[PostController alloc] init];
    vc.post = post;
    superController.hidesBottomBarWhenPushed = YES;
    [superController.navigationController pushViewController:vc animated:YES];
    [vc release];

}

+ (CGFloat)getCellHeight
{
    return 100.0f;
}

@end
