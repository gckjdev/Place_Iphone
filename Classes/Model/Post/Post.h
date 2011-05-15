//
//  Post.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * textContent;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * contentType;
@property (nonatomic, retain) NSDate   * createDate;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * totalView;
@property (nonatomic, retain) NSNumber * totalForward;
@property (nonatomic, retain) NSNumber * totalQuote;
@property (nonatomic, retain) NSNumber * totalReply;

@end
