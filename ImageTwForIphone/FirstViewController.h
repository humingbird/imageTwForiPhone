//
//  FirstViewController.h
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FirstViewCell.h"
#import "ImageLoad.h"
#import "SBJson.h"
//#import "ListOperation.h"

@interface FirstViewController : UIViewController{
    IBOutlet UITableView *table;
    IBOutlet UIScrollView *scroll;
    NSMutableArray *articleId ;    
    NSMutableArray *imageUrl;    
    NSMutableArray *description;
    AppDelegate *appdelegate;
}

@end
