//
//  UserCenterManager.m
//  JiBu
//
//  Created by wangyuanzhi on 15/9/21.
//  Copyright (c) 2015年 wangyuanzhi. All rights reserved.
//
#import "UserCenterManager.h"

@interface UserCenterManager ()

@end

@implementation UserCenterManager

+ (UserCenterManager *)sharedManager
{
    static UserCenterManager *sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//获得当前登录用户
- (NSDictionary *)getLoginUser
{
    NSDictionary *userdic =  [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    
    return userdic;
}

//重设当前登录用户
- (void)saveLoginUser:(NSMutableDictionary *)loginUser
{
    [[NSUserDefaults standardUserDefaults] setObject:loginUser forKey:@"User"];
}

@end

