//
//  SettingLogOutTableViewCell.m
//  Zoomlion
//
//  Created by 王li on 2018/1/14.
//  Copyright © 2018年 wli. All rights reserved.
//

#import "SettingLogOutTableViewCell.h"

@implementation SettingLogOutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configView];
    }
    return self;
}

- (void)configView
{
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    [titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.center.equalTo(self);
    }];
    
   titleLab.text = @"退出登录";
   titleLab.textColor = colorTitle;
   titleLab.textAlignment = NSTextAlignmentCenter;
   titleLab.font = font15;
    
    self.titleLab = titleLab;
}


@end
