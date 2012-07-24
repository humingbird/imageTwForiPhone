//
//  SecondViewController.m
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "FormViewController.h"

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
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

//画面が表示される度に呼び出される
-(void)viewWillAppear:(BOOL)animated{
    if(!appdelegate.is_show){
    
        //ActionSheetの呼び出し
        UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:@"photo" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:@"カメラで撮影" otherButtonTitles:
                @"カメラロールの画像を使う", nil];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            [ac showFromBarButtonItem:self.tabBarItem animated:YES];
        }else{
            [ac showInView:self.view];
        }
            [ac release];
    }
}

//ActionSheetのボタンイベント
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==2){
        NSLog(@"return");
        appdelegate.is_show = FALSE;
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
    if(!appdelegate.is_show){
        //UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if(![UIImagePickerController isSourceTypeAvailable:sourceType]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"エラー" message:@"カメラが起動できませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            UITabBarController *controller = self.tabBarController;
            controller.selectedViewController = [controller.viewControllers objectAtIndex:0];
            appdelegate.is_show = FALSE;
            return;
        }
        
        //imagePicker
        ipc = [[[UIImagePickerController alloc]init]autorelease];
        ipc.sourceType = sourceType;
        ipc.mediaTypes = [NSArray arrayWithObject:@"public.image"];
        ipc.delegate = self;
        
        //iPadではUIImagePickerControllerを直に呼ぶと落ちるので、UIPopoverControllerに乗っけて表示
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            NSLog(@"----- ipad mode----");
            
            if(popoverController){
                NSLog(@"-------- popoverController isPopoverVisible ----------");
                if([popoverController isPopoverVisible]){
                    [popoverController dismissPopoverAnimated:YES];
                }
            }
            popoverController = [[UIPopoverController alloc] initWithContentViewController:ipc];
            popoverController.delegate = self;
            [popoverController presentPopoverFromBarButtonItem:self.tabBarItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            appdelegate.is_show = TRUE;
        }else{
            NSLog(@"-----iphone mode-----");
            [self presentModalViewController:ipc animated:TRUE];
            //[ipc release];
            appdelegate.is_show = TRUE;
        }
        //カメラの撮影画面のボタンメニューを消す
        /*ipc.showsCameraControls = NO;
         
         //代わりのメニューバーを読み込んでくる(メニューバーの生成場所別にしたい）
         UIToolbar *tb_ipad = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 970, 1000, 120)];    
         ipc.cameraOverlayView = tb_ipad;
         UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"hoge" target:self action:@selector(hoge)];*/
        
    }

    
}

//初回ロード時
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isShow = FALSE;
    
    //リセットボタン
    UIBarButtonItem *reset = [[UIBarButtonItem alloc]initWithTitle:@"取り消し" style:UIBarButtonSystemItemCancel target:self action:@selector(doReset:)];
    navi.leftBarButtonItem = reset;
    [reset release];

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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        [popoverController dismissPopoverAnimated:YES];
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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        [popoverController dismissPopoverAnimated:YES];
    }
    appdelegate.is_show = FALSE;
    return;
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存終了");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存終了" message:@"アルバムに写真を追加しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    //別画面遷移
    FormViewController *fvc =[[FormViewController alloc]initWithNibName:@"FormViewController" bundle:nil];
    [self presentModalViewController:fvc animated:YES];

    [fvc release];
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
        [alert release];
        return;
    }
     
     //別画面遷移
     FormViewController *fvc =[[FormViewController alloc]initWithNibName:@"FormViewController" bundle:nil];
     [self presentModalViewController:fvc animated:YES];
     [fvc release];
}

//画像をモノクロにする
-(IBAction)changeMonoChrome{
    UIImage *aImage = [iv image];
    UIImage *changedImage;
    changedImage = [ImageColor monochrome:aImage];
    [image setImage:changedImage];
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

//取り消し処理
-(void)doReset:(id)sender{
    //一応戻るかどうか聞く。alert内のボタンイベントを取得したいのでcustomAlertViewを使う
    alertMode = 1;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取り消し処理" message:@"編集中の画像を削除しますか？" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:@"いいえ", nil];
    [alert show];
    [alert release];

}

/**
 UIAlertViewのボタンのデリゲート
 alertModeは複数のAlertViewが存在する場合に、引きずられて処理が行われないようにするため
*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertMode) {
        case 1:
            if(buttonIndex == 0){
                //UIImageViewに乗ってるimageの削除
                [image setImage:nil];
                //自分の投稿一覧タブに切り替える
                UITabBarController *tbc = self.tabBarController;
                tbc.selectedViewController = [tbc.viewControllers objectAtIndex:0];
                appdelegate.is_show = FALSE;
                self.tabBarController.tabBar.userInteractionEnabled = YES;
                return;
            }
            break;
            
        default:
            break;
    }
}

//popoverが消えた後の処理
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"------ popover closed-------");
    //自分の投稿一覧タブに切り替える
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex:0];
    appdelegate.is_show = FALSE;
    return;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    appdelegate.is_show = FALSE;
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
