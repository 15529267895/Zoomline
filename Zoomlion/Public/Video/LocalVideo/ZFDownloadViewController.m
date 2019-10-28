
//
//  ZFDownloadViewController.m
//  ZFDownload
//
//  Created by 任子丰 on 16/5/16.
//  Copyright © 2016年 任子丰. All rights reserved.
//

#import "ZFDownloadViewController.h"
#import "ZFDownloadManager.h"
#import "ZFDownloadingCell.h"
#import "ZFDownloadedCell.h"
#import "MoviePlayerViewController.h"

#define  DownloadManager  [ZFDownloadManager sharedDownloadManager]

@interface ZFDownloadViewController ()<ZFDownloadDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)  UITableView *tableView;

@property (atomic, strong) NSMutableArray *downloadObjectArr;

@end

@implementation ZFDownloadViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 更新数据源
    [self initData];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = colorBackground;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    DownloadManager.downloadDelegate = self;
    //NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editVideo)];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"reDown" object:nil];
//    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateOrientation)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)editVideo
{
    
}

#pragma mark - 屏幕旋转
- (void)updateOrientation
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

- (void)initData
{
    [DownloadManager startLoad];
    NSMutableArray *downladed = DownloadManager.finishedlist;
    NSMutableArray *downloading = DownloadManager.downinglist;
    self.downloadObjectArr = @[].mutableCopy;
    [self.downloadObjectArr addObject:downladed];
    [self.downloadObjectArr addObject:downloading];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.downloadObjectArr[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    if (indexPath.section == 0)
    {
        ZFDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadedcell"];
        if (!cell)
        {
            cell = [[ZFDownloadedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadedcell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        
        ZFDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadingcell"];
        if (cell == nil)
        {
            cell = [[ZFDownloadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadingcell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        __weak typeof(self) weakSelf = self;
        // 下载按钮点击时候的要刷新列表
        cell.btnClickBlock = ^{
            [weakSelf initData];
        };
        // 下载模型赋值
        cell.fileInfo = fileInfo;
        // 下载的request
        cell.request = request;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ZFFileModel *model                 = self.downloadObjectArr[indexPath.section][indexPath.row];
        // 文件存放路径
        NSString *path                   = FILE_PATH(model.fileName);
        NSURL *videoURL                  = [NSURL fileURLWithPath:path];
        
        MoviePlayerViewController *movie = [[MoviePlayerViewController alloc] init];
        movie.videoURL                   = videoURL;
        [self presentViewController:movie animated:YES completion:nil];
    }
    else
    {
//        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
//        
//        MoviePlayerViewController *movie = [MoviePlayerViewController new];
//        [self.navigationController pushViewController:movie animated:YES];
//        
//        movie.videoURL                   = [NSURL URLWithString:fileInfo.fileURL];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isiPhone)
    {
        return 75;
    }
    return 120;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteFinishFile:fileInfo];
    }
    else if (indexPath.section == 1)
    {
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        [DownloadManager deleteRequest:request];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"下载完成",@"下载中"][section];
}

#pragma mark - ZFDownloadDelegate
// 开始下载
- (void)startDownload:(ZFHttpRequest *)request
{
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request
{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request
{
    [self initData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo
{
    NSArray *cellArr = [self.tableView visibleCells];
    for (id obj in cellArr)
    {
        if([obj isKindOfClass:[ZFDownloadingCell class]])
        {
            ZFDownloadingCell *cell = (ZFDownloadingCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL])
            {
                cell.fileInfo = fileInfo;
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end




