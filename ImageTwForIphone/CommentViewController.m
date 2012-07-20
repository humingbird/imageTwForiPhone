//
//  CommentViewController.m
//  ImageTwForIphone
//
//  Created by  on 12/07/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!_observing){
        NSNotificationCenter *center;
        center =[NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        _observing = YES;
    }
    //画面を開いたらカーソルがあうように設定
    //textFiled.returnKeyType = UIReturnKeyDone;
    //[textFiled becomeFirstResponder];    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(_observing){
        NSNotificationCenter *center;
        center =[NSNotificationCenter defaultCenter];
        [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        _observing = NO;
    }
}

-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary *userInfo = nil;
    [notification userInfo];
    
    CGFloat overlap;
    CGRect keybordFrame;
    CGRect textviewFrame;
    
    keybordFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    keybordFrame = [scroll.superview convertRect:keybordFrame fromView:nil];
    textviewFrame = scroll.frame;
    overlap = MAX(0.0f, CGRectGetMaxY(textviewFrame)-CGRectGetMinY(keybordFrame));
    
    UIEdgeInsets insets;
    insets = UIEdgeInsetsMake(0.0f, 0.0f, overlap, 0.0f);
    
    NSTimeInterval duration;
    UIViewAnimationCurve animationCurve;
    void(^animations)(void);
    duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    animations = ^(void){
        scroll.contentInset = insets;
        scroll.scrollIndicatorInsets = insets;
    };
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve <<16) animations:animations completion:nil];
    
    CGRect rect;
    rect.origin.x = 0.0f;
    rect.origin.y = scroll.contentSize.height - 1.0f;
    rect.size.width = CGRectGetWidth(scroll.frame);
    rect.size.height = 1.0f;
    [scroll scrollRectToVisible:rect animated:YES];
    
}

-(void)keyBoardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo;
    userInfo = [notification userInfo];
    
    NSTimeInterval duration;
    UIViewAnimationCurve animationCurve;
    void(^animations)(void);
    duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue];
    animations = ^(void){
        scroll.contentInset = UIEdgeInsetsZero;
        scroll.scrollIndicatorInsets = UIEdgeInsetsZero;
    };
    [UIView
     animateWithDuration:duration delay:0.0 options:(animationCurve <<16) animations:animations completion:nil]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    table.dataSource = self;
    table.delegate = self;
    table.allowsSelection = NO;
    
    [scroll addSubview:table];
    [scroll setContentSize:table.frame.size];
    
    UIBarButtonItem *backButton =[[UIBarButtonItem alloc]initWithTitle:@"戻る" style:UIBarButtonSystemItemRedo target:self action:@selector(doReturn:)];
    navi.leftBarButtonItem = backButton;
    
    textFiled.returnKeyType = UIReturnKeyDone;
    textFiled.delegate = self;
    
    [self getArticleCommentList:appdelegate.articleIdForComment];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//セクション数を決める（デフォルトは1)
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//セルの数を決める
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //表示する要素をset
    NSLog(@"articleCommentCount %@",username);
    return [username count];
}

//セルの設定と、セル内の要素の値の追加
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---- set TableViewCell -----");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"] autorelease];
    }
        cell.textLabel.text = [username objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [articleComment objectAtIndex:indexPath.row];

    return cell;
}


-(void)doPost:(id)sender{
    NSLog(@"----- do Post start -----");
    //textFieldの要素を取得。
    [textFiled resignFirstResponder];
    NSString *comment = textFiled.text;
    NSLog(@"Comment:%@",comment);
    if([comment isEqualToString:nil]){
        //なにも入力してなかったらエラー出してなにもしない。
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登録エラー" message:@"コメントを入力してください" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //コメント登録処理（postで登録）(comment,cid,user_id)
    NSNumber *mode = [[NSNumber alloc]initWithInt:1];
    
    //operateクラス作ってそこでどうにかする
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [queue setMaxConcurrentOperationCount:1];
    CommentOperation *ope = [[CommentOperation alloc]initWithFileName:comment cid:(NSString *)appdelegate.articleIdForComment user_id:(NSString *)appdelegate.user_id mode:(NSNumber *)mode];
    [queue addOperation:ope];
    //postできたらviewと一緒に画面から消える。↓この１行ログはoperate側に持っていった方がいいかも
    NSLog(@"PostComment suceed user_id:%@,comment:%@,comment_id:%@",appdelegate.user_id, comment,appdelegate.articleIdForComment);
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"投稿完了" message:@"コメントを追加しました" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];

    //postView.hidden = YES;
    [textFiled resignFirstResponder];
}

//alertが表示されたら再取得
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self getArticleCommentList:appdelegate.articleIdForComment];
    [table reloadData];

}
//戻る処理
-(void)doReturn:(id)sender{
    //戻るときにnilにする。
    appdelegate.articleIdForComment = nil;
    [self dismissModalViewControllerAnimated:YES];
    
}

//キーボードを閉じる処理
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

//コメント取得
-(void)getArticleCommentList:(NSString *)commentId{
    NSLog(@"---- getArticleCommentList start ----");
    
    NSString *urlStr = @"http://49.212.148.198/imagetw/articleComment.php?cid=";
    
    NSString *param = [NSString stringWithFormat:@"%@%@&list=10",urlStr,commentId];
    NSLog(@"getArticleCommentListQuery: %@",param);
    
    
    NSURL *url = [NSURL URLWithString:param];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response =nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error == nil){
        NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSArray * jsonArray = [resultString JSONValue];
        NSLog(@"jsonArray list:%@",jsonArray);
        
        articleComment =[[NSMutableArray alloc]init];
        username = [[NSMutableArray alloc]init];
        
        for(NSDictionary *dic in jsonArray){
            [articleComment addObject:[dic objectForKey:@"comment"]];
            [username addObject:[dic objectForKey:@"username"]];
        }
        
    }

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
