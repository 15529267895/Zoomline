//
//  EquipmentSubCollectionViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "EquipmentSubCollectionViewCell.h"

@implementation EquipmentSubCollectionViewCell

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
        _imageView = [[UIImageView alloc] init];
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
    label.textAlignment = NSTextAlignmentLeft;
}

- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        [self.subView addSubview:_titleLab];
        [self makeLabel:_titleLab textColor:colorWhite];
        
        [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_subView).offset(10);
            make.top.centerX.equalTo(_subView);
            make.height.offset(20);
        }];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab
{
    if (!_subTitleLab)
    {
        _subTitleLab = [[UILabel alloc] init];
        [self.subView addSubview:_subTitleLab];
        [self makeLabel:_subTitleLab textColor:colorTheme];
        
        [_subTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(_subView);
            make.height.offset(20);
            make.left.equalTo(_subView).offset(10);
        }];
    }
    return _subTitleLab;
}


@end
