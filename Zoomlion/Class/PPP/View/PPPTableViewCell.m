//
//  PPPTableViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "PPPTableViewCell.h"

@implementation PPPTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configView];
    }
    return self;
}

- (void)configView
{
    self.nameLab = [UILabel new];
    [self addSubview:self.nameLab];
    
    [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15 / 375.0 * ScreenWidth);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.nameLab.font = font14;
    self.nameLab.textColor = colorTitle;

    UIImageView *arrowImg = [UIImageView new];
    [self addSubview:arrowImg];

    [arrowImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.height.offset(13);
        make.centerY.equalTo(self.nameLab);
    }];
    arrowImg.image = [UIImage imageNamed:@"rightIndex"];
    arrowImg.contentMode = UIViewContentModeScaleAspectFit;
}

@end

