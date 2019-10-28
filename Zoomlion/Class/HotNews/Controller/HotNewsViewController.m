//
//  HotNewsViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "HotNewsViewController.h"
#import "HotNewsTableViewCell.h"


#import "HotNewsModel.h"

#import "WebViewController.h"

@interface HotNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrData;

@end

@implementation HotNewsViewController

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self configView];
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:urlHotNewsList params:nil];
    self.arrData = cacheJson[@"data"];
    
    if (self.arrData.count <= 0)
    {
        [Common showMessage:@"暂无数据"];
        return;
    }
    
    if (isiPad)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(updateOrientation)
                                                    name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)updateOrientation
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.bottom.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int ratio;
    ratio = ScreenWidth < ScreenHeight? ScreenHeight:ScreenWidth;
    
    if (isiPad)
    {
        if (iPadPro1 || iPadPro2)
        {
            return ratio *0.23;
        }
        else
        {
            return ratio *0.2;
        }
    }

    return ratio *0.16;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    HotNewsModel *model = [HotNewsModel mj_objectWithKeyValues:self.arrData[indexPath.row]];

    HotNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[HotNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
  
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,model.imageUrl]] placeholderImage:[UIImage imageNamed:@"load"]];
    cell.titleLab.text = model.name;
    cell.timeLab.text = model.createDate;
    cell.detailLab.text = model.contents;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotNewsModel *model = [HotNewsModel mj_objectWithKeyValues:self.arrData[indexPath.row]];

    WebViewController *hotNews = [WebViewController new];
    hotNews.urlReq = urlHotNewsDetail;
    hotNews.urlId = model.id;
    hotNews.title = @"新闻详情";
    
    hotNews.shareName = model.name;
    hotNews.shareNum = model.contents;
//    hotNews.shareImage = [NSString stringWithFormat:@"%@%@",developHeadAPi,model.imageUrl];
    
    [self.navigationController pushViewController:hotNews animated:YES];
}

- (void)configView
{
    [self.view addSubview:self.tableView];
}

@end
