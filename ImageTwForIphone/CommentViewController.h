//
//  CommentViewController.h
//  ImageTwForIphone
//
//  Created by  on 12/07/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommentOperation.h"
#import "SBJson.h"

@interface CommentViewController : UIViewController{
    IBOutlet UINavigationItem *navi;
    IBOutlet UITableView *table;
    IBOutlet UIScrollView *scroll;
    
    IBOutlet UIView *postView;
    IBOutlet UITextField *textFiled;
    IBOutlet UIButton *post;
    
    NSMutableArray *articleComment;
    NSMutableArray *username;
    
    BOOL _observing;
    
    AppDelegate *appdelegate;
}
-(IBAction)doPost:(id)sender;
-(id)initWithInt:(int)value;

@end
