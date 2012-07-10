//
//  ListOperation.m
//  ImageTwForIphone
//
//  Created by  on 12/07/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListOperation.h"

@implementation ListOperation

-(void)main{
    NSLog(@"listGet Start");
    //記事一覧を取得するAPIを叩く
    //[self getArticleList];
}

//APIを叩いて、データを格納する人(要素数は今は決めうち）
/*-(void)getArticleList{
    //listのAPIはget
    NSString *urlStr = @"http://49.212.148.198/imagetw/list.php?list=10";
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
        NSMutableArray *id = [[NSMutableArray alloc]init];
        NSMutableArray *imageUrl = [[NSMutableArray alloc]init];
        NSMutableArray *description = [[NSMutableArray alloc]init];
        for(NSDictionary *dic in jsonArray){
            [id addObject:[dic objectForKey:@"id"]];
            [imageUrl addObject:[dic objectForKey:@"image_url"]];
            [description addObject:[dic objectForKey:@"description"]];
        }
        NSLog(@"%@",[id description]);
        NSLog(@"%@",[imageUrl description]);
        NSLog(@"%@",[description description]);
        
        //delegate内の要素に入れる。
        appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.articleId = id;
    }
    
    
}*/

@end
