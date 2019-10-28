//
//  FacilitiesViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "FacilitiesViewController.h"
#import "SMVerticalSegmentedControl.h"
#import "WebViewController.h"


#import "FacilitiesModel.h"

#import "FacilityCollectionViewCell.h"
#import "FacilityCollectionViewListCell.h"


@interface FacilitiesViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger intRow;
    int kSegmentedControlWidth;
    int kSegmentedControlHight;
    
    int cellListWid, cellListHig;
    int cellWid, cellHig;
    int cellTypeCount;
}

@property (nonatomic, retain) SMVerticalSegmentedControl *segmentedControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionList;

@property (nonatomic, strong) UIView *segContent;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *leftCars;
@property (nonatomic, strong) NSArray *machineItemsArr;
@property (nonatomic, strong) NSArray *machineItemsListsArr;

@property (nonatomic, strong) NSArray *perMachineModelArr;

@end

@implementation FacilitiesViewController

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        // 滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        _collectionView.tag = 1;
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(kSegmentedControlWidth + 5);
             make.top.equalTo(self.view).offset(5);
             make.right.equalTo(self.view).offset(-5);
             make.height.offset(35);
         }];

        // 如果未设置背景颜色是黑色设置背景颜色
        _collectionView.backgroundColor = colorBackground;
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FacilityCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UICollectionView *)collectionList
{
    if (_collectionList == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
      
        // 滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionList];
        _collectionList.tag = 2;
        
        [_collectionList mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.left.right.equalTo(self.collectionView);
             make.top.equalTo(self.collectionView.mas_bottom).offset(5);
             make.bottom.equalTo(self.view.mas_bottom);
         }];
        
        _collectionList.showsVerticalScrollIndicator = NO;
        // 如果未设置背景颜色是黑色设置背景颜色
        _collectionList.backgroundColor = colorBackground;
        // 设置代理
        _collectionList.delegate = self;
        _collectionList.dataSource = self;
        [_collectionList registerClass:[FacilityCollectionViewListCell class] forCellWithReuseIdentifier:@"CELLList"];
    }
    return _collectionList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isiPad)
    {
        kSegmentedControlWidth = (ScreenWidth - 100)/4;
        kSegmentedControlHight = 60;
        
        cellWid = (ScreenWidth - kSegmentedControlWidth - 20)/3;
        cellHig = 45;

        cellTypeCount = 3;
    }
    else
    {
        kSegmentedControlWidth = 100;
        kSegmentedControlHight = 40;
        
        cellWid = (ScreenWidth - kSegmentedControlWidth - 15)/2;
        cellHig = 32;

        cellTypeCount = 2;
    }
    
    self.leftCars = [NSMutableArray array];
    
    self.segContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSegmentedControlWidth, ScreenHeight)];
    _segContent.backgroundColor = colorBackground;
    [self.view addSubview:_segContent];
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:urlFacilityList params:nil];    
    
    self.dataArr = cacheJson[@"data"];

    if (self.dataArr.count <= 0)
    {
        [Common showMessage:@"暂无数据"];
        return;
    }
    
    for (int i = 0; i < self.dataArr.count; i++)
    {
        FacilitiesModel *model = [FacilitiesModel mj_objectWithKeyValues:self.dataArr[i]];
        [self.leftCars addObject: model.name];
    }
    
    [self configSegment:self.leftCars];
   
    
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
    [self.collectionView reloadData];
//    WWLog(@"ScreenWidth === %f,ScreenHeight=%f",ScreenWidth,ScreenHeight);
    [_collectionList mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.left.right.equalTo(self.collectionView);
         make.top.equalTo(self.collectionView.mas_bottom).offset(5);
         make.bottom.equalTo(self.view.mas_bottom);
     }];

    [self.segContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.offset(kSegmentedControlWidth);
    }];
    [self.collectionList reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 2)
    {
        return self.machineItemsListsArr.count;
    }
    return [self.machineItemsArr  count];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.tag == 1)
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

