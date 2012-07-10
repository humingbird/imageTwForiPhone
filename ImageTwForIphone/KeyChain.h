//
//  KeyChain.h
//  ImageTwForIphone
//
//  Created by  on 12/07/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "AppDelegate.h"

@interface KeyChain : NSObject{
    AppDelegate *appdelegate;
}
+(void)create:(NSString *)password username:(NSString *)username;
+(NSDictionary *)getUserInfo;
+(void)delete;

@end
