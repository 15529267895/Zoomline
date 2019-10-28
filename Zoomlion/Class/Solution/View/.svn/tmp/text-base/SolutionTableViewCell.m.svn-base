//
//  SolutionTableViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "SolutionTableViewCell.h"

@implementation SolutionTableViewCell

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
    
}

- (UIImageView *)imageView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
        [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self).insets(UIEdgeInsetsMake(5, 5, 0, 5));
        }];
//        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

@end
