//
//  WebViewController.h
//  Zoomlion
//
//  Created by 王li on 2017/12/1.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController

@property (nonatomic, strong) NSString *urlReq;
@property (nonatomic, strong) NSString *urlId;

@property (nonatomic, strong) NSString *shareName, *shareNum, *shareImage;

@end

