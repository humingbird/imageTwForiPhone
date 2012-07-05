//
//  SecondViewController.h
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageColor.h"

@interface SecondViewController:UIViewController
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>{
    
    BOOL isShow;
    IBOutlet UIImageView *image;
    IBOutlet UIButton *button;
    
    IBOutlet UIButton *monochrome;
    IBOutlet UIButton *sepia;
    IBOutlet UIButton *reset;
    
    UIImageView *iv;
    UIImage *preImage;
}
-(IBAction)doSave;
-(IBAction)changeMonoChrome;
-(IBAction)changeSepia;
-(IBAction)changeReset;

@end
