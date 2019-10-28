//
//  UserCenterManager.h
//  JiBu
//
//  Created by wangyuanzhi on 15/9/21.
//  Copyright (c) 2015年 wangyuanzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KCompany @"company"
#define KCreateDate @"createDate"
#define KEmail @"email"
#define KEnabled @"enabled"
#define KId @"id"
#define KIsNewRecord @"isNewRecord"
#define KMobile @"mobile"
#define KName @"name"
#define KPassword @"password"
#define KUpdateTime @"updateDate"
#define KToken @"token"
#define KSex @"sex"
#define KRemarks @"remarks"
#define KUpdateDate @"updateDate"
#define KAddress @"address"
#define KHelp @"help"
#define KPosition @"position"

#define USERCENTERMANAGER ([UserCenterManager sharedManager])

@interface UserCenterManager : NSObject


+ (UserCenterManager *)sharedManager;

//获得当前登录用户
- (NSDictionary *)getLoginUser;

//重设当前登录用户
- (void)saveLoginUser:(NSMutableDictionary *)loginUser;
@end