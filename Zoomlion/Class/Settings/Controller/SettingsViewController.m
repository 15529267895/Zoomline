//
//  SettingsViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "SettingLogOutTableViewCell.h"
#import "LoginViewController.h"

#import "ZFDownloadViewController.h"

#import "SDImageCache.h"

#import "YYCache.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *arrTitle, *arrSubTitle;
@property (nonatomic, strong) NSString *name, *email;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.arrTitle = [NSMutableArray arrayWithArray:@[@"更新时间",@"清除缓存数据",@"刷新数据",@"视频管理",@"公司地址",@"寻求帮助",@"关于"]];
    
    self.arrSubTitle = [NSMutableArray array];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = colorBackground;
    self.tableview.tableFooterView = [UIView new];
    [self.tableview setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.view addSubview:self.tableview];
    
    [self updateData];

    if (isiPad)
    {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(updateOrientation)
                                                    name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotification) name:@"fail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotificationSuccess) name:@"refreshSuccess" object:nil];
}

- (void)addNotificationSuccess
{
    [self updateData];
}

- (void)updateData
{
    [self.arrSubTitle removeAllObjects];
    
    NSDictionary *me = [USERCENTERMANAGER getLoginUser];
    float dataSize = [XHNetworkCache cacheSize];
    
    float imgSize = [[SDImageCache sharedImageCache] getSize] / 1024 /1024;
    
    float allSize = dataSize + imgSize;
    
    NSLog(@"%@",[NSString stringWithFormat:@"%.2fM",allSize]);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    if (me.count != 0)
    {
        self.name = me[KName];
        self.email = me[KPosition];
        [self.arrSubTitle addObjectsFromArray:@[me[KUpdateTime], [NSString stringWithFormat:@"%.2fM",allSize],@"",@"",me[KAddress],me[KHelp],[NSString stringWithFormat:@"V%@",appCurVersion]]];
    }
    
    [self.tableview reloadData];
}

- (void)updateOrientation
{
    [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self.tableview reloadData];
}

#pragma mark - tableview Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ||section == 2)
    {
        return 1;
    }
    return self.arrSubTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    if (indexPath.section == 2)
    {
        SettingLogOutTableViewCell *cellLog = [tableView dequeueReusableCellWithIdentifier:@"logoutcell"];
        if (!cellLog)
        {
            cellLog = [[SettingLogOutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logoutcell"];
        }
        cellLog.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cellLog;
    }
    
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0)
    {
        cell.arrowImg.hidden = YES;
        cell.titleLab.text = self.name;
        cell.subLab.text = self.email;
    }
    else
    {
        if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 6)
        {
            cell.arrowImg.hidden = YES;
        }
        else
        {
            cell.arrowImg.hidden = NO;
        }
        
        cell.titleLab.text = self.arrTitle[indexPath.row];
        cell.subLab.text = self.arrSubTitle[indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = colorBackground;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat rowHig = 40 / 375.0 * ((ScreenWidth < ScreenHeight?ScreenWidth:ScreenHeight));
//    if ((rowHig * 9 +20 *2) > ScreenHeight)
//    {
//        return rowHig;
//    }
//    return (ScreenHeight - 20)/9;
    
    if (isiPhone)
    {
        return 45;
    }
    else
    {
        return 85;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
        
        }
        else if (indexPath.row == 1)
        {
           [self cleanImageData];
        }
        else if (indexPath.row == 2)
        {
            [self refreshData];
        }
        else if (indexPath.row == 3)
        {
            [self videoManage];
        }
        else if (indexPath.row == 5)
        {
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.arrSubTitle[indexPath.row]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    
    if (indexPath.section == 2)
    {
        [self signOut];
    }
}

- (void)cleanImageData
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清理缓存?" message:@"清理后图片将丢失" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"清理缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        [[SDImageCache sharedImageCache] clearDisk];
                                        [[SDImageCache sharedImageCache] clearMemory];
                                        [self updateData];
                                    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refreshData
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认刷新数据？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"刷新数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
//                                        [self clearData];
                                        [self requestNoticeUpdate];
                                    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)videoManage
{
    ZFDownloadViewController *vc = [ZFDownloadViewController new];
    vc.title = @"视频管理";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signOut
{
    KWeakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        [weakSelf signOutCleanData];
                                    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addNotification
{
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

- (void)dealloc
{
    //移除观察者 self
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearData
{
    //    清理Data
    [XHNetworkCache clearCache];
    
    //    清理image
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];

    //    web
    YYCache *cache = [[YYCache alloc] initWithName:@"YYCacheDB"];
    [cache removeAllObjects];
}

#pragma mark - 退出登录
- (void)signOutCleanData
{
//    清理token
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];

    [self clearData];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

@end