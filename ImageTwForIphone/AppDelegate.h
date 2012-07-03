//
//  AppDelegate.h
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    UIImage *postImage;
    BOOL isImage;
    NSString *imageUrl;
}
@property(nonatomic,assign) UIImage *postImage;
@property(nonatomic,assign) BOOL isImage;
@property(nonatomic,assign) NSString *imageUrl;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
