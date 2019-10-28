//
//  SearchViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "SearchViewController.h"

#import "WebViewController.h"

#import "SearchTableViewCell.h"
#import "SearchCollectionViewCell.h"

#import "SearchModel.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIView *searchView;
}

@property (nonatomic, strong) UITableView *searchTab;
@property (nonatomic, strong) UISearchBar *search;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *searchArr, *facilityArr,*equipArr,*projectArr,*pppArr,*solutionArr, *newsArr;

@property (nonatomic, strong) NSMutableDictionary *faciDic, *equipDic, *projectDic, *pppDic, *soluDic, *newsDic;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initArr];
    [self configHisSearch];
    [self configNaviSearch];
    
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
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(46);
    }];
    
    searchView.frame = CGRectMake(80, 0, ScreenWidth - 160, 30);
    _search.frame = CGRectMake(0, 0, ScreenWidth - 160, 30);
    
    [self.searchTab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.searchTab reloadData];
    [self.view bringSubviewToFront:self.searchTab];
}

- (void)initArr
{
    self.searchArr = [NSMutableArray array];
    self.facilityArr = [NSMutableArray array];
    self.equipArr = [NSMutableArray array];
    self.projectArr = [NSMutableArray array];
    self.pppArr = [NSMutableArray array];
    self.solutionArr = [NSMutableArray array];
    self.newsArr = [NSMutableArray array];

    self.faciDic = [NSMutableDictionary dictionary];
    self.equipDic = [NSMutableDictionary dictionary];
    self.projectDic = [NSMutableDictionary dictionary];
    self.pppDic = [NSMutableDictionary dictionary];
    self.soluDic = [NSMutableDictionary dictionary];
    self.newsDic = [NSMutableDictionary dictionary];
}

- (NSArray *)cacheJsonUrl:(NSString *)url
{
    id cacheJson = [XHNetworkCache cacheJsonWithURL:url params:nil];
    return cacheJson[@"data"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [self.view endEditing:YES];

    [XHNetworkCache save_asyncJsonResponseToCacheFile:self.searchArr andURL:urlSearchs params:nil completed:^(BOOL result) {
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSArray *seaArr = [XHNetworkCache cacheJsonWithURL:urlSearchs params:nil];
    
    if (seaArr.count > 0)
    {
        self.searchArr = [seaArr mutableCopy];
        [self.collectionView reloadData];
    }
}

#pragma mark - 请求数据search
- (void)requstSearch:(NSString *)searchText
{
    [self.facilityArr removeAllObjects];
    [self.equipArr removeAllObjects];
    [self.pppArr removeAllObjects];
    [self.projectArr removeAllObjects];
    [self.newsArr removeAllObjects];
    [self.solutionArr removeAllObjects];
    
    if (searchText.length <= 0)
    {
        [Common showMessage:@"请输入关键词"];
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [self searchContents:searchText];

        dispatch_async(dispatch_get_main_queue(), ^{

            if ((self.facilityArr.count + self.equipArr.count + self.pppArr.count + self.projectArr.count + self.newsArr.count + self.solutionArr.count) > 0)
            {
                if (![self.searchArr containsObject:searchText])
                {
                    [self.searchArr addObject:searchText];
                }
            }
            
            [self.searchTab reloadData];
        });

        });
}

- (void)configNaviSearch
{
    searchView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, ScreenWidth - 160, 30)];
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 160, 30)];
    search.delegate = self;
    self.search = search;
    search.backgroundColor = [UIColor clearColor];
    search.placeholder = @"请输入标题关键字";
    UITextField *searchField = [search valueForKey:@"_searchField"];
    searchField.textColor = colorTitle;
    [[[search.subviews objectAtIndex:0].subviews objectAtIndex:1] setTintColor:[UIColor lightGrayColor]];
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.font = [UIFont systemFontOfSize:13.0];
    [searchView addSubview:search];
    self.navigationItem.titleView = searchView;
    searchView.layer.cornerRadius = 5.0;
    searchView.layer.borderWidth = 1.0;
    searchView.layer.masksToBounds = YES;
}

- (void)configHisSearch
{
    UILabel *titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    [titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.centerX.top.equalTo(self.view);
        make.height.offset(45);
    }];
    titleLab.text = @"历史搜索";
    titleLab.textColor = colorTitle;
    titleLab.font = font14;
    
    UIView *line = [UIView new];
    [self.view addSubview:line];
    [line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(titleLab.mas_bottom);
        make.height.offset(0.5);
    }];
    line.backgroundColor = colorTheme;

    UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc] init];
