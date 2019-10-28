//
//  SolutionViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "SolutionViewController.h"
#import "SolutionTableViewCell.h"
#import "WebViewController.h"


#import "SolutionModel.h"

@interface SolutionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation SolutionViewController

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = colorBackground;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:urlSolutionList params:nil];
    self.dataArr = cacheJson[@"data"];
    
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SolutionModel *model = [SolutionModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    CGSize imgSize = CGSizeMake(732, 310);
    __block typeof (imgSize) weakSize = imgSize;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,model.imageUrl]];
        weakSize = [UIImage getImageSizeWithURL:urlImg];
    });
    
    return ScreenWidth/(weakSize.width/weakSize.height);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    SolutionModel *model = [SolutionModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];

    SolutionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[SolutionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSURL *urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,model.imageUrl]];
    [cell.imageView sd_setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"load"]];

    [Common scaleImage:cell.imageView.image toSize:CGSizeMake(ScreenWidth - 10, ScreenHeight/3)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SolutionModel *model = [SolutionModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
   
    WebViewController *vc = [WebViewController new];
    vc.urlReq = urlSolutionDetail;
    vc.urlId = model.id;
    vc.title = @"解决方案详情";
    vc.shareName = model.name;
    vc.shareNum = @"详情";
    
    vc.view.backgroundColor = colorBackground;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
