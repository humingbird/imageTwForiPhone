//
//  AppDelegate.h
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    BOOL *is_login;
    BOOL is_show;
    NSString *user_id;
    NSString *loginStatus;
    
    UIImage *postImage;
    UIImage *preImage;
    BOOL isImage;
    NSString *imageUrl;
    NSArray *articleId;
}
@property(nonatomic,assign) BOOL *is_login;
@property(nonatomic,assign) BOOL is_show;
@property(nonatomic,assign) NSString *user_id;
@property(nonatomic,assign) NSString *loginStatus;
@property(nonatomic,assign) UIImage *postImage;
@property(nonatomic,assign) BOOL isImage;
@property(nonatomic,assign) NSString *imageUrl;
@property(nonatomic,assign) NSArray *articleId;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
