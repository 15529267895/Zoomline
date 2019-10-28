//
//  SearchTableViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/11/13.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configView];
    }
    return self;
}

- (void)configView
{
    UILabel *titleLab= [UILabel new];
    [self addSubview:titleLab];
    [titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    UILabel *subTitle = [UILabel new];
    [self addSubview:subTitle];
    [subTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLab);
        make.centerY.equalTo(self.mas_centerY).offset(10);
    }];
    
    titleLab.textColor = colorTheme;
    subTitle.textColor = colorSubtitle;
    titleLab.font = font13;
    subTitle.font = font11;
    subTitle.numberOfLines = 0;
    
    self.nodataLab = [UILabel new];
    [self addSubview:self.nodataLab];
    [self.nodataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.centerY.right.equalTo(self);
    }];
    self.nodataLab.textAlignment = NSTextAlignmentCenter;
    self.nodataLab.textColor = colorSubtitle;
//    _nodataLab.font =
    
    UIImageView *arrow = [UIImageView new];
    self.arrow = arrow;
    [self addSubview:arrow];
    arrow.image = [UIImage imageNamed:@"rightrow"];
    [arrow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.offset(10);
        make.height.offset(15);
        make.centerY.equalTo(self);
    }];
    
    self.titleLab = titleLab;
    self.subTitleLab = subTitle;
}



@end
