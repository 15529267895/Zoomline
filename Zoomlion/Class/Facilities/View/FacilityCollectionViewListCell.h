//
//  FacilityCollectionViewListCell.h
//  Zoomlion
//
//  Created by 王li on 2017/12/31.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacilityCollectionViewListCell : UICollectionViewCell

@property (nonatomic,strong)UIView *subView;
@property (nonatomic,retain)UIImageView *imageView; // 显示图片
@property (nonatomic,retain)UILabel *titleLab, *subTitleLab; // 显示文字

@end