//    flowOut.minimumLineSpacing = 5;
//    flowOut.minimumInteritemSpacing = 5;
    flowOut.estimatedItemSize = CGSizeMake(20, 35);
//    flowOut.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth, ScreenHeight - 46 -64) collectionViewLayout:flowOut];
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = colorWhite;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(46);
    }];
    [self.collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //搜索结果显示
    self.searchTab = [UITableView new];
    [self.view addSubview:self.searchTab];
    [self.searchTab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.view bringSubviewToFront:self.searchTab];
    self.searchTab.tableFooterView = [UIView new];
    
    self.searchTab.delegate = self;
    self.searchTab.dataSource = self;
    
    self.searchTab.hidden = YES;
}

#pragma mark - searchBar Deletegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText != nil && searchText.length > 0)
    {
        [self.searchTab reloadData];//重新加载tableview
    }
    else
    {
        self.searchTab.hidden = YES;
        [self.collectionView reloadData];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchTab.hidden = YES;
    [self.collectionView reloadData];
}

#pragma mark - 点击 开始搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchTab.hidden = NO;
    [searchBar resignFirstResponder];
    [self requstSearch:searchBar.text];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.searchArr count];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(50, 35);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.searchArr[indexPath.row];
    cell.textLabel.textColor = colorTheme;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self requstSearch:self.searchArr[indexPath.row]];
    self.search.text = self.searchArr[indexPath.row];
    self.searchTab.hidden = NO;
    [self.search resignFirstResponder];
}

