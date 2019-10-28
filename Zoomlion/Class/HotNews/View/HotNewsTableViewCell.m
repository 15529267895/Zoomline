//
//  HotNewsTableViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/11/17.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "HotNewsTableViewCell.h"

@implementation HotNewsTableViewCell

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
    UIView *content = [UIView new];
    [self addSubview:content];
    [content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    content.backgroundColor = colorWhite;
    
    UIImageView *img = [UIImageView new];
    [content addSubview:img];
    [img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(content).offset(10);
        make.centerY.equalTo(content);
        make.width.equalTo(img.mas_height).multipliedBy(3.0/2.0);
    }];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    
    UILabel *titleLab = [UILabel new];
    [content addSubview:titleLab];
    [titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(10);
        make.right.equalTo(content.mas_right).offset(-10);
        make.top.equalTo(img);
    }];
    [self makeLabel:titleLab andFont:font14 andTextColor:colorTitle];
    
    UILabel *timeLab = [UILabel new];
    [content addSubview:timeLab];
    [timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLab);
        make.bottom.equalTo(img);
        make.height.offset(15);
    }];
    
    timeLab.textAlignment = NSTextAlignmentRight;
    [self makeLabel:timeLab andFont:font11 andTextColor:colorSubtitle];
    
    UILabel *detailLab = [UILabel new];
    [content addSubview:detailLab];
    [detailLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLab);
        make.bottom.equalTo(timeLab.mas_top).offset(-5);
        make.top.equalTo(titleLab.mas_bottom).offset(10);
    }];
    [self makeLabel:detailLab andFont:font12 andTextColor:colorSubtitle];
    detailLab.numberOfLines = 0;
    
    self.imgView = img;
    self.titleLab = titleLab;
    self.detailLab = detailLab;
}

- (void)makeLabel:(UILabel *)label andFont:(UIFont *)font andTextColor:(UIColor *)color
{
    label.font = font;
    label.textColor = color;
}

@end
