
//
//  HomeViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "HomeViewController.h"
#import "FacilitiesViewController.h"
#import "EquipmentViewController.h"
#import "PPPViewController.h"
#import "ProjectViewController.h"
#import "SolutionViewController.h"
#import "HotNewsViewController.h"
#import "SettingsViewController.h"
#import "SearchViewController.h"
#import "HomeBarnnerModel.h"

#import "WebViewController.h"

#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"


@interface HomeViewController ()<UISearchBarDelegate,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,UIScrollViewDelegate>
{
    UIImageView *companyImgView, *solutionImgView, *facilitiesImgView, *equipmentImgView, *pppImgView, *projectImgView, *hotNewsImgView;
    UIImageView *comImg, *soluImg, *faciImg, *hotImg, *eqImg, *pImg, *proImg;
    UILabel *comLab, *solLab, *facLab, *hotLab, *eqLab, *pLab, *proLab;
    UILabel *comLab2, *solLab2, *facLab2, *hotLab2, *eqLab2, *pLab2, *proLab2;
    UIView *searchView;
    UISearchBar *search;
    UIButton *searchBtn;
    float barnnerHig, bottomViewHig;
}

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) int topValue;

@end

@implementation HomeViewController

- (UIImageView *)imgView
{
    UIImageView *imgView = [UIImageView new];
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    
    return imgView;
}

- (UILabel *)lab
{
    UILabel *lab = [UILabel new];
    [self.imgView addSubview:lab];
    lab.numberOfLines = 0;
    lab.textColor = [UIColor whiteColor];
    lab.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    lab.shadowOffset = CGSizeMake(1, 1);
    
    lab.font = font16;
    
    return lab;
}

- (void)currentViewController
{
    NSArray *controllerArr = self.navigationController.viewControllers;
    if (controllerArr.count == 1)
    {
        [self requestNoticeUpdate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KWeakSelf;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"enterForeground" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
     {
         [weakSelf currentViewController];
     }];
    
    if (iPhoneX)
    {
        _topValue = -88;
    }
    else
    {
        _topValue = -64;
    }
    self.barnnerArr = [NSMutableArray array];
    
    [self configSearchBar];
    
    [self configView];
    
    self.view.backgroundColor = colorWhite;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.barnnerArr removeAllObjects];
    id cache = [XHNetworkCache cacheJsonWithURL:urlBanner];
    
    if (cache != nil)
    {
        for (NSDictionary *dic in cache[@"data"])
        {
            [self.barnnerArr addObject:[NSString stringWithFormat:@"%@%@",developHeadAPi,dic[@"imgUrl"]]];
        }
    }
    _pageControl.numberOfPages = self.barnnerArr.count;
}

#pragma mark - 基本布局
- (void)configView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.scrollView];
   
    [self congifSubView];
    [self updateOrientation];
}

#pragma mark - 基本约束 添加 pagecontroller
- (void)updateOrientation
{
    [self makeConstraintWid:ScreenWidth andHig:ScreenHeight];
    
    [self addPagerView];
    [self addPageControl];
    
    _pageControl.numberOfPages = self.barnnerArr.count;
}

#pragma mark -  屏幕旋转
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self makeConstraintWid:size.width andHig:size.height];
}

#pragma mark -
#pragma mark - -------------添加约束----------
#pragma mark -
- (void)makeConstraintWid:(CGFloat)nowWid andHig:(CGFloat)nowHig
{
    [self makeBarHightViewWidth:nowWid heigh:nowHig];
    
    if (isiPad)    //ipad
    {
        searchView.frame = CGRectMake(80, 0, nowWid - 160, 30);
        
        self.contentView.frame = CGRectMake(10, barnnerHig + 10 + _topValue, nowWid - 20, [self makeContentHightViewWidth:nowWid heigh:nowHig]);
    }
    else          //手机
    {
        searchView.frame = CGRectMake(0, 0, nowWid - 160, 30);
    }
    
    search.frame = CGRectMake(0, 0, nowWid - 160, 30);
    
    _scrollView.backgroundColor = colorBackground;
    
    [self makeContraintsSubViewWidth:nowWid heigh:nowHig];
}

