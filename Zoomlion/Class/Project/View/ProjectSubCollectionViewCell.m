
//
//  ProjectSubCollectionViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "ProjectSubCollectionViewCell.h"

@implementation ProjectSubCollectionViewCell
- (UIView *)subView
{
    if (!_subView)
    {
        _subView = [[UIView alloc] init];
        _subView.backgroundColor = colotAlpha;
        [self.imageView addSubview:_subView];
        [_subView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.offset(35);
        }];
    }
    return _subView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];  //WithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        [self.contentView addSubview:_imageView];
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
    }
    return _imageView;
}

- (void)makeLabel:(UILabel *)label textColor:(UIColor *)color
{
    label.textColor = color;
    label.font = fontBoldCustom(12.0);
    label.textAlignment = NSTextAlignmentCenter;
}

- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        [self.subView addSubview:_titleLab];
        [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_subView.mas_left).offset(10);
            make.centerX.bottom.height.equalTo(_subView);
        }];
        [self makeLabel:_titleLab textColor:colorWhite];
    }
    return _titleLab;
}

//- (UILabel *)subTitleLab
//{
//    if (!_subTitleLab)
//    {
//        _subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLab.frame)-5, CGRectGetWidth(self.imageView.bounds) - 20, 20)];
//        [self.subView addSubview:_subTitleLab];
//        [self makeLabel:_subTitleLab textColor:colorTheme];
//    }
//    return _subTitleLab;
//}


@end
