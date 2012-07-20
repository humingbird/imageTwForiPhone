//
//  SubmitOperation.m
//  ImageTwForIphone
//
//  Created by  on 12/07/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SubmitOperation.h"
#import "AppDelegate.h"
#import "FormViewController.h"

@implementation SubmitOperation

-(id)initWithFileName:(NSString *)text comment:(NSString *)c_text _imageData:(NSData *)image{
    self =[super init];
    
    if(self){
        _filename = [text retain];
        comment = [c_text retain];
        _imageData = [image retain];
    }
    return self;
}

-(void)dealloc{
    [_filename release];
    [comment release];
    [_imageData release];
    _filename =nil;
    comment =nil;
    _imageData =nil;
    
    [super dealloc];
}

-(void)main{
    //isImageフラグが存在しているかどうかチェック
    //NSLog(@"%@",appdelegate.imageUrl);
          appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(!appdelegate.isImage){
        NSLog(@"image");
    //無ければ画像ファイルをアップロードする（isImageのフラグ）
        [self sendPostRequestForImage:_filename imageData:_imageData];
    }else{
        NSLog(@"article");
        //NSLog(@"%@",(NSString *)appdelegate.imageUrl);
        //ある場合はdelegate内の変数に画像のurlが存在するかどうか確認する
        if(appdelegate.imageUrl != nil){
            //あればDBに記事情報の登録・無ければエラー処理してreturn
            [self sendPostRequestForData:comment imageUrl:appdelegate.imageUrl];
        }else{
            NSLog(@"imageUrl is not found");
            return;
        }
    }
 }


- (void)imageUpload{
    NSLog(@"imageUpload");
    appdelegate.imageUrl = @"sample";
    appdelegate.isImage =TRUE;
    NSLog(@"%@",appdelegate.imageUrl);
}


//画像データのアップロード
-(void)sendPostRequestForImage:(NSString *)filename imageData:(NSData *)imageData{
    NSLog(@"image");
    //飛ばすデータ作る
    NSString *boundary = @"1111";
    NSMutableData *requestData =[[NSMutableData alloc]init];
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:imageData];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString *urlstr = @"http://49.212.148.198/imagetw/image.php";
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSURLResponse *responce = nil;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&error];
    
    if(error == nil){
        NSString *responceString = [[NSString alloc]initWithBytes:result.bytes length:result.length encoding:NSUTF8StringEncoding];
        appdelegate.imageUrl = responceString;
        NSLog(@"%@",appdelegate.imageUrl);
        appdelegate.isImage = TRUE;
    }
}

//記事情報の登録
-(void)sendPostRequestForData:(NSString *)text imageUrl:(NSString *)_imageUrl{
    NSLog(@"comment");
    NSString *boundary = @"1111";
    NSMutableData *requestData =[[NSMutableData alloc]init];
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",comment] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image_url\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",_imageUrl] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];    
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",appdelegate.user_id] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];    
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];

    
    NSString *urlstr = @"http://49.212.148.198/imagetw/comment.php";
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    //NSData *data =[NSString stringWithFormat:@"comment=%@&image_url=%@",text,imageUrl];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    //[request setHTTPBody:requestData];
    
    
    NSURLResponse *responce = nil;
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&error];
    
    if(error == nil){
        NSString *responceString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responceString);
        appdelegate.isImage = FALSE;
        [responceString release];
    }else{
        NSLog(@"submit error");
        return;
    }
}

//登録処理
- (void)submit:(NSString *)text{
    NSLog(@"upload text is %@",text);
    appdelegate.isImage = FALSE;
}

@end
