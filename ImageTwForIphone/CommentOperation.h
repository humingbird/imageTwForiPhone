//
//  CommentOperation.h
//  ImageTwForIphone
//
//  Created by  on 12/07/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentOperation : NSOperation{
    NSString *_comment;
    NSString *_cid;
    NSString *_user_id;
    NSNumber *_mode;
}

@end
