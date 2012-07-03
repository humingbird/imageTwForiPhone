//
//  SecondViewController.m
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "FormViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
//@synthesize showsCameraControls,cameraOverlayView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Photo", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(!isShow){
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"エラー" message:@"カメラが起動できませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        UITabBarController *controller = self.tabBarController;
        controller.selectedViewController = [controller.viewControllers objectAtIndex:0];
        return;
    }
    
   //カメラの起動
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = sourceType;
    ipc.mediaTypes = [NSArray arrayWithObject:@"public.image"];
    
    //カメラの撮影画面のボタンメニューを消す
    /*ipc.showsCameraControls = NO;
    
    //代わりのメニューバーを読み込んでくる(メニューバーの生成場所別にしたい）
    UIToolbar *tb_ipad = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 970, 1000, 120)];    
    ipc.cameraOverlayView = tb_ipad;
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"hoge" target:self action:@selector(hoge)];*/

    
    
    ipc.delegate = self;
    [self presentModalViewController:ipc animated:TRUE];
    [ipc release];
    isShow = TRUE;
    }
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isShow = FALSE;

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"撮影");
    
    //アプリ上のimageViewに撮影した画像の情報を渡す
    UIImage * aImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [image setImage:aImage];
        
    if([picker respondsToSelector:@selector(presentingViewController)]){
        [[picker presentingViewController] dismissModalViewControllerAnimated:YES];
    }else{
        [[picker presentViewController] dismissModalViewControllerAnimated:YES];
    }

}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"キャンセル");
    
    if([picker respondsToSelector:@selector(presentingViewController)]){
        [[picker presentingViewController] dismissModalViewControllerAnimated:YES];
    }else{
        [[picker presentViewController] dismissModalViewControllerAnimated:YES];
    }
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex:0];
    isShow = FALSE;
    return;
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存終了");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存終了" message:@"アルバムに写真を追加しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    //別画面遷移
    FormViewController *fvc =[[FormViewController alloc]initWithNibName:@"FormViewController" bundle:nil];
    [self presentModalViewController:fvc animated:YES];

    
}

 -(IBAction)doSave{
    NSLog(@"保存");
    
    UIImage *aImage = [image image];
    
    //画像データの保持
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
     appDelegate.postImage = aImage;
     
    /*if(aImage == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"写真を撮影してください" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
     */
     //別画面遷移
     FormViewController *fvc =[[FormViewController alloc]initWithNibName:@"FormViewController" bundle:nil];
     [self presentModalViewController:fvc animated:YES];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