// 设置最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 设置列的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPad)
    {
        cellListWid = (ScreenWidth - kSegmentedControlWidth - 22)/3;;
        cellListHig = cellListWid - 20;
    }
    else
    {
        cellListWid = (ScreenWidth - kSegmentedControlWidth - 10);
        cellListHig = ScreenHeight * 0.29;
    }
    
    if (isiPad)
    {
        cellWid = (ScreenWidth - kSegmentedControlWidth - 20)/3;
        cellHig = 45;
        
        cellTypeCount = 3;
    }
    else
    {
        cellWid = (ScreenWidth - kSegmentedControlWidth - 15)/2;
        cellHig = 32;
        
        cellTypeCount = 2;
    }
    
    if (collectionView.tag == 2)
    {
        return  CGSizeMake(cellListWid, cellListHig);
    }
    return CGSizeMake(cellWid, cellHig);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 2)
    {
        FacilityListsModel *listModel = self.machineItemsListsArr[indexPath.row];
        
        FacilityCollectionViewListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLList" forIndexPath:indexPath];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,listModel.imageUrl]] placeholderImage:[UIImage imageNamed:@"loadWhite"]];

        cell.titleLab.text = [NSString stringWithFormat:@"%@%@",@"   ",listModel.name];
        
        [Common sizeImageFit:cell.imageView];
        cell.backgroundColor = colorWhite;

        return cell;
    }
    
    FacilityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    FacilitiesItemsModel *subMachinemodel = [FacilitiesItemsModel mj_objectWithKeyValues:self.machineItemsArr[indexPath.row]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",@" ",subMachinemodel.name,@" "];
    if (indexPath.row == intRow)
    {
        cell.textLabel.layer.cornerRadius = 0.5;
        cell.textLabel.layer.borderWidth = 0.8;
        cell.textLabel.layer.borderColor = colorTheme.CGColor;
        cell.textLabel.textColor = colorTheme;
    }
    else
    {
        cell.textLabel.layer.cornerRadius = 0.5;
        cell.textLabel.layer.borderWidth = 0.0;
        cell.textLabel.layer.borderColor = colorTheme.CGColor;
        cell.textLabel.textColor = colorSubtitle;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 2)
    {
        FacilitiesItemsModel *subMachinemodel = [FacilitiesItemsModel mj_objectWithKeyValues:self.machineItemsArr[intRow]];
        FacilityListsModel *listModel = self.machineItemsListsArr[indexPath.row];
        
        WebViewController *vc = [WebViewController new];
        vc.title = @"环卫设备";
        vc.urlReq = urlFacilityDetail;
        vc.urlId = listModel.id;
        vc.view.backgroundColor = colorBackground;
        vc.shareName = subMachinemodel.name;
        vc.shareNum = listModel.name;
//        vc.shareImage = [NSString stringWithFormat:@"%@%@",developHeadAPi,listModel.imageUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        intRow = indexPath.row;
        FacilitiesItemsModel *subMachinemodel = [FacilitiesItemsModel mj_objectWithKeyValues:self.machineItemsArr[indexPath.row]];
        self.machineItemsListsArr = subMachinemodel.lists;
        
        [self.collectionView reloadData];
        [self.collectionList reloadData];
    }
}

- (void)configSegment:(NSArray *)titles
{
    self.segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];
    self.segmentedControl.backgroundColor = colorBackground;
    [self.segmentedControl setTextFont:font14];
    [self.segmentedControl setFrame:CGRectMake(0, 0, kSegmentedControlWidth, titles.count *kSegmentedControlHight)];
    [self.segContent addSubview:self.segmentedControl];
    
    self.segmentedControl.selectedTextColor = [UIColor whiteColor];
    
    self.segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
    self.segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionBoxBorderWidth = 0.01;
    self.segmentedControl.selectionBoxBackgroundColorAlpha = 1.0;
    self.segmentedControl.selectionBoxBorderColorAlpha = 1.0;

    //    默认为0组
    [self firstCarTypeClick:0];
    
//    为segment添加细线
    for (int i = 0; i < titles.count; i++)
    {
        UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, kSegmentedControlHight * (i+1), kSegmentedControlWidth, 1.0)];
        [self.view addSubview:imgLine];
        [self.view bringSubviewToFront:imgLine];
        imgLine.image = [UIImage imageNamed:@"segLine"];
    }
    
    KWeakSelf
    self.segmentedControl.indexChangeBlock = ^(NSInteger index)
    {
        [weakSelf firstCarTypeClick:index];
    };
}

#pragma mark - 点击左栏的一级菜单
- (void)firstCarTypeClick:(NSInteger)sectionIndex
{
    intRow = 0;
    
    FacilitiesModel *model = [FacilitiesModel mj_objectWithKeyValues:self.dataArr[sectionIndex]];
    self.machineItemsArr = model.items;
    
    FacilitiesItemsModel *subMachinemodel = [FacilitiesItemsModel mj_objectWithKeyValues:self.machineItemsArr[0]];
    self.machineItemsListsArr = subMachinemodel.lists;
    
    NSInteger colCount;
    colCount = (model.items.count%cellTypeCount == 0)?(model.items.count/cellTypeCount):(model.items.count/cellTypeCount +1);
    NSInteger colHig = colCount * cellHig + (colCount - 1) * 5;
    
    if (colHig > ScreenHeight/3)
    {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(kSegmentedControlWidth + 5);
             make.top.equalTo(self.view).offset(5);
             make.right.equalTo(self.view).offset(-5);
             make.height.offset(ScreenHeight/3);
         }];
        self.collectionView.scrollEnabled = YES;
        
    }
    else
    {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.view).offset(kSegmentedControlWidth + 5);
             make.top.equalTo(self.view).offset(5);
             make.right.equalTo(self.view).offset(-5);
             make.height.offset(colHig);
         }];
        self.collectionView.scrollEnabled = NO;
        
    }

    [self.collectionView reloadData];
    [self.collectionList reloadData];   //第0组数据刷新
}

@end
