//
//  ImageLoad.m
//  ImageTwForIphone
//
//  Created by  on 12/07/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageLoad.h"

@implementation ImageLoad

@synthesize data,path,indexPath;

-(void)connectionWithPath:(NSString *)filePath{
    if([path isEqualToString: filePath] == FALSE){
        [path release];
        path=filePath;
        [path retain];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:filePath]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error");
    [[NSNotificationCenter defaultCenter] postNotificationName:kConnectionDidFinishNotification
     object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    data=[NSMutableData data];
    [data retain];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)pdata{
    NSLog(@"success");
    [data appendData:pdata];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[NSNotificationCenter defaultCenter]postNotificationName:kConnectionDidFinishNotification object:self];
}

-(void)dealloc{
    [path release];
    [indexPath release];
    [data release];
    [super dealloc];
}

@end
