//
//  FirstViewController.h
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "FirstViewCell.h"
#import "ImageLoad.h"
#import "SBJson.h"
#import "KeyChain.h"
#import "LoginViewController.h"
#import "IineOperation.h"
#import "IineDeleteOparation.h"
//#import "ListOperation.h"

@interface FirstViewController : UIViewController{
    IBOutlet UITableView *table;
    IBOutlet UIScrollView *scroll;
    IBOutlet UINavigationItem *navi;
    
    //BOOL toggleButtonEnabled;
    
    Reachability *reachability;
    
    NSMutableArray *articleId ;    
    NSMutableArray *imageUrl;    
    NSMutableArray *description;
    NSMutableArray *userName;
    NSMutableArray *iine;
    NSMutableArray *iineUser;
    NSMutableArray *iineCount;
    
    AppDelegate *appdelegate;
}
@end
