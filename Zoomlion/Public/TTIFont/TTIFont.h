//
//  TTIFont.h
//  iOSCodeProject
//
//  Created by Fox on 14-7-19.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 使用方法
 model = self.arrSysmsg[indexPath.row];
 
 float h1 = [TTIFont calHeightWithText:model.sysMsgContent font:[UIFont systemFontOfSize:13.0] limitWidth:SCREEN_WIDTH - 30];
 
 return h1 + 50;

 */

/**
 *  字体操作工具类
 */
@interface TTIFont : NSObject

/**
 *  显示系统自带的所有字体
 */
+ (void)showAllSystemFonts;

/**
 *  获取项目中公用的字体
 *
 *  @param size 字体大小
 *
 *  @return 字体
 */
+ (UIFont *)getCommonFontWithSize:(float )size;

/**
 *  获取字体的高度
 *
 *  @param font 字体
 *
 *  @return 高度大小
 */
+ (CGFloat)lineHeight:(UIFont *)font;

/**
 *  计算文字在一定宽度下的高度
 *
 *  @param text      文字
 *  @param font      字体对象
 *
 *  @return 高度
 */
+(float )calHeightWithText:(NSString *)text font:(UIFont *)font limitWidth:(float)limitWidth;

/**
 *  计算文字在一定高度下的宽度
 *
 *  @param text      文字
 *  @param font      字体对象
 *
 *  @return 宽度
 */
+(float )calWidthWithText:(NSString *)text font:(UIFont *)font limitHeight:(float)limitHeight;

@end