#pragma mark - content-Hight
- (float)makeContentHightViewWidth:(float)width heigh:(float)heigh
{
    float coViewHig;
    if ((width > heigh?width:heigh) *2/3 > heigh - barnnerHig - 20)
    {
        coViewHig = (width > heigh?width:heigh) *2/3;
    }
    else
    {
        coViewHig = heigh - barnnerHig - 20;
    }
    
    self.scrollView.contentSize = CGSizeMake(0, coViewHig + 20 + barnnerHig + _topValue
                                             );
    
    return coViewHig;
}

#pragma mark - 获取 barnner高度
- (float)makeBarHightViewWidth:(float)width heigh:(float)heigh
{
        CGSize imgSize = CGSizeMake(750, 360);
//        if (self.barnnerArr.count > 0)
//        {
//            imgSize  = [UIImage getImageSizeWithURL:self.barnnerArr[0]];
//            NSLog(@"%f,%f,%f", imgSize.height,ScreenHeight,ScreenWidth);
//        }
        return barnnerHig = width/(imgSize.width/imgSize.height);
}

#pragma mark - 子控件的创建
- (void)congifSubView
{
    [self makeBarHightViewWidth:ScreenWidth heigh:ScreenHeight];
    
    NSInteger contentHig;
    if (isiPad)
    {
        _scrollView.scrollEnabled = YES;//    控制控件是否能滚动（默认YES）
        contentHig = ScreenHeight *2/3 - 35;
    }
    else  //手机
    {
        _scrollView.scrollEnabled = NO;
        contentHig = ScreenHeight - barnnerHig - 20;
    }
    
    [self addPagerView];
    [self addPageControl];
    
    _pageControl.numberOfPages = self.barnnerArr.count;
    
    if (isiPad)
    {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,  0 + _topValue, 1, 1)];
    }
    else
    {   //iPhone
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(10, barnnerHig + 10 + _topValue, ScreenWidth - 20, contentHig)];
    }
    
    [self.scrollView addSubview:self.contentView];
    
    _scrollView.delegate = self;
    //    是否有弹簧效果
    _scrollView.bounces = YES;
    //    是否显示滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //    注意点:千万不要通过索引去subviews数组访问scrollView子控件
    [_scrollView.subviews.firstObject removeFromSuperview];
    //自动调整宽高
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    if (isiPad)
    {
        _scrollView.scrollEnabled = YES;//    控制控件是否能滚动（默认YES）
    }
    else
    {
        _scrollView.scrollEnabled = NO;
    }
    
    companyImgView = self.imgView;
    companyImgView.backgroundColor = colorHex(0XB1CC55);
    
    comImg = [UIImageView new];
    [companyImgView addSubview:comImg];
    
    comImg.contentMode = UIViewContentModeScaleAspectFit;
    comImg.image = [UIImage imageNamed:@"company"];
    
    comLab = self.lab;
    [companyImgView addSubview:comLab];
    
    comLab.text = @"公司介绍";
    comLab2 = self.lab;
    [companyImgView addSubview:comLab2];
    
    comLab2.text = @"COMPANY\nINTRODUCTION";
    
    solutionImgView = self.imgView;
    
    solutionImgView.backgroundColor = colorHex(0XEA916D);
    
    soluImg = [UIImageView new];
    [solutionImgView addSubview:soluImg];
    
    soluImg.contentMode = UIViewContentModeScaleAspectFit;
    soluImg.image = [UIImage imageNamed:@"solution"];
    
    solLab = self.lab;
    [solutionImgView addSubview:solLab];
    
    solLab.text = @"解决方案";
    
    solLab2 = self.lab;
    [solutionImgView addSubview:solLab2];
    
    solLab2.text = @"SOLUTION";
    
    facilitiesImgView = self.imgView;
    
    facilitiesImgView.backgroundColor = colorHex(0X90CB54);
    
    faciImg = [UIImageView new];
    [facilitiesImgView addSubview:faciImg];
    
    faciImg.contentMode = UIViewContentModeScaleAspectFit;
    faciImg.image = [UIImage imageNamed:@"facility"];
    
    facLab = self.lab;
    [facilitiesImgView addSubview:facLab];
    
    facLab.text = @"环卫设备";
    
    facLab2 = self.lab;
    [facilitiesImgView addSubview:facLab2];
    
    facLab2.text = @"FACILITIES";
    
    equipmentImgView = self.imgView;
    
    equipmentImgView.backgroundColor = colorHex(0X77B6F7);
    
    eqImg = [UIImageView new];
    [equipmentImgView addSubview:eqImg];
    
    eqImg.contentMode = UIViewContentModeScaleAspectFit;
    eqImg.image = [UIImage imageNamed:@"equipment"];
    
    eqLab = self.lab;
    [equipmentImgView addSubview:eqLab];
    
    eqLab.text = @"环境装备";
    
    eqLab2 = self.lab;
    [equipmentImgView addSubview:eqLab2];
    
    eqLab2.text = @"EQUIPMENT";
    
    pppImgView = self.imgView;
    
    pppImgView.backgroundColor = colorHex(0XB1CC55);
    
    pImg = [UIImageView new];
    [pppImgView addSubview:pImg];
    
    pImg.contentMode = UIViewContentModeScaleAspectFit;
    pImg.image = [UIImage imageNamed:@"ppp"];
    
    pLab = self.lab;
    [pppImgView addSubview:pLab];
    
    pLab2 = self.lab;
    [pppImgView addSubview:pLab2];
    
    if (isiPad)
    {
        pLab.text = @"城乡环卫PPP";
        pLab2.text = @"SANITARY PPP";
    }
    else
    {
        pLab.text = @"城乡环卫";
        pLab2.text = @"SANITARY";
    }
    
    projectImgView = self.imgView;
    
    projectImgView.backgroundColor = colorHex(0X7690E1);
    
    proImg = [UIImageView new];
    [projectImgView addSubview:proImg];
    
    proImg.contentMode = UIViewContentModeScaleAspectFit;
    proImg.image = [UIImage imageNamed:@"project"];
    
    proLab = self.lab;
    [projectImgView addSubview:proLab];
    
    proLab.text = @"环境项目";
    
    proLab2 = self.lab;
    [projectImgView addSubview:proLab2];
    
    proLab2.text = @"PROJECT";
    
    hotNewsImgView = self.imgView;
    
    hotNewsImgView.backgroundColor = colorHex(0XD97775);
    
    hotImg = [UIImageView new];
    [hotNewsImgView addSubview:hotImg];
    
    hotImg.contentMode = UIViewContentModeScaleAspectFit;
    hotImg.image = [UIImage imageNamed:@"hotnews"];
    
    hotLab = self.lab;
    [hotNewsImgView addSubview:hotLab];
    
    hotLab.text = @"热点新闻";
    
    hotLab2 = self.lab;
    [hotNewsImgView addSubview:hotLab2];
    
    hotLab2.text = @"HOT NEWS";
    
    comLab2.font = solLab2.font = facLab2.font = hotLab2.font = eqLab2.font = pLab2.font = proLab2.font = font13;
}

