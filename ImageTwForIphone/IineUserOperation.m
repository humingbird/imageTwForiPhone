//
//  IineUserOperation.m
//  ImageTwForIphone
//
//  Created by  on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IineUserOperation.h"

@implementation IineUserOperation

-(id)initWithFileName:(NSString *)comment_id{
    self = [super init];
    if(self){
        _comment_id = [comment_id retain];
    }
    return self;
}

-(void)dealloc{
    [_comment_id release];
    _comment_id = nil;
    [super dealloc];
}

-(void)main{
    NSString *result = [self getUserNameList:_comment_id];
    //JSONValueでユーザー名だけ取得してくる
    NSArray *jsonArray =[result JSONValue];
    
    for(NSDictionary *dic in jsonArray){
        
    }
    
}

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

@end