#pragma mark - tablevewdatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ((self.facilityArr.count + self.equipArr.count + self.pppArr.count + self.projectArr.count + self.newsArr.count + self.solutionArr.count) == 0)
    {
        return 1;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.facilityArr.count + self.equipArr.count + self.pppArr.count + self.projectArr.count + self.newsArr.count + self.solutionArr.count) == 0)
    {
        return ScreenHeight - 60;
    }
    
    return 50 / 375.0 * ((ScreenWidth < ScreenHeight?ScreenWidth:ScreenHeight));
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((self.facilityArr.count + self.equipArr.count + self.pppArr.count + self.projectArr.count + self.newsArr.count + self.solutionArr.count) == 0)
    {
        return 1;
    }
    
    if (section == 0)
    {
        return self.facilityArr.count;
    }
    else if (section == 1)
    {
        return self.equipArr.count;
    }
    else if (section == 2)
    {
        return self.pppArr.count;
    }
    else if (section == 3)
    {
        return self.projectArr.count;
    }
    else if (section == 4)
    {
        return self.newsArr.count;
    }
    
    return self.solutionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ((self.facilityArr.count + self.equipArr.count + self.pppArr.count + self.projectArr.count + self.newsArr.count + self.solutionArr.count) == 0)
    {
        cell.nodataLab.text = @"暂无搜索结果";
        cell.arrow.hidden = YES;
        cell.titleLab.text = @"";
        cell.subTitleLab.text = @"";
        return cell;
    }
    else
    {
        cell.nodataLab.text = @" ";
        cell.arrow.hidden = NO;
    }
    
    if (indexPath.section == 0)
    {
        if (self.facilityArr.count <= 0)
        {
            return nil;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.facilityArr[indexPath.row]];
        cell.titleLab.text = model.name;
        cell.subTitleLab.text = @"环卫设备";

        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (self.equipArr.count <= 0)
        {
            return nil;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.equipArr[indexPath.row]];
        cell.titleLab.text = model.name;
        cell.subTitleLab.text = @"环境装备";

        return cell;
    }
    else if (indexPath.section == 2)
    {
        if (self.pppArr.count <= 0)
        {
            return nil;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.pppArr[indexPath.row]];
        cell.titleLab.text = model.name;
        cell.subTitleLab.text = @"城乡环卫";
        
        return cell;
    }
    else if (indexPath.section == 3)
    {
        if (self.projectArr.count <= 0)
        {
            return nil;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.projectArr[indexPath.row]];
        cell.titleLab.text = model.name;
        cell.subTitleLab.text = @"环境项目";
        
        return cell;
    }
    else if (indexPath.section == 4)
    {
        if (self.newsArr.count <= 0)
        {
            return nil;
        }
        
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.newsArr[indexPath.row]];
        cell.titleLab.text = model.name;
        cell.subTitleLab.text = @"热点新闻";
        return cell;
    }
    
    if (self.solutionArr.count <= 0)
    {
        return nil;
    }
    SearchModel *model = [SearchModel mj_objectWithKeyValues:self.solutionArr[indexPath.row]];
    cell.titleLab.text = model.name;
    cell.subTitleLab.text = @"解决方案";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *vc = [WebViewController new];

    
    if ((self.facilityArr.count + self.equipArr.count + self.pppArr.count + self.projectArr.count + self.newsArr.count + self.solutionArr.count) == 0)
    {
        return ;
    }
    
    if (indexPath.section == 0)
    {
        if (self.facilityArr.count <= 0)
        {
            return ;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.facilityArr[indexPath.row]];
        
        vc.urlId = model.id;
        vc.urlReq = urlFacilityDetail;
        
    }
    else if (indexPath.section == 1)
    {
        if (self.equipArr.count <= 0)
        {
            return;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.equipArr[indexPath.row]];
        vc.urlId = model.id;
        vc.urlReq = urlEquipmentDetail;
    }
    else if (indexPath.section == 2)
    {
        if (self.pppArr.count <= 0)
        {
            return ;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.pppArr[indexPath.row]];
        vc.urlId = model.id;
        vc.urlReq = urlPPPDetail;
    }
    else if (indexPath.section == 3)
    {
        if (self.projectArr.count <= 0)
        {
            return ;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.projectArr[indexPath.row]];
        vc.urlId = model.id;
        vc.urlReq = urlProjectDetail;
    }
    else if (indexPath.section == 4)
    {
        if (self.newsArr.count <= 0)
        {
            return ;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.newsArr[indexPath.row]];
        vc.urlId = model.id;
        vc.urlReq = urlHotNewsDetail;
    }
    else if (indexPath.section == 5)
    {
        if (self.solutionArr.count <= 0)
        {
            return ;
        }
        SearchModel *model = [SearchModel mj_objectWithKeyValues:self.solutionArr[indexPath.row]];
        vc.urlId = model.id;
        vc.urlReq = urlSolutionDetail;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 遍历 搜索内容
- (void)searchContents:(NSString *)searchText
{
    //    环卫设备
    NSArray *faciArr = [self cacheJsonUrl:urlFacilityList];
    
    for (NSDictionary *dataDic in faciArr)
    {
        for (NSDictionary *itemDic in dataDic[@"items"])
        {
            for (NSDictionary *itemListDic in itemDic[@"lists"])
            {
                NSRange titleResult = [itemListDic[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0)
                {
                    [self.facilityArr addObject:itemListDic];
                    WWLog(@"arrfaci===%@",itemListDic[@"name"]);
                }
            }
        }
    }
    
    //    环境装备
    NSArray *eqArr = [self cacheJsonUrl:urlEquipmentList];
    
    for (NSDictionary *dataDic in eqArr)
    {
        NSRange titleResult = [dataDic[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (titleResult.length > 0)
        {
            [self.equipArr addObject:dataDic];
            WWLog(@"equipArr===%@",dataDic[@"name"]);
        }
        
    }
    //    城乡环卫
    NSArray *ppArr = [self cacheJsonUrl:urlPPP];
    
    for (NSDictionary *dataDic in ppArr)
    {
        for (NSDictionary *listDic in dataDic[@"lists"])
        {
            NSRange titleResult = [listDic[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0)
            {
                [self.pppArr addObject:listDic];
                WWLog(@"pppArr===%@",listDic[@"name"]);
            }
        }
        
    }
    
    //    新闻热点
    NSArray *hotArr = [self cacheJsonUrl:urlHotNewsList];
    
    for (NSDictionary *dicData in hotArr)
    {
        NSRange titleResult = [dicData[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (titleResult.length > 0)
        {
            [self.newsArr addObject:dicData];
            WWLog(@"newsArr===%@",dicData[@"name"]);
        }
    }
    
    //    环境项目
    NSArray *proArr = [self cacheJsonUrl:urlProjectList];
    
    NSMutableArray *projctTitleNameArr = [NSMutableArray array];
    for (NSDictionary *dicData in proArr)
    {
        for (NSDictionary *listDic in dicData[@"lists"])
        {
            NSRange titleResult = [listDic[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length > 0)
            {
                [self.projectArr addObject:listDic];
                WWLog(@"projectArr===%@",listDic[@"name"]);
            }
        }
        
        NSString *name = (dicData[@"view"])[@"name"];
        [projctTitleNameArr addObject:name];
    }
    
    //    解决方案
    NSArray *solArr = [self cacheJsonUrl:urlSolutionList];
    
    for (NSDictionary *dicData in solArr)
    {
        NSRange titleResult = [dicData[@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (titleResult.length > 0)
        {
            [self.solutionArr addObject:dicData];
            WWLog(@"solutionArr===%@",dicData[@"name"]);
        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.search resignFirstResponder];
}
@end
