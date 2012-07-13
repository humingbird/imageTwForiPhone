//
//  IineDeleteOparation.m
//  ImageTwForIphone
//
//  Created by  on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IineDeleteOparation.h"

@implementation IineDeleteOparation

-(id)initWithFileName:(NSString *)commentId userId:(NSString *)userId{
    self = [super init];
    if(self){
        _comment_id = [commentId retain];
        _user_id =[userId retain];
    }
    
    return self;
}

-(void)dealloc{
    [_comment_id release];
    [_user_id release];
    _comment_id = nil;
    _user_id = nil;
    
    [super dealloc];
}

-(void)main{
    NSString *result = [self deleteIineData:_comment_id userId:_user_id];
    NSLog(@"deleteIine result:%@",result);
}

-(NSString *)deleteIineData:(NSString *)commentId userId:(NSString *)userId{
    NSString *urlStr = @"http://49.212.148.198/imagetw/iine.php?mode=1&comment_id=";
    
    NSString *param = [NSString stringWithFormat:@"%@%@&user_id=%@",urlStr,commentId,userId];
    NSLog(@"deleteQuery: %@",param);
    
    
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

@end
