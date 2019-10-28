//
//  FacilityCollectionViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/12/3.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "FacilityCollectionViewCell.h"

@implementation FacilityCollectionViewCell

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_textLabel];
        _textLabel.textColor = colorSubtitle;
        _textLabel.font = fontBoldCustom(13.0);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        
        [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(0.5);
            make.right.bottom.equalTo(self).offset(-0.5);
        }];
    }
    return _textLabel;
}

@end


