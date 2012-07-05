//
//  ImageLoad.h
//  ImageTwForIphone
//
//  Created by  on 12/07/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kConnectionDidFinishNotification @"connectionDidFinishNotification"

@interface ImageLoad : NSObject{
    NSMutableData *data;
    NSString *path;
    NSIndexPath *indexPath;
}
@property (retain,readonly)NSMutableData *data;
@property(retain)NSString *path;
@property(retain)NSIndexPath *indexPath;
-(void)connectionWithPath:(NSString *)filePath;

@end
