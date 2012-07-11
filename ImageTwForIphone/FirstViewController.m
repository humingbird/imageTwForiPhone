//
//  FirstViewController.m
//  ImageTwForIphone
//
//  Created by  on 12/06/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "ImageLoad.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"List", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    //別画面遷移
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(!appdelegate.is_login){
        //keyChainにユーザ情報が入っていたらそれを使ってログインする
        NSDictionary *userInfo = nil;
        userInfo = [KeyChain getUserInfo];
        NSLog(@"%@",userInfo);
        if(userInfo){
            [LoginViewController autoLogin:userInfo];
            NSLog(@"%@",appdelegate.user_id);
            [self getArticleList];
            [table reloadData];
        }else{
            NSLog(@"keyChain is nothing");
            
            //ネットワーク環境のチェック。圏外の場合はログイン遷移に飛ばさない
            reachability = [Reachability reachabilityWithHostName:@"49.212.148.198"];
            NetworkStatus status = [reachability currentReachabilityStatus];
            if(status == NotReachable){
                NSLog(@"not connection");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ネットワークエラー" message:@"圏外のためログインできませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                //圏外ですよ静的ページ挟んだらいい感じかも。
            }else{
            LoginViewController *fvc =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self presentModalViewController:fvc animated:YES];
            return;
            }
        }
        
    }
}

//表示されるたびにtableのdataを再読み込み（本当はmemcacheとかにすべき）
-(void)viewWillAppear:(BOOL)animated{
    if(appdelegate.is_login){
        [self getArticleList];
        [table reloadData];
    }
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    //画面移動
    UIBarButtonItem *logout = [[UIBarButtonItem alloc]initWithTitle:@"ログアウト" style:UIBarButtonItemStyleDone target:self action:@selector(doLogout:)];
    navi.leftBarButtonItem = logout;
    
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 291;
    [scroll addSubview:table];
    [scroll setContentSize:table.frame.size];
    if(appdelegate.is_login){
        [table reloadData];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [articleId release];
    [imageUrl release];
    [description release];
    [userName release];
    // Release any retained subviews of the main view.
}

//セクション数を決める（デフォルトは1)
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//セルの数を決める
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //表示する要素をset
    return [articleId count];
}

//セルの設定と、セル内の要素の値の追加
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"table view");
    static NSString *CellIdentifier=@"Cell";
    
    FirstViewCell *cell = (FirstViewCell *)[tableView
                                            dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        UIViewController *vc;
        vc = [[UIViewController alloc]initWithNibName:@"topTable" bundle:nil];
        cell = (FirstViewCell *)vc.view;
    }
    cell.topUserName.text=[userName objectAtIndex:indexPath.row];
    cell.comment.text=[description objectAtIndex:indexPath.row];
    cell.commentUserName.text = [userName objectAtIndex:indexPath.row];
    
    //画像の読み込みだけは非同期
    cell.photo.image =nil;
    //indicator(読み込み時にくるくるまわるやつ）をまずは表示
    UIActivityIndicatorView *indicator;
    indicator = [[[UIActivityIndicatorView alloc]
                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]
                 autorelease];
    indicator.frame = cell.photo.bounds;
    indicator.contentMode = UIViewContentModeCenter;
    [indicator startAnimating];
    [cell.photo addSubview:indicator];
    //非同期で画像を取得してくるクラスを呼び出す
    ImageLoad *delegate;
    delegate = [[[ImageLoad alloc]init]autorelease];
    delegate.indexPath = indexPath;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(loadImageDidEnd:) name:kConnectionDidFinishNotification object:delegate];
    
    [delegate connectionWithPath:[imageUrl objectAtIndex:indexPath.row]]; 
    
    
    return cell;
}

//APIを叩いて、データを格納する人(要素数は今は決めうち）
-(void)getArticleList{
    //圏外かどうかチェック
    reachability = [Reachability reachabilityWithHostName:@"49.212.148.198"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        NSLog(@"not connection");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ネットワークエラー" message:@"圏外のため取得できませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        //listのAPIはget
        NSLog(@"%@",appdelegate.user_id);
        NSString *urlStr = @"http://49.212.148.198/imagetw/list.php?list=10&user_id=";
        NSString *param = [urlStr stringByAppendingString:appdelegate.user_id]; 
        NSLog(@"%@",param);
    
        NSURL *url = [NSURL URLWithString:param];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
        NSURLResponse *response =nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        if(error == nil){
            NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
            //返ってきたjson形式のデータを連想配列（NSMutableDitionary)にする。        
            NSArray *jsonArray = [resultString JSONValue];
        
            //id,imageUrl,descriptionを取得してそれぞれ配列に入れる
            articleId = [[NSMutableArray alloc]init];
            imageUrl = [[NSMutableArray alloc]init];
            description = [[NSMutableArray alloc]init];
            userName = [[NSMutableArray alloc]init];
        
            for(NSDictionary *dic in jsonArray){
                [articleId addObject:[dic objectForKey:@"id"]];
                [imageUrl addObject:[dic objectForKey:@"image_url"]];
                [description addObject:[dic objectForKey:@"description"]];
                [userName addObject:[dic objectForKey:@"username"]];
            }
            //NSLog(@"%@",[articleId description]);
            //NSLog(@"%@",[imageUrl description]);
            //NSLog(@"%@",[description description]);
        
        }   
    }
    
}

//indicatorの入ったsubViewを削除して、読み込んだ画像をセットする
-(void)loadImageDidEnd:(NSNotification *)notification{
    ImageLoad *delegate = (ImageLoad *)[notification object];
    
    if(delegate !=nil){
        NSIndexPath *indexPath = nil;
        NSData *imageData = nil;
    
    if([notification userInfo] == nil){
        imageData = delegate.data;
        indexPath = delegate.indexPath;
    }
    
        if((imageData != nil)){
            FirstViewCell *cell;
            cell =(FirstViewCell *)[table cellForRowAtIndexPath:indexPath];
            if(cell !=nil){
                for(UIView *subView in cell.photo.subviews){
                    [subView removeFromSuperview];
                }
                cell.photo.image = [UIImage imageWithData:imageData];
            }else{
                NSLog(@"cell not found");
                return;
            }
        }else{
            NSLog(@"imagefile not found");
        }
    }
}

//ログアウト
-(void)doLogout:(id)sender{
    //keychain内のデータを消去
    [KeyChain delete];
    
    //is_loginをfalseにする
    appdelegate.is_login = FALSE;

    //再読み込み
    [self viewDidAppear:YES];
  
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
