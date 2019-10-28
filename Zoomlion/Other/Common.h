//
//  Common.h
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIView+Position.h"
#import "UIView+Extension.h"
#import "UIImage+ImgSize.h"

//#define NaviH (ScreenHeight == 812 ? 88 : 64) // 812是iPhoneX的高度
#define ScreenBounds [Common screenBounds]
#define ScreenWidth ScreenBounds.size.width
#define ScreenHeight ScreenBounds.size.height
#define NavigationBarMaxY 64.0f
#define UIBarButtonItemFont [UIFont systemFontOfSize:16]
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define KWeakSelf __weak typeof(self) weakSelf = self;

//判断是否 Retina屏、设备是否iPhone 5、是否是iPad
//#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断是否为iPhone */
#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/** 判断是否是iPad */
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 判断是否为iPod */
#define isiPod ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//iphone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//iPad mini
#define iPadMini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)

//iPad Air
#define iPadAir ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

//iPad Pro1
#define iPadPro1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1668, 2224), [[UIScreen mainScreen] currentMode].size) : NO)

//iPad Pro2
#define iPadPro2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(2048, 2732), [[UIScreen mainScreen] currentMode].size) : NO)


//----------------------ABOUT SYSTYM & VERSION 系统与版本 ----------------------------
//Get the OS version.       判断操作系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//judge the simulator or hardware device        判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

/** 获取系统版本 */
#define iOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])

/** 是否为iOS6 */
#define iOS6 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) ? YES : NO)

/** 是否为iOS7 */
#define iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

/** 是否为iOS8 */
#define iOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

/** 是否为iOS9 */
#define iOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)

/** 是否为iOS10 */
#define iOS10 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) ? YES : NO)

/** 是否为iOS11 */
#define iOS11 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) ? YES : NO)


//----------------------ABOUT PRINTING LOG 打印日志 ----------------------------
//Using dlog to print while in debug model.        调试状态下打印日志

#ifdef DEBUG
#define WWLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define WWLog(...)
#endif

#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define WLLog(...) printf(" 第%d行: %s\n\n", [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
//    NSLog(@"***> %s", __func__);

#else
#define WLLog(...)
#endif

//Printing while in the debug model and pop an alert.       模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#define colorHex(hexValue) [Common hexColor:hexValue]
#define colorTheme colorHex(0xAACE3B)
#define colorTitle colorHex(0X121212)
#define colorSubtitle colorHex(0X8E8E8E)
#define colorBackground colorHex(0xeeeeee) //HexColor(0xefeff4)
#define colotAlpha [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]
#define colorWhite [UIColor whiteColor]
#define colorBlack [UIColor blackColor]
#define colorRed [UIColor redColor]
#define colorBlue [UIColor blueColor]
#define colorGreen [UIColor greenColor]
#define colorCyan [UIColor cyanColor]
#define colorYellow [UIColor yellowColor]
#define colorRandom [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:1]


#define fontBoldCustom(size) [Common boldSystemFontOfSize:size]
#define fontCustom(size) [Common systemFontOfSize:size]


#define fontLarge [Common systemFontOfSize:16]
#define fontNormal [Common systemFontOfSize:14]
#define fontSmall [Common systemFontOfSize:12]

#define font22 [Common systemFontOfSize:22]
#define font21 [Common systemFontOfSize:21]
#define font20 [Common systemFontOfSize:20]
#define font19 [Common systemFontOfSize:19]
#define font18 [Common systemFontOfSize:18]
#define font17 [Common systemFontOfSize:17]
#define font16 [Common systemFontOfSize:16]
#define font15 [Common systemFontOfSize:15]
#define font14 [Common systemFontOfSize:14]
#define font13 [Common systemFontOfSize:13]
#define font12 [Common systemFontOfSize:12]
#define font11 [Common systemFontOfSize:11]
#define font10 [Common systemFontOfSize:10]


@interface Common : NSObject

/**
 *  16进制RGB色
 *
 *  @param hexValue RGB值 16进制
 */
+ (UIColor*) hexColor:(NSInteger)hexValue;

/**
 *  屏幕尺寸
 */
+ (CGRect) screenBounds;

/**
 *  自动消失的提示框
 */
+ (void)showMessage:(NSString *)message;

/**
 *  获取网络状态
 */
+ (NSString *)getNetWorkStates;

/**
 * 根据颜色生成图片
 */
+(UIImage*) imageWithFrame:(CGRect)frame color:(UIColor*)color;

+(UIFont*)systemFontOfSize:(CGFloat)size;

+(UIFont*)boldSystemFontOfSize:(CGFloat)size;

+ (void)sizeImageFit:(UIImageView *)imageView;

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

+ (NSString*)getCurrentTime;

//+(BOOL)isVariableWithClass:(Class)cls varName:(NSString *)name;


@end
