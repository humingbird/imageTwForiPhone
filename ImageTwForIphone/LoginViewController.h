//
//  LoginViewController.h
//  ImageTwForIphone
//
//  Created by  on 12/07/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "AppDelegate.h"
#import "KeyChain.h"
#import "SBJson.h"

@interface LoginViewController : UIViewController{
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationItem *navi;

    AppDelegate *appdelegate;
    
    NSString *username;
    NSString *password;
}
-(void)doCreate:(id)sender;
-(void)doLogin:(id)sender;
+(void)autoLogin:(NSDictionary *)userInfo;
@end
