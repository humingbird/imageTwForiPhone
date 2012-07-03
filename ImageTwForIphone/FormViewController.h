//
//  FormViewController.h
//  ImageTwForIphone
//
//  Created by  on 12/06/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FormViewController : UIViewController{
    //IBOutlet UIImageView *imageView;
    IBOutlet UINavigationItem *navi;
    IBOutlet UITextField *comment;
    
    //NSHTTPURLResponse *hres;
    //NSMutableData *buffer;
    //NSString *contents;
    AppDelegate *appDelegate;
    
    
}

@end
