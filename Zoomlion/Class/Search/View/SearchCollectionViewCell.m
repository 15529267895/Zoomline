//
//  SearchCollectionViewCell.m
//  Zoomlion
//
//  Created by 王li on 2017/12/3.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "SearchCollectionViewCell.h"

#define itemHeight 25

@implementation SearchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 用约束来初始化控件:
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment =NSTextAlignmentCenter;
        self.textLabel.layer.cornerRadius = 5.0;
        self.textLabel.layer.masksToBounds = YES;
        self.textLabel.backgroundColor = colorBackground;
        self.textLabel.font = font13;
        [self.contentView addSubview:self.textLabel];
//#pragma mark — 如果使用CGRectMake来布局,是需要在preferredLayoutAttributesFittingAttributes方法中去修改textlabel的frame的
        // self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
#pragma mark — 如果使用约束来布局,则无需在preferredLayoutAttributesFittingAttributes方法中去修改cell上的子控件l的frame
      
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make)
        {
            // make 代表约束:
            make.top.equalTo(self.contentView).with.offset(0);   // 对当前view的top进行约束,距离参照view的上边界是 :
            make.left.equalTo(self.contentView).with.offset(0);  // 对当前view的left进行约束,距离参照view的左边界是 :
            make.height.equalTo(@itemHeight);                // 高度
            make.right.equalTo(self.contentView).with.offset(0); // 对当前view的right进行约束,距离参照view的右边界是 :
        }];
    }
    return self;
}

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size]; // 获取自适应size
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = itemHeight;
    
    newFrame.size.width = size.width + 6; // 不同屏幕适配
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

@end

