//
//  IineOperation.m
//  ImageTwForIphone
//
//  Created by  on 12/07/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IineOperation.h"

@implementation IineOperation

-(id)initWithFileName:(NSString *)userId cid:(NSString *)cId{
    self = [super init];
    
    if(self){
        _userId = [userId retain];
        _cId = [cId retain];
    }
    return  self;
}

-(void)dealloc{
    [_userId release];
    [_cId release];
    _userId = nil;
    _cId = nil;
    [super dealloc];
}

-(void)main{
    NSString *result = [self sendPost:_userId cid:_cId];
    NSLog(@"%@",result);
}

//post処理
-(NSString *)sendPost:(NSString *)userId cid:(NSString *)cId{
    NSLog(@"comment");
    NSString *boundary = @"1111";
    NSMutableData *requestData =[[NSMutableData alloc]init];
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",userId] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    
    [requestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment_id\"\r\n\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithFormat:@"%@",cId] dataUsingEncoding:NSASCIIStringEncoding]];
    [requestData appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSASCIIStringEncoding]];    
    [requestData appendData:[[NSString stringWithFormat:@"--%@--\r\n\r\n", boundary] dataUsingEncoding:NSASCIIStringEncoding]];
        
    NSString *urlstr = @"http://49.212.148.198/imagetw/iine.php";
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
        return responceString;
        [responceString release];
    }else{
        NSLog(@"submit error");
        return @"false";
    }

}

@end
