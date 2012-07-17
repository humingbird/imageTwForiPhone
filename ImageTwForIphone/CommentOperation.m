//
//  CommentOperation.m
//  ImageTwForIphone
//
//  Created by  on 12/07/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentOperation.h"

@implementation CommentOperation

-(id)initWithFileName:(NSString *)comment cid:(NSString *)cid user_id:(NSString *)user_id mode:(NSNumber *)mode{
    self=[super init];
    
    if(self){
        _comment = [comment retain];
        _cid =[cid retain];
        _user_id =[user_id retain];
        _mode = [mode retain];
    }
    
    return self;
}

-(void)dealloc{
    [_comment release];
    [_cid release];
    [_user_id release];
    [_mode release];
    
    _comment = nil;
    _cid = nil;
    _user_id = nil;
    _mode = nil;
    
    [super dealloc];
}

-(void)main{
    //modeで投稿か、取得かを判別して処理をする
    if([_mode intValue] == 1){
        //post処理
        BOOL result = [self postCommentData:_comment cid:_cid user_id:_user_id];
        if(result){
            NSLog(@"comment submitted: user_id:%@ comment_id:%@",_user_id,_cid);
        }else{
            NSLog(@"comment submitted: user_id:%@ comment_id:%@",_user_id,_cid);            
        }
    }else{
        NSLog(@"commentOperation Error:mode=%d",[_mode intValue]);
    }
}

//投稿処理
-(BOOL)postCommentData:(NSString *)comment cid:(NSString *)cid user_id:(NSString *)user_id{
    NSLog(@"-----articleComment submit start-------");
    NSString *boundary = @"1111";
    NSMutableData *requestData =[[NSMutableData alloc]init];
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",comment] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"cid\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",cid] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];    
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",user_id] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];    
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    
    NSString *urlstr = @"http://49.212.148.198/imagetw/articleComment.php";
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
    
    NSLog(@"----articleComment submit finished-----");
    
    if(error == nil){
        NSString *responceString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",responceString);
        if([responceString isEqualToString:@"true"]){
            [responceString release];
            return TRUE;
        }else {
            [responceString release];
            return FALSE;
        }
    }else{
        NSLog(@"submit error");
        
        return FALSE;
    }

}


@end
