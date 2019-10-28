//
//  ProjectViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectSubViewController.h"


#import "ProjectModel.h"

@interface ProjectViewController ()

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *titleArr;

@end

@implementation ProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:urlProjectList params:nil];
    self.titleArr = [NSMutableArray array];
    
    for (NSDictionary *dicData in cacheJson[@"data"])
    {
        NSString *name = (dicData[@"view"])[@"name"];
        [self.titleArr addObject:name];
    }
    
    [self configView];
}

#pragma mark - 创建segment
- (void)configView
{
    if (iOS11)
    {
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.segContentVC.view.frame = CGRectMake(0, 8, ScreenWidth, ScreenHeight);
    [self.view addSubview:self.segContentVC.view];
    self.segContentVC.segmentBar.backgroundColor = colorBackground;
    self.segContentVC.tabBarItem.selectedImage = [UIImage imageNamed:@"selected"];
    self.segContentVC.segmentBar.selectIndex = 0;

    [self.segContentVC.segmentBar updateWithConfig:^(LLSegmentBarConfig *config) {
    config.itemNormalColor(colorTitle).itemSelectColor(colorTheme).itemFont(font15).indicatorColor([UIColor clearColor]);
    }];

    NSMutableArray *arrM = [NSMutableArray array];
    
//    ProjectBaseModel *bProModel = [ProjectBaseModel shareModel];
    id cacheJson = [XHNetworkCache cacheJsonWithURL:urlProjectList params:nil];

    self.dataArr = cacheJson[@"data"];
    
    for (NSInteger i = 0; i < self.titleArr.count; i++)
    {
        ProjectModel *model = [ProjectModel mj_objectWithKeyValues:self.dataArr[i]];
        ProjectSubViewController  *vc = [ProjectSubViewController new];

        vc.model = model;
        vc.shareName = self.titleArr[i];
        [arrM addObject:vc];
    }
    [self.segContentVC setUpWithItems:self.titleArr childVCs:arrM];
}

@end
