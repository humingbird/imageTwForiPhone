//
//  KeyChain.m
//  ImageTwForIphone
//
//  Created by  on 12/07/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KeyChain.h"

@implementation KeyChain

//１端末で１つのユーザアカウントしか保持しないので、既存パスワードが無い場合のみ処理を行う。
+(void)create:(NSString *)password username:(NSString *)username{
    NSMutableDictionary* attributes = nil;
    NSMutableDictionary* query =[NSMutableDictionary dictionary];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",
                              password,@"password", nil];
    NSData* userInfoData =[NSKeyedArchiver archivedDataWithRootObject:userInfo];
    //NSData* userNameData = [username dataUsingEncoding:NSUTF8StringEncoding];

    [query setObject:kSecClassGenericPassword forKey:kSecClass];
    [query setObject:@"loginId" forKey:kSecAttrAccount];
    [query setObject:@"imageTw" forKey:kSecAttrService];
    
    OSStatus err = SecItemCopyMatching((CFDictionaryRef)query, NULL);
    
    if(err == errSecItemNotFound){
        NSLog(@"errSecItemNotFound");
        
        attributes = [NSMutableDictionary dictionary];
        [attributes setObject:kSecClassGenericPassword forKey:kSecClass];
        [attributes setObject:@"loginId" forKey:kSecAttrAccount];
        [attributes setObject:userInfoData forKey:kSecValueData];
        
        err = SecItemAdd((CFDictionaryRef)attributes, NULL);
        if(err == noErr){
            NSLog(@"NoErr");
        }else{
            NSLog(@"error(%d)",err);
        }
    }else{
        NSLog(@"query error(%d)",err);
    }
}

//検索（取得）処理
+(NSDictionary *)getUserInfo{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    [query setObject:kSecClassGenericPassword forKey:kSecClass];
    [query setObject:@"loginId" forKey:kSecAttrAccount];
    [query setObject:kCFBooleanTrue forKey:kSecReturnData];
    
    NSData* userInfoData = nil;
    OSStatus err = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef)&userInfoData);
    
    if(err == noErr){
        NSLog(@"secItemCopyMatching NoErr");
        NSDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
        return data;
    }
return nil;
}

//ログアウト用削除処理
+(void)delete{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    [query setObject:kSecClassGenericPassword forKey:kSecClass];
    [query setObject:@"loginId" forKey:kSecAttrAccount];
    
    OSStatus err = SecItemDelete((CFDictionaryRef)query);
    
    if(err == noErr){
        NSLog(@"SecItemDelete noErr");
    }else{
        NSLog(@"secItemDelete error(%d)",err);
    }
}

@end
