//
//  SubmitOperation.h
//  ImageTwForIphone
//
//  Created by  on 12/07/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface SubmitOperation : NSOperation{
    AppDelegate *appdelegate;
    NSMutableData *buffer;
    NSString *_filename;
    NSString *contents;
    NSString *comment;
    NSData *_imageData;
}
-(id) initWithFileName:(NSString *)text comment:(NSString *)c_text _imageData:(NSData *)image; 

@end
