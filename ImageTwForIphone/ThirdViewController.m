//
//  ThirdViewController.m
//  ImageTwForIphone
//
//  Created by  on 12/07/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"all", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"First"];
        reachability = [Reachability reachabilityWithHostName:@"49.212.148.198"];
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    }
    return self;
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
    table.allowsSelection = NO;
    [scroll addSubview:table];
    [scroll setContentSize:table.frame.size];
    // Do any additional setup after loading the view from its nib.
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
    NSLog(@"table view third");
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
    cell.commentUserName.text=[userName objectAtIndex:indexPath.row];
    cell.iine.text = [iine objectAtIndex:indexPath.row];
    
    //NSLog(@"%@",appdelegate.highlightedFlag);
    
    [cell.iineButton addTarget:self action:@selector(doIine:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(doComment:) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL *highlight = [[appdelegate.highlightedFlagAll objectAtIndex:indexPath.row] boolValue];
    
    cell.iineButton.highlighted = highlight;     
    
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

//いいねボタンが押された
-(void)doIine:(id)sender{
    NSLog(@"----- iine start ----");
    //圏外かどうかチェック
    reachability = [Reachability reachabilityWithHostName:@"49.212.148.198"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        NSLog(@"not connection");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ネットワークエラー" message:@"圏外のため登録できませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIButton *btn = (UIButton *)sender;
    FirstViewCell *cell = (FirstViewCell *)[[btn superview]superview];
    int row = [table indexPathForCell:cell].row;
    //BOOL型にまず戻してから判別処理をする
    BOOL *highlight = [[appdelegate.highlightedFlagAll objectAtIndex:row] boolValue];
    NSLog(@"doIine %d",highlight);
    //highlight == 1の時がいいねボタンがすでに押されている状態
    if(highlight){
        //いいねがすでに押されている場合はいいね解除（テーブルのレコードを削除)
        NSOperationQueue *queue = [[[NSOperationQueue alloc]init]autorelease];
        IineDeleteOparation *ope = [[IineDeleteOparation alloc]initWithFileName:[articleId objectAtIndex:row] userId:(NSString *)appdelegate.user_id];
        [queue addOperation:ope];
        int newCount = [[iineCount objectAtIndex:row] intValue] -1;
        [iineCount replaceObjectAtIndex:row withObject:[NSNumber numberWithInt:newCount]];
    }else{
        //いいねをする（テーブルのレコードを追加）
        NSOperationQueue *queue = [[[NSOperationQueue alloc]init]autorelease];
        IineOperation *ope = [[IineOperation alloc]initWithFileName:appdelegate.user_id cid:(NSString *)[articleId objectAtIndex:row]]; 
        [queue addOperation:ope];
        int newCount = [[iineCount objectAtIndex:row] intValue] +1;
        [iineCount replaceObjectAtIndex:row withObject:[NSNumber numberWithInt:newCount]];
    }
    [appdelegate.highlightedFlagAll replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:!highlight]];
    NSLog(@"PreiineValue:%@",iine);
    
    [self reloadIine];
    NSLog(@"NewiineValue:%@",iine);
    //いいねの表記だけ切り替える(今は全部の表示を再読み込みしてる）
    [table reloadData];
}


//コメントボタンが押されたら別画面に遷移
-(void)doComment:(id)sender{
    NSLog(@"----move comment view----");
    //ボタンが押された場所の記事idを取得する（delegateに入れるけど、画面遷移が終了したら必ず削除する）
    UIButton *button = (UIButton *)sender;
    FirstViewCell *cell = (FirstViewCell *)[[button superview]superview];
    int row = [table indexPathForCell:cell].row;
    appdelegate.articleIdForComment = [articleId objectAtIndex:row];
    
    CommentViewController *cvc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    [self presentModalViewController:cvc animated:YES];
    [cvc release];
    
}

//APIを叩いて、データを格納する人(要素数は今は決めうち）
-(void)getArticleList{
    //圏外かどうかチェック
    NSLog(@"reachability check");
    reachability = [Reachability reachabilityWithHostName:@"49.212.148.198"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ネットワークエラー" message:@"圏外のため取得できませんでした" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
    
    //listのAPIはget
    NSLog(@"%@",appdelegate.user_id);
    NSString *urlStr = @"http://49.212.148.198/imagetw/list.php?list=10&type=all";
    
    NSURL *url = [NSURL URLWithString:urlStr];
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
        iineCount = [[NSMutableArray alloc]init];
        iine = [[NSMutableArray alloc]init];
        appdelegate.highlightedFlagAll = [[NSMutableArray alloc]init];

            for(NSDictionary *dic in jsonArray){
                [articleId addObject:[dic objectForKey:@"id"]];
                [imageUrl addObject:[dic objectForKey:@"image_url"]];
                [description addObject:[dic objectForKey:@"description"]];
                [userName addObject:[dic objectForKey:@"username"]];
                [iineCount addObject:[NSNumber numberWithInt:[[dic objectForKey:@"count"] intValue]]];
                
                //count数から表示させる文言がかわるので、switch文で判別処理させる
                NSLog(@"[Third dic]:%@",dic);
                if([[dic objectForKey:@"count"] intValue] == 0){
                    //0件のときは何も表示しない
                    [iine addObject:@""];
                }else if([[dic objectForKey:@"count"] intValue]>=1 && [[dic objectForKey:@"count"] intValue]<=3){
                    //1~3件の場合はユーザ名を表示する
                    NSString *userList = [self getUserNameList:[dic objectForKey:@"id"]];
                    NSLog(@"userList %@",userList);
                    
                    NSArray *userlist = [userList JSONValue];
                    NSLog(@"userlist:%@",userlist);
                    NSMutableString *user=[NSMutableString string];
                    for(NSDictionary *dict in userlist){
                        [user appendFormat:@"%@,",[dict objectForKey:@"username"]];
                    }
                    [user appendString:@"からのいいね"];
                    NSLog(@"%@",user);
                    [iine addObject:user];                    
                }else if([[dic objectForKey:@"count"] intValue]>=4){
                    //4件以上の場合は件数をそのまま表示する
                    [iine addObject:[NSString stringWithFormat:@"%@件のいいね",[dic objectForKey:@"count"]]];
                }
                //いいねボタンのハイライト判別のためのフラグを入れる。
                NSNumber *flag = [self getIineStatus:[dic objectForKey:@"id"]];
                NSLog(@"iineFlag:%@",flag);
                [appdelegate.highlightedFlagAll addObject:flag];
            
            }

        }
        //NSLog(@"%@",[articleId description]);
        //NSLog(@"%@",[imageUrl description]);
        //NSLog(@"%@",[description description]);
        
    }   
    
}

//いいね表示用のユーザ名をAPIから取得する
-(NSString *)getUserNameList:(NSString *)commentId{
    NSString *urlStr = @"http://49.212.148.198/imagetw/iine.php?mode=2&comment_id=";
    
    NSString *param = [NSString stringWithFormat:@"%@%@",urlStr,commentId];
    NSLog(@"getUserNameListQuery: %@",param);
    
    
    NSURL *url = [NSURL URLWithString:param];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response =nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error == nil){
        NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return resultString;
    }
    return nil;
    
}

