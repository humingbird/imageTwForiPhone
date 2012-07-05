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
    CGImageRef imageRef;
    imageRef = anImage.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    size_t bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool shouldInterPolate;
    shouldInterPolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data;
    UInt8* buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger x,y;
    for(y=0;y<height;y++){
        for(x=0;x<width;x++){
            UInt8* tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green =*(tmp +1);
            blue = *(tmp +2);
            
            UInt8 brightness;
            brightness =(77 *red + 28*green +151*blue)/256;
            
            *(tmp +0) = brightness;
            *(tmp +1) = brightness;
            *(tmp +2) = brightness;
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
    
    //CGImageRelease(imageRef);
    return effectedImage;
    
}


+(UIImage *)sepia:(UIImage *)seImage{
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
            red = *(tmp + 0);
            green = *(tmp +1);
            blue = *(tmp+2);
            
            UInt8 brightness;
            brightness = (77 * red + 28 * green + 151 *blue)/256;
            
            *(tmp + 0) = brightness;
            *(tmp +1) = brightness*0.7;
            *(tmp +2) = brightness*0.4;
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
