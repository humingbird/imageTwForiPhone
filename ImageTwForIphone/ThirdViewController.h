//
//  ThirdViewController.h
//  ImageTwForIphone
//
//  Created by  on 12/07/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewCell.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "ImageLoad.h"
#import "SBJson.h"
#import "KeyChain.h"

@interface ThirdViewController : UIViewController{
    IBOutlet UINavigationItem *navi;
    IBOutlet UITableView *table;
    IBOutlet UIScrollView *scroll;
    
    Reachability *reachability;
    
    NSMutableArray *articleId;
    NSMutableArray *description;
    NSMutableArray *userName;
    NSMutableArray *imageUrl;
    
    AppDelegate *appdelegate;
    
}

@end
