//
//  PPPViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "PPPViewController.h"
#import "PPPTableViewCell.h"
#import "WebViewController.h"

#import "PPPModel.h"


@interface PPPViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _selecSection;
    BOOL _isSome;
    float relateWidth,relateHeigh;
}

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UITableView  *tableView;


@end

@implementation PPPViewController

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = colorBackground;
        _isSome = YES;
       
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)relativeLength
{
    relateWidth = ScreenWidth < ScreenHeight?ScreenWidth:ScreenHeight;
    relateHeigh = ScreenWidth < ScreenHeight?ScreenHeight:ScreenWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:urlPPP params:nil];
    self.dataArr = cacheJson[@"data"];
    
    if (self.dataArr.count <= 0)
    {
        [Common showMessage:@"暂无数据"];
        return;
    }
    
    [self relativeLength];
    
    [self.tableView reloadData];
    
    
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
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tableView reloadData];
}

#pragma mark- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PPPModel *model = [PPPModel mj_objectWithKeyValues:self.dataArr[section]];
    
    if (_isSome != YES)
    {
        if (_selecSection == section)
        {
            return model.lists.count;
        }
    }
     return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    PPPModel *model = [PPPModel mj_objectWithKeyValues:self.dataArr[indexPath.section]];
    PPPListsModel *listModel = [PPPListsModel mj_objectWithKeyValues:model.lists[indexPath.row]];
    
    PPPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[PPPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
     [tableView setSeparatorInset:UIEdgeInsetsMake(0, 15 / 375.0 * ScreenWidth, 0, 15 / 375.0 * ScreenWidth)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLab.text = listModel.name;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPPModel *model = [PPPModel mj_objectWithKeyValues:self.dataArr[indexPath.section]];
    PPPListsModel *listModel = [PPPListsModel mj_objectWithKeyValues:model.lists[indexPath.row]];
    
    WebViewController *vc = [WebViewController new];
    vc.title = @"城乡环卫详情";
    vc.urlReq = urlPPPDetail;
    vc.urlId = listModel.id;
    vc.view.backgroundColor = colorBackground;
    
    vc.shareName = model.name;
    vc.shareNum = listModel.name;

    [self.navigationController pushViewController:vc animated:YES];
}

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35 / 375.0 * relateWidth;
}

// 分区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40 / 375.0 * relateWidth;
}

// 分区尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 / 375.0 * relateWidth, 40 / 375.0 * relateWidth)];
    view.backgroundColor = colorTheme;

    // 展开箭头
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 30, (40 / 375.0 * relateWidth - 15)/2, 15, 15)];
    imageView.image = [UIImage imageNamed:@"nav_return_white"];
    [view addSubview:imageView];
    
    // 分组名Label
    UILabel *groupLable = [[UILabel alloc]initWithFrame:CGRectMake(15 / 375.0 * relateWidth, 0, relateWidth, 40 / 375.0 * relateWidth)];
    
    PPPModel *model = [PPPModel mj_objectWithKeyValues:self.dataArr[section]];
    groupLable.text =  model.name;
    
    groupLable.textColor = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1.0];
    groupLable.font = font15;
    [view addSubview:groupLable];
    
    view.userInteractionEnabled = YES;

    CGFloat rota;
    if (_isSome != YES)
    {
        if (_selecSection == section)
        {
            rota = -M_PI_2; //π/2
        }
        else
        {
            rota = 0;
        }
    }
    else
    {
        rota = 0;
    }
    imageView.transform = CGAffineTransformMakeRotation(rota);//箭头偏移π/2
    
    // 初始化一个手势
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openClick:)];
    view.tag = section;

    // 给view添加手势
    [view addGestureRecognizer:myTap];
    
    return view;
}

- (void)openClick:(UITapGestureRecognizer *)sender
{
    if (_isSome == YES)
    {
        _isSome = NO;
    }
    else
    {
        if ([sender view].tag == _selecSection)
        {
            _isSome = YES;
        }
        else
        {
            _isSome = NO;
        }
    }
    
    _selecSection = [sender view].tag;
    
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *clearView = [[UIView alloc]init];
    clearView.backgroundColor = [UIColor clearColor];
    return clearView;
}


@end




