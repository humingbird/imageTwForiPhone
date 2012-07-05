//
//  ImageColor.h
//  ImageTwForIphone
//
//  Created by  on 12/07/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageColor : NSObject{
}
+(UIImage *)monochrome:(UIImage *)anImage;
+(UIImage *)sepia:(UIImage *)seImage;
//+(UIImage *)changeColor:(UIImage *)anImage type:(NSInteger *)num;
@end