//いいねの状態をAPIから取得する
-(NSNumber *)getIineStatus:(NSString *)commentId{
    NSString *urlStr = @"http://49.212.148.198/imagetw/iine.php?mode=3&comment_id=";
    
    NSString *param = [NSString stringWithFormat:@"%@%@&user_id=%@",urlStr,commentId,appdelegate.user_id];
    NSLog(@"getUserNameListQuery: %@",param);
    
    
    NSURL *url = [NSURL URLWithString:param];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response =nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error == nil){
        NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return [NSNumber numberWithInt:[resultString intValue]];
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

//いいねボタンが押された場合のいいね表示の再取得
-(void)reloadIine{
    int num = 0;
    for(id value in iineCount){
        if([value intValue] == 0){
            //0件のときは何も表示しない
            [iine replaceObjectAtIndex:num withObject:@""];
        }else if([value intValue]>=1 && [value intValue]<=3){
            //1~3件の場合はユーザ名を表示する
           NSString *userList = [self getUserNameList:[articleId objectAtIndex:num]];
            
            NSArray *userlist = [userList JSONValue];
            NSMutableString *user=[NSMutableString string];
            if(userlist){
                for(NSDictionary *dict in userlist){
                    [user appendFormat:@"%@,",[dict objectForKey:@"username"]];
                }
            }else{
                appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
               [user appendFormat:@"%@",appdelegate.user_name];
            }
            [user appendString:@"からのいいね"];
            NSLog(@"userName:%@",user);
            [iine replaceObjectAtIndex:num withObject:user];                    
        }else if([value intValue]>=4){
            //4件以上の場合は件数をそのまま表示する
            [iine replaceObjectAtIndex:num withObject:[NSString stringWithFormat:@"%@件のいいね",value]];
        }
        num = num +1;
    }
}


//ログアウト
-(void)doLogout:(id)sender{
    //keychain内のデータを消去
    [KeyChain delete];
    
    //is_loginをfalseにする
    appdelegate.is_login = FALSE;
    
    //再読み込み
    UITabBarController *controller = self.tabBarController;
    controller.selectedViewController = [controller.viewControllers objectAtIndex:0];
    return;

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [articleId release];
    [description release];
    [userName release];
    [imageUrl release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
