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

//画面が表示される度に呼び出される
-(void)viewWillAppear:(BOOL)animated{
    if(!isShow){
    UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:@"photo" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:@"カメラで撮影" otherButtonTitles:@"カメラロールの画像を使う", nil];
    [ac showInView:self.view];
    [ac release];
    }
}

//ActionSheetのボタンイベント
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==2){
        NSLog(@"return");
        isShow = FALSE;
        UITabBarController *controller = self.tabBarController;
        controller.selectedViewController = [controller.viewControllers objectAtIndex:0];
        return;

    }
    
    UIImagePickerControllerSourceType sourceType = 0;
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        default:
            break;
    }
    if(!isShow){
        //UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if(![UIImagePickerController isSourceTypeAvailable:sourceType]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"エラー" message:@"カメラが起動できませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            UITabBarController *controller = self.tabBarController;
            controller.selectedViewController = [controller.viewControllers objectAtIndex:0];
            isShow = FALSE;
            return;
        }
        
        //imagePicker
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

//初回ロード時
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
    preImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //画像加工していない元データの保持
    iv = [[UIImageView alloc]init];
    iv.hidden = YES;
    [iv setImage:preImage];

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
     
    if(aImage == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"画像を選択してください" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
     
     //別画面遷移
     FormViewController *fvc =[[FormViewController alloc]initWithNibName:@"FormViewController" bundle:nil];
     [self presentModalViewController:fvc animated:YES];
}

//画像をモノクロにする
-(IBAction)changeMonoChrome{
    UIImage *aImage = [iv image];
    UIImage *changedImage;
    changedImage = [ImageColor monochrome:aImage];
    [image setImage:changedImage];
    [changedImage release];
}

//画像をセピアにする
-(IBAction)changeSepia{
    UIImage *aImage = [iv image];
    UIImage *changedImage;
    changedImage = [ImageColor sepia:aImage];
    [image setImage:changedImage];

}

//元の画像に戻す
-(IBAction)changeReset{
    UIImage *aImage = [iv image];
    [image setImage:aImage];
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
