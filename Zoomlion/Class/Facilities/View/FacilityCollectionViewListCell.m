//
//  FacilityCollectionViewListCell.m
//  Zoomlion
//
//  Created by 王li on 2017/12/31.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "FacilityCollectionViewListCell.h"

@implementation FacilityCollectionViewListCell

- (UIView *)subView
{
    if (!_subView)
    {
        _subView = [[UIView alloc] init];
        _subView.backgroundColor = colotAlpha;
        [self addSubview:_subView];
        
        [_subView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.centerX.equalTo(self);
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
        [self addSubview:_imageView];
        
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.center.equalTo(self);
            make.top.equalTo(self).offset(10);
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
        [self makeLabel:_titleLab textColor:colorWhite];
        
        [_titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(_subView);
        }];
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
