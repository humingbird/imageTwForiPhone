//
//  ImageColor.m
//  ImageTwForIphone
//
//  Created by  on 12/07/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageColor.h"

@implementation ImageColor


//モノクロにする処理
+(UIImage *)monochrome:(UIImage *)anImage{
    
    //カメラから取得した画像が90度回転しないための処理
    UIGraphicsBeginImageContext(anImage.size);
    [anImage drawInRect:CGRectMake(0, 0, anImage.size.width, anImage.size.height)];
    anImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef imageRef;
    imageRef = anImage.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    //pxを構成するRGB値のそれぞれのビット数の取得
    size_t bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    //px全体のビット数の取得
    size_t bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    //画像の横ライン１つのデータのバイト数を取得
    size_t bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    //画像の色空間の取得（色空間・・？）
    CGColorSpaceRef colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    //画像のbitmap情報の取得
    CGBitmapInfo bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    //画像がピクセル間の補完をしているか
    bool shouldInterPolate;
    shouldInterPolate = CGImageGetShouldInterpolate(imageRef);
    
    //表示装置によって補正をしているか
    CGColorRenderingIntent intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    //画像のデータプロバイダの取得
    CGDataProviderRef dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    //データプロバイダから画像をbitmapデータで取得
    CFDataRef data;
    UInt8* buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    //1ピクセルごとに色の調整
    NSUInteger x,y;
    for(y=0;y<height;y++){
        for(x=0;x<width;x++){
            UInt8* tmp;
            tmp = buffer + y * bytesPerRow + x * 4;// RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            //RGB値の調整
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green =*(tmp +1);
            blue = *(tmp +2);
            
            //光度の計算
            UInt8 brightness;
            brightness =(77 *red + 28*green +151*blue)/256;
            
            *(tmp +0) = brightness;
            *(tmp +1) = brightness;
            *(tmp +2) = brightness;
        }
    }
    
    //色の調整をしたデータの生成
    CFDataRef effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    //色の調整をしたデータプロバイダの生成
    CGDataProviderRef effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    //画像の生成
    CGImageRef effectedCgImage;
    UIImage* effectedImage;
    effectedCgImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, effectedDataProvider, NULL, shouldInterPolate, intent);
    
    effectedImage = [[UIImage alloc]initWithCGImage:effectedCgImage];
    
    //もろもろrelease
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
    
}


+(UIImage *)sepia:(UIImage *)seImage{
    
    //カメラから取得した画像が90度回転しないための処理
    UIGraphicsBeginImageContext(seImage.size);
    [seImage drawInRect:CGRectMake(0, 0, seImage.size.width, seImage.size.height)];
    seImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef seimageRef;
    seimageRef = seImage.CGImage;
    
    size_t width = CGImageGetWidth(seimageRef);
    size_t height = CGImageGetHeight(seimageRef);
    
    size_t bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(seimageRef);
    
    size_t bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(seimageRef);
    
    size_t bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(seimageRef);
    
    CGColorSpaceRef colorSpace;
    colorSpace = CGImageGetColorSpace(seimageRef);
    
    CGBitmapInfo bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(seimageRef);
    
    bool shouldInterPolate;
    shouldInterPolate = CGImageGetShouldInterpolate(seimageRef);
    
    CGColorRenderingIntent intent;
    intent = CGImageGetRenderingIntent(seimageRef);
    
    CGDataProviderRef dataProvider;
    dataProvider = CGImageGetDataProvider(seimageRef);
    
    CFDataRef data;
    UInt8* buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSInteger x,y;
    for(y=0;y<height;y++){
        for(x=0;x<width;x++){
            UInt8* tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            blue = *(tmp +0);
            green = *(tmp+1);
            red = *(tmp+2);
            
            UInt8 brightness;
            brightness = (77 * red + 28 * green + 151 *blue)/256;
            
            *(tmp + 0) = brightness*0.4; //blue
            *(tmp +1) = brightness*0.7; //green
            *(tmp +2) = brightness; //red
        }
    }

    
    
    CFDataRef effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage;
    UIImage* effectedImage;
    effectedCgImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, effectedDataProvider, NULL, shouldInterPolate, intent);
    
    effectedImage = [[UIImage alloc]initWithCGImage:effectedCgImage];
    
    
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    //CGImageRelease(seimageRef);
    
    return effectedImage;
}

@end
