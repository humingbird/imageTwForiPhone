//
//  FormViewController.m
//  ImageTwForIphone
//
//  Created by  on 12/06/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FormViewController.h"
#import "AppDelegate.h"
#import "SubmitOperation.h"
#import "FirstViewController.h"

@interface FormViewController ()

@end

@implementation FormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //ボタンのイベント設定
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doSave:)];
    navi.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(doReply:)];
    navi.leftBarButtonItem = backButton;
    
    //登録したい画像の取得
    appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];    
    // Do any additional setup after loading the view from its nib.
}

//登録処理
-(void)doSave:(id)sender{
    
    reachability = [Reachability reachabilityWithHostName:@"49.212.148.198"];
    NetworkStatus  status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ネットワークエラー" message:@"圏外なので投稿できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
    NSLog(@"登録処理しますよ");    
    //ipadの画像サイズがでかすぎて読み込みに時間がかかりすぎるので、暫定的に決めうちリサイズ
    UIImage *defaultImage = appDelegate.postImage;
    CGSize size = CGSizeMake(300, 300);
    UIImage *resizeImage;
    UIGraphicsBeginImageContext(size);
    [defaultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetImageFromCurrentImageContext();
    
    //画像データの取得
    NSData *imageData = [[NSData alloc]initWithData:UIImageJPEGRepresentation(resizeImage, 0.8f)];
    //名前は現在時刻から取る。    
    NSDateFormatter *format = [[[NSDateFormatter alloc]init]autorelease];
    [format setTimeStyle:NSDateFormatterFullStyle];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* date = [NSDate date];
    NSString* dateStr =[format stringFromDate:date];
    
    //ファイル名
    NSString* fileName = [NSString stringWithFormat:@"%@%@",dateStr,@".jpg"];
    
    //パスの作成
    NSString* path = [NSString stringWithFormat:@"%@/%@",
                      [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],fileName];
    NSLog(@"%@",path);
    
    //フォームのテキストデータの取得(comment.text)で取得できる。
    [comment resignFirstResponder];
        NSString *text = comment.text;
    //画像ファイルをサーバに保存する
    //戻ってきたURLと一緒にテキストデータ情報も一緒に登録
    NSOperationQueue *queue =[NSOperationQueue mainQueue];
    [queue setMaxConcurrentOperationCount:1];
    SubmitOperation *ope1 = [[SubmitOperation alloc]initWithFileName:fileName comment:(NSString *)text _imageData:(NSData *)imageData];
    SubmitOperation *ope2 = [[SubmitOperation alloc]initWithFileName:fileName comment:(NSString *)text _imageData:(NSData *)imageData];
    [queue addOperation:ope1];
    [queue addOperation:ope2];
    //ローカルにも画像ファイルを保存
    UIImageWriteToSavedPhotosAlbum(resizeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //登録が全部うまく行ったらうまくいったよ処理
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登録処理完了" message:@"登録が完了しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    //タブを切り替えて、最初のページを表示する（今は撮影画面に戻るだけ）
    }
    [self dismissModalViewControllerAnimated:YES];
    appDelegate.is_show = FALSE;

}

//ローカル保存時のエラー処理
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error){
        NSLog(@"saving the image is complete");
    }else{
        NSLog(@"Faild to save the image");
    }
}

//編集画面にもどる
-(void)doReply:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
