//
//  BaseViewController.h
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSegmentBarVC.h"

#import "XHNetworkCache.h"

@interface BaseViewController : UIViewController

@property (nonatomic, weak) LLSegmentBarVC *segContentVC;
@property (nonatomic, strong) NSMutableArray *barArr;

#pragma mark - 更新最新数据
- (void)requestNoticeUpdate;

- (void)downloadImage:(NSString *)imageStr;

@end