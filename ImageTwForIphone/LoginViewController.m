//
//  LoginViewController.m
//  ImageTwForIphone
//
//  Created by  on 12/07/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    tableView.dataSource = self;
    tableView.delegate = self;
    
    //ナビゲーションバーにボタンの追加
    UIBarButtonItem *create = [[UIBarButtonItem alloc]initWithTitle:@"新規登録" style:UIBarButtonSystemItemDone target:self action:@selector(doCreate:)];
    navi.leftBarButtonItem = create;
    
    UIBarButtonItem *login = [[UIBarButtonItem alloc]initWithTitle:@"ログイン" style:UIBarButtonSystemItemDone target:self action:@selector(doLogin:)];
    navi.rightBarButtonItem = login;
    
    
    tableView.allowsSelection =NO;
    
    
    
    // Do any additional setup after loading the view from its nib.
}

//セクション数の設定
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//セクションごとのセルの数の設定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//セクションのヘッダー
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"ユーザーID";
    }else {
        return @"パスワード";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc]initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]autorelease];
        
        /*if([indexPath row] == 0){
            usernameField = [[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 30)]autorelease];
            usernameField.returnKeyType = UIReturnKeyDone;
            usernameField.delegate = self;
            [cell.contentView addSubview:self.usernameField];
        }else if([indexPath row] == 1){
            passwordField = [[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 30)]autorelease];
            passwordField.secureTextEntry = YES;
            passwordField.returnKeyType = UIReturnKeyDone;
            passwordField.delegate = self;
            [cell.contentView addSubview:self.passwordField];
        }*/
        //ユーザー名とパスワードを入力するtextfieldを追加
        UITextField * textField = [[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 30)]autorelease];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.tag = indexPath.section;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.secureTextEntry = (indexPath.section ==1);
    
        [cell.contentView addSubview:textField];
    }
    return cell;
}

//キーボードを隠す
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//テキストの編集が終わった直後に働く
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == 0){
        username = textField.text;
    }else if(textField.tag == 1){
        password = textField.text;
    }
}

//新規登録処理
-(void)doCreate:(id)sender{
    //入力内容が空の場合はalertを出して返す
    if([username length] == 0 || [password length] == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登録エラー" message:@"ユーザID,またはパスワードが入力されていません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //パスワードは暗号化
    NSString *sample = [self NSStringToSha1String:password];
    //暗号化したものをpost
   [self sendPostUserCreate:username password:sample];
    NSLog(@"userCreate is success user_id =%@",appdelegate.user_id);
    //keychainに情報を保存する
    [KeyChain create:password username:username];
    appdelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.user_name = username;
    //ユーザIDが取れたらこのページを閉じる
    [self dismissModalViewControllerAnimated:YES];
}

//ログイン
-(void)doLogin:(id)sender{
    [self sendPostUser:username password:password];
    //keyChainに情報を保存する
    NSLog(@"%@",appdelegate.loginStatus);
    if([appdelegate.loginStatus isEqualToString:@"1"]){
        [KeyChain create:password username:username];
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.user_name = username;
        [self dismissModalViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ログインエラー" message:@"ユーザid,またはパスワードが間違っています" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
}

//keyChainにデータがある場合はそれを使って勝手にログイン(TODO:認証できなかった場合のエラー処理が必要）
+(void)autoLogin:(NSDictionary *)userInfo{
    if(userInfo !=nil){
        NSString *userName = [userInfo objectForKey:@"username"];
        NSString *password = [userInfo objectForKey:@"password"];
    
        LoginViewController *lvc = [[[LoginViewController alloc]init]autorelease];
        [lvc sendPostUser:userName password:password];
    
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appdelegate.loginStatus isEqualToString:@"1"]){
            appdelegate.user_name = userName;
            [lvc dismissModalViewControllerAnimated:YES];
        }
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//新規登録用のpost処理
-(void)sendPostUserCreate:(NSString *)username password:(NSString *)password{
    NSLog(@"UserCreate start");
    NSString *boundary = @"1111";
    NSMutableData *requestData =[[NSMutableData alloc]init];
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userName\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",username] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",password] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];    
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString *urlstr = @"http://49.212.148.198/imagetw/userCreate.php";
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLResponse *responce = nil;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&error];
    
    if(error == nil){
        NSString *responceString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responceString);
        NSDictionary *result = [responceString JSONValue];
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.user_id = [result objectForKey:@"id"];
        appdelegate.is_login = TRUE;
        [responceString release];
    }
}

//ログインpost
-(void)sendPostUser:(NSString *)username password:(NSString *)password{
    NSLog(@"UserLogin start");
    NSString *boundary = @"1111";
    NSMutableData *requestData =[[NSMutableData alloc]init];
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userName\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",username] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",password] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];    
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString *urlstr = @"http://49.212.148.198/imagetw/user.php";
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLResponse *responce = nil;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&error];
    
    if(error == nil){
        NSString *responceString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responceString);
        NSDictionary *result = [responceString JSONValue];
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.loginStatus = [[result objectForKey:@"login"]stringValue];
        appdelegate.user_id = [result objectForKey:@"id"];
        appdelegate.is_login = TRUE;
        [responceString release];
    }
}


-(NSString *)NSStringToSha1String:(NSString *)sourceString{
    const char *cStr = [sourceString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char sha1_cStr[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, strlen(cStr), sha1_cStr);
    
    char tmp[3];
    NSMutableString *result =[[[NSMutableString alloc]init]autorelease];
    for(int i=0;i< CC_SHA1_DIGEST_LENGTH;i++){
        tmp[0] = tmp[1] = tmp[2] = 0;
        sprintf(tmp, "%02x",sha1_cStr[i]);
        [result appendString:[NSString stringWithUTF8String:tmp]];
    }
    return result;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
