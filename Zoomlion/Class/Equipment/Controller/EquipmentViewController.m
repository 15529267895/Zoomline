//
//  EquipmentViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "EquipmentViewController.h"
#import "EquipmentSubCollectionViewCell.h"
#import "WebViewController.h"

#import "EquipmentModel.h"


@interface EquipmentViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    int cellWid;
    int cellHig;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation EquipmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configView];
    

    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:urlEquipmentList params:nil];
    self.dataArr = cacheJson[@"data"];
    
    if (self.dataArr.count <= 0)
    {
        [Common showMessage:@"暂无数据"];
        return;
    }
    
    [self.collectionView reloadData];
    
    if (isiPad)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(updateOrientation)
                                                    name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

#pragma mark - 屏幕旋转
- (void)updateOrientation
{
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.collectionView reloadData];
}

- (void)configView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    [collectionView registerClass:[EquipmentSubCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];

    [collectionView mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.left.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
     }];
    
    // 如果未设置背景颜色是黑色设置背景颜色
    collectionView.backgroundColor = colorBackground;
    // 设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
}

- (void)getCellSize
{
    if (isiPad)
    {
        cellWid = (ScreenWidth - 20)/3;
        cellHig = cellWid - 20;
    }
    else
    {
        cellWid = (ScreenWidth - 15)/2;
        cellHig = cellWid - 20;
    }
}

#pragma mark - collectionView

// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 设置列的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self getCellSize];
    return CGSizeMake(cellWid, cellHig);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EquipmentModel *model = [EquipmentModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    EquipmentClassModel *viewSubModel = [EquipmentClassModel mj_objectWithKeyValues:model.hjzbfl];
    
    EquipmentSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
  
    NSURL *urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,model.imageUrl]];
        
    [cell.imageView sd_setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"load"] options:SDWebImageRefreshCached];
//    [Common scaleImage:cell.imageView];
    [Common scaleImage:cell.imageView.image toSize:CGSizeMake(cellWid, cellHig)];

    cell.subTitleLab.text = model.name;
    cell.titleLab.text = viewSubModel.name;

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EquipmentModel *model = [EquipmentModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    EquipmentClassModel *viewSubModel = [EquipmentClassModel mj_objectWithKeyValues:model.hjzbfl];
    
    WebViewController *vc = [WebViewController new];
    vc.title = @"环境装备";
    vc.urlReq = urlEquipmentDetail;
    vc.urlId = model.id;
    
    vc.shareName = model.name;
    vc.shareNum = viewSubModel.name;
//    vc.shareImage = [NSString stringWithFormat:@"%@%@",developHeadAPi,model.imageUrl];
    
    vc.view.backgroundColor = colorBackground;
    [self.navigationController pushViewController:vc animated:YES];
}

@end