#pragma mark - 子控件的约束
- (void)makeContraintsSubViewWidth:(float)nowWid heigh:(float)nowHig
{
    float contentHeight;
    float leftLabelValue, widthMultiply, leftNewsValue;
    if (isiPad)
    {
        contentHeight = [self makeContentHightViewWidth:nowWid heigh:nowHig];
        leftLabelValue = 35;
        widthMultiply = 0.8;
        leftNewsValue = 0.85;
    }
    else
    {
        contentHeight = (nowHig - barnnerHig - 20);
        leftLabelValue = 10;
        widthMultiply = 0.67;
        leftNewsValue = 0.75;
    }
    
    [companyImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.right.equalTo(_contentView.mas_centerX).offset(-3);
        make.height.offset(contentHeight*11/18);
    }];
    
    [comImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(companyImgView);
        make.width.equalTo(companyImgView).multipliedBy(0.8);
        make.height.equalTo(companyImgView).multipliedBy(0.6);
    }];
    
    [comLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyImgView).offset(leftLabelValue);
        make.top.equalTo(companyImgView).offset(leftLabelValue + 5);
    }];
    
    [comLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(comLab);
        make.top.equalTo(comLab.mas_bottom);
    }];
    
    [solutionImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(companyImgView);
        make.top.equalTo(companyImgView.mas_bottom).offset(6);
        make.bottom.equalTo(self.contentView);
    }];
    
    [soluImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(solutionImgView);
        make.width.equalTo(solutionImgView).multipliedBy(widthMultiply);
        make.height.equalTo(solutionImgView).multipliedBy(0.6);
    }];
    
    [solLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(solutionImgView).offset(leftLabelValue);
        make.top.equalTo(solutionImgView).offset(leftLabelValue + 5);
    }];
    
    [solLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(solLab);
        make.top.equalTo(solLab.mas_bottom);
    }];
    
    
    [facilitiesImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.left.equalTo(companyImgView.mas_right).offset(6);
        make.height.offset(contentHeight*84/367);
    }];
    
    [faciImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(facilitiesImgView);
        make.width.equalTo(facilitiesImgView).multipliedBy(0.5);
        make.height.equalTo(facilitiesImgView).multipliedBy(0.75);
    }];
    
    [facLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(facilitiesImgView).offset(leftLabelValue);
        make.top.equalTo(facilitiesImgView).offset(leftLabelValue + 5);
    }];
    
    [facLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(facLab);
        make.top.equalTo(facLab.mas_bottom);
    }];
    
    [equipmentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.equalTo(facilitiesImgView);
        make.top.equalTo(facilitiesImgView.mas_bottom).offset(6);
    }];
    
    [eqImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(equipmentImgView);
        make.width.equalTo(equipmentImgView).multipliedBy(0.5);
        make.height.equalTo(equipmentImgView).multipliedBy(0.75);
    }];
    
    [eqLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(equipmentImgView).offset(leftLabelValue);
        make.top.equalTo(equipmentImgView).offset(leftLabelValue + 5);
    }];
    
    [eqLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(eqLab);
        make.top.equalTo(eqLab.mas_bottom);
    }];
    
    [pppImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.equalTo(facilitiesImgView);
        make.top.equalTo(equipmentImgView.mas_bottom).offset(6);
    }];
    
    [pImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(pppImgView);
        make.width.equalTo(pppImgView).multipliedBy(0.5);
        make.height.equalTo(pppImgView).multipliedBy(0.75);
    }];
    
    [pLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pppImgView).offset(leftLabelValue);
        make.top.equalTo(pppImgView).offset(leftLabelValue + 5);
    }];
    
    [pLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(pLab);
        make.right.equalTo(pImg.mas_left);
        make.top.equalTo(pLab.mas_bottom);
    }];
    
    [projectImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(facilitiesImgView);
        make.top.equalTo(pppImgView.mas_bottom).offset(6);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(pppImgView.mas_centerX).offset(-3);
    }];
    
    [proImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(projectImgView);
        make.width.equalTo(projectImgView).multipliedBy(leftNewsValue);
        make.height.equalTo(projectImgView).multipliedBy(0.45);
        make.centerX.equalTo(projectImgView.mas_centerX).offset(-30);
    }];
    
    [proLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(projectImgView);
        make.top.equalTo(projectImgView).offset(leftLabelValue + 5);
    }];
    
    [proLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(proLab);
        make.top.equalTo(proLab.mas_bottom);
    }];
    
    [hotNewsImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.height.equalTo(projectImgView);
        make.left.equalTo(projectImgView.mas_right).offset(6);
        
    }];
    
    [hotImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(hotNewsImgView);
        make.width.equalTo(hotNewsImgView).multipliedBy(leftNewsValue);
        make.height.equalTo(hotNewsImgView).multipliedBy(0.45);
        make.centerX.equalTo(hotNewsImgView.mas_centerX).offset(-30);
    }];
    
    [hotLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hotNewsImgView);
        make.top.equalTo(hotNewsImgView).offset(leftLabelValue + 5);
    }];
    
    [hotLab2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hotLab);
        make.top.equalTo(hotLab.mas_bottom);
    }];
}

