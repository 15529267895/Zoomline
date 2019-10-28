//
//  ProjectSubViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "ProjectSubViewController.h"
#import "ProjectSubCollectionViewCell.h"

#import "WebViewController.h"



@interface ProjectSubViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    int cellWid;
    int cellHig;
    UIView *line;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ProjectSubViewController

- (UICollectionView *)collectionView
{
  
    
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.left.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
         }];
        
        // 如果未设置背景颜色是黑色设置背景颜色
        _collectionView.backgroundColor = colorBackground;
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ProjectSubCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    }
    
    [self.view bringSubviewToFront:line];

    return _collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    line = [UIView new];
    [self.view addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.top.left.right.equalTo(self.view);
        make.height.offset(0.39);
    }];
    line.backgroundColor = colorSubtitle;
    [self.view bringSubviewToFront:line];

}

-(void)setModel:(ProjectModel *)model
{
    _model = model;
    self.dataArr = model.lists;
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
    //    [self getCellSize];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.collectionView reloadData];
}

#pragma mark - collection代理
// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5 );
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
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

    return CGSizeMake(cellWid,cellHig);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListModel *listModel = [ProjectListModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    
    ProjectSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    NSURL *urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,listModel.imageUrl]];
    [cell.imageView sd_setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"load"]];

    cell.titleLab.text = listModel.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListModel *listModel = [ProjectListModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];

    WebViewController *vc = [WebViewController new];
    vc.urlId = listModel.id;
    vc.urlReq = urlProjectDetail;
    vc.title = @"环境项目";
    
    vc.shareName = self.shareName;
    vc.shareNum = listModel.name;
//    vc.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,listModel.imageUrl]]]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
