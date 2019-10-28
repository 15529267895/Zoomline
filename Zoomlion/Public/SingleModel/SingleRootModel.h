//
//  SingleRootModel.h
//  Zoomlion
//
//  Created by 王li on 2017/11/14.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleRootModel : NSObject
/**
 *  通过此方法可以创建全局共享唯一模型返回model
 *  若想创建不是全局共享的model，请用init
 *  全局共享的思路就是保存到内存中不被释放。
 */
+ (id)shareModel;

/**
 *  通过kvc快速给属性赋值， dict转对象
 */
- (void)setValueForDict:(NSDictionary *)dict;
/**
 *  通过kvc快速给属性赋值， json转对象
 */
- (void)setValueForJson:(NSString *)json;

/**
 *  将所有属性值置为nil
 */
- (void)clearModelInfo;

/**
 *  格式化对象，对象转模型
 */
- (NSDictionary *)modelToDict;

/**
 * 格式化对象，对象转json
 */
-(NSString *)modelToJson;


@end

