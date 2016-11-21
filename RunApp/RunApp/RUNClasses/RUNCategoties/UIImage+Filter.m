//
//  UIImage+Filter.m
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "UIImage+Filter.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (Filter)

- (UIImage *)addFilter:(NSString *)filterName{
    if ([filterName isEqualToString:@"OriginImage"]) {
        return self;
    }
    
    //将UIImage转换成CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //已有的值不变，其他的设为默认值
    [filter setDefaults];
    
    //获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    
    //创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //获取图片
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    //释放CGImage句柄
    CGImageRelease(cgImage);
    
    return image;
}

@end
