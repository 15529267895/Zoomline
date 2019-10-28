//
//  Common.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "Common.h"

#define Duration 2.5f

@implementation Common

+ (UIColor*) hexColor:(NSInteger)hexValue {

    CGFloat red = (CGFloat)((hexValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = (CGFloat)((hexValue & 0xFF00) >> 8) /255.0;
    CGFloat blue = (CGFloat)(hexValue & 0xFF) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    return color;
}

+(CGRect)screenBounds {
    return [[UIScreen mainScreen] bounds];
}

+ (void)showMessage:(NSString *)message
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor grayColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(screenSize.width, screenSize.height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [showview addSubview:label];
    
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 60)/2,
                                screenSize.height - 100,
                                labelSize.width +60,
                                labelSize.height+10);
    label.frame = CGRectMake(10, 5, labelSize.width + 60,
                             labelSize.height);
    label.centerX = showview.size.width / 2;
    
    [UIView animateWithDuration:Duration animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+ (NSString *)getNetWorkStates {
    
    UIApplication *application = [UIApplication sharedApplication];
    
    
    NSArray *children;    if ([[application valueForKeyPath:@"_statusBar"]
      isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")])
    {
        children = [[[[application valueForKeyPath:@"_statusBar"]
             valueForKeyPath:@"_statusBar"]
            valueForKeyPath:@"foregroundView"]
           subviews];
    }
    else
        
    {
        children = [[[application valueForKeyPath:@"_statusBar"]
            valueForKeyPath:@"foregroundView"]
           subviews];
        
    }
    NSString *state = @"无网络";
    
    int netType = 0;
    
    //获取到网络返回码
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

+(UIImage*) imageWithFrame:(CGRect)frame color:(UIColor*)color {
    if(CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, 1, 1);
    }
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, frame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIFont*)systemFontOfSize:(CGFloat)size
{
    UIFont *font ;
    if (isiPad)
    {
        if(iPadPro1 || iPadPro2)
        {
            font = [UIFont systemFontOfSize:size + 7];
        }
        else
        {
            font = [UIFont systemFontOfSize:size + 4];
        }
    }
    else if (iPhone4 || iPhone5)
    {
        font = [UIFont systemFontOfSize:size - 2];
    }
    else
    {
        font = [UIFont systemFontOfSize:size];
    }
    
    return font;
}

+(UIFont*)boldSystemFontOfSize:(CGFloat)size
{
    UIFont *font ;
    
    if (isiPad)
    {
        if(iPadPro1 || iPadPro2)
        {
            font = [UIFont systemFontOfSize:size + 5];
        }
        else
        {
            font = [UIFont systemFontOfSize:size + 2];
        }
    }
    else if (iPhone4 || iPhone5)
    {
        font = [UIFont systemFontOfSize:size - 2];
    }
    else
    {
        font = [UIFont systemFontOfSize:size];
    }

    return font;
}

/// Scale image / 缩放图片
+ (void)sizeImageFit:(UIImageView *)imageView
{
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizesSubviews = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

/// Scale image / 缩放图片
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    if (image.size.width < size.width)
    {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString*)getCurrentTime
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];

    return dateTime;
}

//+(BOOL)isVariableWithClass:(Class)cls varName:(NSString *)name {
//    unsigned int outCount, i;
//    Ivar *ivars = class_copyIvarList(cls, &outCount);
//    for (i = 0; i < outCount; i++) {
//        Ivar property = ivars[i];
//        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
//        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
//        if ([keyName isEqualToString:name]) {
//            return YES;
//        }
//    }
//    return NO;
//}

@end
