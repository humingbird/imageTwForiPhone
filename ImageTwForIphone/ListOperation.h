//
//  ListOperation.h
//  ImageTwForIphone
//
//  Created by  on 12/07/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
//#import "SBJson.h"

@interface ListOperation : NSOperation{
    AppDelegate *appdelegate;
    NSMutableData *buffer;
}

@end
