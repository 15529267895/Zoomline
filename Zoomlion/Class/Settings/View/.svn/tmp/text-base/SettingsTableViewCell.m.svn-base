//
//  SettingsTableViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/11/13.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

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
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self);
    }];
    
    UILabel *subTitle = [UILabel new];
    [self addSubview:subTitle];
    [subTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-32);
        make.centerY.equalTo(titleLab);
    }];
    
    UIImageView *arrowImg = [UIImageView new];
    self.arrowImg = arrowImg;
    [self addSubview:arrowImg];
    [arrowImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-13);
        make.centerY.equalTo(titleLab);
        make.width.offset(7);
        make.height.offset(12);
    }];
    
    arrowImg.image = [UIImage imageNamed:@"rightIndex"];
    arrowImg.hidden = YES;
    subTitle.text = @"加载中";
    titleLab.textColor = colorTitle;
    subTitle.textColor = colorSubtitle;
    subTitle.font = titleLab.font = font14;
    
    self.titleLab = titleLab;
    self.subLab = subTitle;
}

@end