#pragma mark - ------------barnner 创建 及 布局----------------

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [_pagerView reloadData];
    _pagerView.frame = CGRectMake(0, _topValue, CGRectGetWidth(self.view.frame), barnnerHig);
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
}

- (void)addPagerView
{
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.layer.borderWidth = 0;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 4.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.scrollView addSubview:pagerView];
    _pagerView = pagerView;
}

- (void)addPageControl
{
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
 
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
}

#pragma mark - barnner相关 请求 及 代理
- (void)getBarnner:(NSMutableArray *)barnnerArr
{
    self.barnnerArr = barnnerArr;
    _pageControl.numberOfPages = barnnerArr.count;
    [_pagerView reloadData];
}

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView
{
    return self.barnnerArr.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.barnnerArr[index]]];
    
    return cell;
}

-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    [self clickBarnner:index];
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView
{
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
}


- (void)clickBarnner:(NSInteger)index
{
    id cache = [XHNetworkCache cacheJsonWithURL:urlBanner];
    NSArray *dataArr = cache[@"data"];
    
    NSDictionary *dic = dataArr[index];
    NSString *imgUrl = dic[@"imgHref"];
    NSString *restStr = [imgUrl substringFromIndex:developWebApi.length];
    NSString *titleStr;
    
    if ([restStr containsString:@"hwsb_detail"])
    {
        titleStr = @"环卫设备详情";
    }
    else if([restStr containsString:@"hjzb_detail"])
    {
        titleStr = @"环境装备详情";
    }
    else if([restStr containsString:@"jjfa_detail"])
    {
        titleStr = @"解决方案详情";
    }
    else if([restStr containsString:@"cxhw_detail"])
    {
        titleStr = @"城乡环卫详情";
    }
    else if([restStr containsString:@"hjxm_detail"])
    {
        titleStr = @"环境项目详情";
    }
    else if([restStr containsString:@"news_detail"])
    {
        titleStr = @"新闻详情";
    }
    else if([restStr containsString:@"gsjs"])
    {
        titleStr = @"公司介绍";
    }
    
    WebViewController *vc = [WebViewController new];
    vc.urlReq = restStr;
    vc.title = titleStr;
    vc.shareName = titleStr;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转到具体界面
- (void)clickCategory:(UITapGestureRecognizer *)gesture
{
    UIView *viewclick = [gesture view];
    if (viewclick == companyImgView)
    {
        WebViewController *vc = [WebViewController new];
        //        webVC.urlStr = @"http://www.iyuncimi.com:8080/zoomlion-web/w/gsjs";
        vc.urlReq = @"gsjs";
        vc.title = @"公司介绍";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (viewclick == solutionImgView)
    {
        SolutionViewController *controller = [SolutionViewController new];
        controller.title = @"解决方案";
        controller.view.backgroundColor = colorBackground;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (viewclick == facilitiesImgView)
    {
        FacilitiesViewController *controller = [FacilitiesViewController new];
        controller.title = @"环卫设备";
        controller.view.backgroundColor = colorHex(0XC8C8C8);
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (viewclick == equipmentImgView)
    {
        EquipmentViewController *controller = [EquipmentViewController new];
        controller.title = @"环境装备";
        controller.view.backgroundColor = colorBackground;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (viewclick == pppImgView)
    {
        PPPViewController *controller = [PPPViewController new];
        controller.title = @"城乡环卫PPP";
        controller.view.backgroundColor = colorBackground;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (viewclick == projectImgView)
    {
        ProjectViewController *controller = [ProjectViewController new];
        controller.title = @"环境项目";
        controller.view.backgroundColor = colorBackground;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (viewclick == hotNewsImgView)
    {
        HotNewsViewController *controller = [HotNewsViewController new];
        controller.title = @"热点新闻";
        controller.view.backgroundColor = colorBackground;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - searchBar 控件
- (void)configSearchBar
{
    searchView = [[UIView alloc] init];
    search = [[UISearchBar alloc] init];
    
    search.delegate = self;
    search.layer.borderWidth = 0.5;
    search.layer.borderColor = colotAlpha.CGColor;
    search.layer.cornerRadius = 10.0;
    search.layer.masksToBounds = YES;
    
    search.placeholder = @"请输入相关车名";
    UITextField *searchField = [search valueForKey:@"_searchField"];
    searchField.textColor = colorTitle;
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.font = [UIFont systemFontOfSize:13.0];
    //    searchField.enabled = NO;
    search.alpha = 0.8;
    
    [searchView addSubview:search];
    
    self.navigationItem.titleView = searchView;
    
    [self.navigationItem.titleView addTarget:self action:@selector(searchClick)];
    //    searchView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Set-up"] style:UIBarButtonItemStylePlain target:self action:@selector(settingView)];
    [self.navigationItem.leftBarButtonItem setTintColor:colotAlpha];
}

- (void)searchClick
{
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.view.backgroundColor = colorWhite;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.view.backgroundColor = colorWhite;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}

- (void)settingView
{
    SettingsViewController *setting = [SettingsViewController new];
    setting.title = @"设置";
    setting.view.backgroundColor = colorBackground;
    [self.navigationController pushViewController:setting animated:YES];
}

@end
