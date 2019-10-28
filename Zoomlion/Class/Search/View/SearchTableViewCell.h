//
//  SearchTableViewCell.h
//  Zoomlion
//
//  Created by 王li on 2017/11/13.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab, *subTitleLab;
@property (nonatomic, strong) UILabel *nodataLab;
@property (nonatomic, strong) UIImageView *arrow;
@end
