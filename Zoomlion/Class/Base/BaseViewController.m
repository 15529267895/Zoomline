
//
//  BaseViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/11/12.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "YMWebCacheProtocol.h"
#import "YYCache.h"

@interface BaseViewController ()<UIWebViewDelegate>
{
    BOOL isEnd;
    NSInteger num;
}

@property (nonatomic, strong) NSMutableArray *updateArr;
@property (nonatomic, assign) NSInteger imgAllCount, imgFinishCount;
@property (nonatomic, strong) NSMutableArray *webUrlArr;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) YYCache *cache;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imgAllCount = 0;
    self.imgFinishCount = 0;
    self.updateArr = [NSMutableArray array];
    self.webUrlArr = [NSMutableArray array];
    self.cache = [[YYCache alloc] initWithName:@"YYCacheDB"];
    
//    导航栏设置
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotification) name:@"fail" object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (isiPad)
    {
        appDelegate.allowRotation = YES;
    }
    else
    {
        appDelegate.allowRotation = NO;
    }
   

//    [[SDImageCache sharedImageCache] removeImageForKey:@"http://zl.vriworks.cn/zoomlion-web/userfiles/a3b42dbc46b14c88bcb63f11b9cfd692/images/zmls/news/2018/02/DSC_6381.JPG"];
    
    //    web
//    YYCache *cache = [[YYCache alloc] initWithName:@"YYCacheDB"];
//    NSString *str = @"http://zl.vriworks.cn/zoomlion-web/w/gsjs";
//    NSString *strUrl = [NSString stringWithFormat:@"%lx", [str hash]];
//    [cache removeObjectForKey: strUrl];
}

#pragma mark - 更新最新数据
- (void)requestNoticeUpdate
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *deviceId = [[UIDevice currentDevice]identifierForVendor].UUIDString;
    
    NSDictionary *me = [USERCENTERMANAGER getLoginUser];
    NSDictionary *dic = @{@"token":tokenStr,@"deviceid":deviceId,@"endtime":me[KUpdateTime]};
    
    [WLAFNetwork GET:urlNotice param:dic success:^(id responseObject)
     {
        /*
         {"data":[{"id":"504ba419531a4b7e9fc91f8b28c04a3e","isNewRecord":false,"createDate":"2018-02-05 17:12:31","updateDate":"2018-02-05 17:12:31","actionurl":"/w/hjzb_detail?id=0a08aade94a447a1b3b097f11527275a","type":"3","imgurl":"/zoomlion-web/userfiles/2/images/zms/zmhjzb/2017/12/sl.jpg"}],"code":1,"msg":""}     --request.URL-->http://172.16.40.21:8081/zoomlion-web/api/notice?deviceid=C473D0B5-FAA8-49E7-8206-A9F271E5BEAC&endtime=2018-02-05%2018%3A10%3A11&token=321b584f85074db19765fc89a02f4db8
         }
         */
     

         NSArray *dataArr = responseObject[@"data"];
         if (dataArr.count > 0)
         {
             for (NSDictionary *dicData in dataArr)
             {
                 [self.updateArr addObject:dicData[@"type"]];
                 
                 if ([dicData[@"type"] intValue] == 1)
                 {
                     NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@",developWebApi,@"gsjs"] hash]];
                     [self.cache removeObjectForKey:strUrl];
                     [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@",developWebApi,@"gsjs"]];
                 }
                 else if ([dicData[@"type"] intValue] == 3 || [dicData[@"type"] intValue] == 5 || [dicData[@"type"] intValue] == 8)
                 {
                     NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@",developWebUpdate,dicData[@"actionurl"]] hash]];
                     [self.cache removeObjectForKey:strUrl];
                     
                     [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@",developWebUpdate,dicData[@"actionurl"]]];
                 }
             }
         }
         
         if (dataArr.count != 0)
         {
             [self updateRemindAlert];
         }
         
     } failure:^(NSError *error) {

     }];
}

- (void)updateRemindAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"已有数据更新，是否现在更新内容" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        [self refeshAllData];
                                    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


/*
 注意：
 type=0, Banner管理       type=1, 公司介绍         type=2, 环境分类
 type=3, 环境装备（详情）         type=4, 环卫分类         type=5, 环卫设备 （详情）
 type=6, 解决方案         type=7, 环境项目         type=8, 项目列表(环境项目详情)
 type=9, 城乡环卫         type=10, 新闻活动
 */

- (void)addNotification
{
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    //移除观察者 self
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 开始加载数据
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (self.navigationController.viewControllers.count == 1) //首界面
    {
        float dataSize = [XHNetworkCache cacheSize];
        if (dataSize <= 0.02)
        {
            self.webUrlArr = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@%@",developWebApi,@"gsjs"]];

            [self refeshAllData];
        }
    }
}

#pragma mark - 导航栏设置
- (void)viewWillAppear:(BOOL)animated
{
    //标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : colorWhite};
    //导航栏子控件颜色
    self.navigationController.navigationBar.tintColor = colorWhite;
    
    if (self.navigationController.viewControllers.count == 1) //首界面
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBar"] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_return_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    }
}

#pragma mark - 刷新所有数据
- (void)refeshAllData
{
    isEnd = NO;
    
    NSString *netWorkStart = [Common getNetWorkStates];

   if ([netWorkStart isEqual:@"4G"] || [netWorkStart isEqual:@"3G"] || [netWorkStart isEqual:@"2G"])  //流量
   {
       [self networkWarning];
   }
   else  //WiFi
   {
       [self requestBarnnerInfo];
       [self showHud];
   }
}

- (void)networkWarning
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"非WiFi状态是否下载更新数据？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        [self requestBarnnerInfo];
                                        [self showHud];
                                    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"稍后下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSArray *)cacheJsonUrl:(NSString *)url
{
    id cacheJson = [XHNetworkCache cacheJsonWithURL:url params:nil];
    return cacheJson[@"data"];
}

#pragma mark - barnner请求
- (void)requestBarnnerInfo
{
    [WLAFNetwork GET:urlBanner param:nil success:^(id responseObject)
     {
         self.barArr = [NSMutableArray arrayWithCapacity:[responseObject[@"data"] count]];
         [self.barArr removeAllObjects];

         [self saveCache:responseObject andUrl:urlBanner];

         self.imgAllCount += [responseObject[@"data"] count];
         
         for (NSDictionary *dic in responseObject[@"data"])
         {
             if (self.updateArr.count > 0 && [self.updateArr containsObject:@"0"])  //更新
             {
                 //删除缓存里面的
                 [[SDImageCache sharedImageCache] removeImageForKey:dic[@"imageUrl"]];
                 NSString *strUrl = [NSString stringWithFormat:@"%lx", [dic[@"imgHref"] hash]];
                 [self.cache removeObjectForKey:strUrl];

                 //添加新内容
                 [self.webUrlArr addObject:dic[@"imgHref"]];
             }
             
             if (self.updateArr.count == 0)   //下载所有
             {
                 [self.webUrlArr addObject:dic[@"imgHref"]];
//                 [self.barArr addObject:[NSString stringWithFormat:@"%@%@",developHeadAPi,dic[@"imgUrl"]]];
             }

             [self.barArr addObject:[NSString stringWithFormat:@"%@%@",developHeadAPi,dic[@"imgUrl"]]];
             [self downloadImage:dic[@"imageUrl"]];
         }
 
         [self getBarnner:_barArr];

         //        环卫设备
         [self requestFacilityInfo];
         
     } failure:^(NSError *error) {
         //        环卫设备
         [self requestFacilityInfo];
     }];
}

- (void)getBarnner:(NSMutableArray *)barnnerArr
{
    
}

#pragma mark - 环卫设备
- (void)requestFacilityInfo
{
    [WLAFNetwork GET:urlFacilityList param:nil success:^(id responseObject)
     {
         [self saveCache:responseObject andUrl:urlFacilityList];

         for (NSDictionary *dataDic in responseObject[@"data"])
         {
             for (NSDictionary *itemDic in dataDic[@"items"])
             {
                 self.imgAllCount += [itemDic[@"lists"] count];
                 
                 for (NSDictionary *itemListDic in itemDic[@"lists"])
                 {
                     if (self.updateArr.count > 0 && [self.updateArr containsObject:@"4"]) //更新
                     {
                         [[SDImageCache sharedImageCache] removeImageForKey:itemListDic[@"imageUrl"]];
                         NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlFacilityDetail,itemListDic[@"id"]] hash]];
                         [self.cache removeObjectForKey:strUrl];
                         [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlFacilityDetail,itemListDic[@"id"]]];

                     }
                     if (self.updateArr.count == 0)//加载全部
                     {
                         [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlFacilityDetail,itemListDic[@"id"]]];
                     }
                     [self downloadImage:itemListDic[@"imageUrl"]];

                 }
             }
         }
         
         [self requestEquipmentInfo];
         
     } failure:^(NSError *error){
        [self requestEquipmentInfo];
     }];
}

#pragma mark - 环境准备 request
- (void)requestEquipmentInfo
{
    [WLAFNetwork GET:urlEquipmentList param:nil success:^(id responseObject) {
        
        [self saveCache:responseObject andUrl:urlEquipmentList];
        
        self.imgAllCount += [responseObject[@"data"] count];
        
        for (NSDictionary *dataDic in responseObject[@"data"])
        {
            if (self.updateArr.count > 0 && [self.updateArr containsObject:@"2"])
            {
                [[SDImageCache sharedImageCache] removeImageForKey:dataDic[@"imageUrl"]];
                NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlEquipmentDetail,dataDic[@"id"]] hash]];
                [self.cache removeObjectForKey:strUrl];
                [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlEquipmentDetail,dataDic[@"id"]]];

            }
            if (self.updateArr.count == 0)
            {
                [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlEquipmentDetail,dataDic[@"id"]]];
            }
            [self downloadImage:dataDic[@"imageUrl"]];

        }
        
        //        城乡环卫
        [self requestPPPInfo];
        
    } failure:^(NSError *error) {
        //        城乡环卫
        [self requestPPPInfo];
    }];
}

#pragma mark - 城乡环卫PPP
- (void)requestPPPInfo
{
    [WLAFNetwork GET:urlPPP param:nil success:^(id responseObject)
     {
         [self saveCache:responseObject andUrl:urlPPP];
        
         for (NSDictionary *dic in responseObject[@"data"])
         {
             for (NSDictionary *dicList in dic[@"lists"])
             {
                 if (self.updateArr.count > 0 && [self.updateArr containsObject:@"9"])
                 {
                     NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlPPPDetail,dicList[@"id"]] hash]];
                     [self.cache removeObjectForKey:strUrl];
                     [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlPPPDetail,dicList[@"id"]]];

                 }
                 
                 if (self.updateArr.count == 0)
                 {
                     [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlPPPDetail,dicList[@"id"]]];
                 }
                 
             }
         }
//         [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@%@",developWebApi,urlEquipmentDetail,dataDic[@"id"]]];
         //        解决方案
         [self requestSolutionInfo];
         
     } failure:^(NSError *error) {
         //        解决方案
         [self requestSolutionInfo];
     }];
}


#pragma mark - Solution 请求
- (void)requestSolutionInfo
{
    [WLAFNetwork GET:urlSolutionList param:nil success:^(id responseObject)
     {
         [self saveCache:responseObject andUrl:urlSolutionList];
         
         self.imgAllCount += [responseObject[@"data"] count];
        
         for (NSDictionary *dicData in responseObject[@"data"])
         {
//             NSDictionary *dicView = dicData[@"view"];
             if (self.updateArr.count > 0 && [self.updateArr containsObject:@"6"])
             {
                 [[SDImageCache sharedImageCache] removeImageForKey:dicData[@"imageUrl"]];
                 NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlSolutionDetail,dicData[@"id"]] hash]];
                 [self.cache removeObjectForKey:strUrl];
                 [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlSolutionDetail,dicData[@"id"]]];

             }
             if (self.updateArr.count == 0)
             {
                 [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlSolutionDetail,dicData[@"id"]]];
             }
             [self downloadImage:dicData[@"imageUrl"]];   //这里是list的列表图片  和name

          }
         
         //        环境项目
         [self requestProjectInfo];
         
     } failure:^(NSError *error) {
         //        环境项目
         [self requestProjectInfo];
     }];
}

#pragma mark - Project 请求
- (void)requestProjectInfo
{
    [WLAFNetwork GET:urlProjectList param:nil success:^(id responseObject)
     {
         [self saveCache:responseObject andUrl:urlProjectList];
         
         for (NSDictionary *dicData in responseObject[@"data"])
         {
             self.imgAllCount += [dicData[@"lists"] count];

             for (NSDictionary *listDic in dicData[@"lists"])
             {
                 if (self.updateArr.count > 0 && [self.updateArr containsObject:@"7"])
                 {
                     [[SDImageCache sharedImageCache] removeImageForKey:listDic[@"imageUrl"]];
                     NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlProjectDetail,listDic[@"id"]] hash]];
                     [self.cache removeObjectForKey:strUrl];
                     [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlProjectDetail,listDic[@"id"]]];

                 }
                 if (self.updateArr.count == 0)
                 {
                     [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlProjectDetail,listDic[@"id"]]];
                 }
                 [self downloadImage:listDic[@"imageUrl"]];   //这里是list的列表图片  和name

             }
         }
         //        热点新闻
         [self requestHotNews];
         
     } failure:^(NSError *error) {
         //        热点新闻
         [self requestHotNews];
     }];
}

#pragma mark - hotNews 请求
- (void)requestHotNews
{
    [WLAFNetwork GET:urlHotNewsList param:nil success:^(id responseObject)
     {
         [self saveCache:responseObject andUrl:urlHotNewsList];
         
         NSArray *dataArr = responseObject[@"data"];
         self.imgAllCount += dataArr.count;
        
         isEnd = YES;
         for (NSDictionary *dicData in dataArr)
         {
             if (self.updateArr.count > 0 && [self.updateArr containsObject:@"10"])
             {
                 [[SDImageCache sharedImageCache] removeImageForKey:dicData[@"imageUrl"]];
                 NSString *strUrl = [NSString stringWithFormat:@"%lx", [[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlHotNewsDetail,dicData[@"id"]] hash]];
                 [self.cache removeObjectForKey:strUrl];
                 [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlHotNewsDetail,dicData[@"id"]]];

             }
             
             if (self.updateArr.count == 0)
             {
                 [self.webUrlArr addObject:[NSString stringWithFormat:@"%@%@?id=%@",developWebApi,urlHotNewsDetail,dicData[@"id"]]];
             }
             [self downloadImage:dicData[@"imageUrl"]];

         }
         
     } failure:^(NSError *error) {
         
         [self dismissHud];
     }];
}

- (void)saveCache:(NSDictionary *)responseObject andUrl:(NSString *)url
{
    //(异步步)写入/更新缓存数据
    //参数1:JSON数据,参数2:数据请求URL,参数3:数据请求参数(没有传nil)
    [XHNetworkCache save_asyncJsonResponseToCacheFile:responseObject andURL:url params:nil completed:^(BOOL result) {
        
        if(result)
        {
            NSLog(@"(异步)写入/更新缓存数据 成功");
        }
        else
        {
            NSLog(@"(异步)写入/更新缓存数据 失败");
        }
    }];
}

#pragma mark - 下载图片
- (void)downloadImage:(NSString *)imageStr
{
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",developHeadAPi,imageStr]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    KWeakSelf;
    [manager downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if (finished)
        {
            self.imgFinishCount += 1;

            if (isEnd == YES)
            {
                WWLog(@"allCount = %ld,imgFinishCount = %ld",(long)self.imgAllCount,(long)self.imgFinishCount);
                if (self.imgAllCount == self.imgFinishCount)
                {
                    [weakSelf startRequstWeb];
                }
            }
            WWLog(@"已完成===finished == %ld",self.imgFinishCount);
        }

        if (image)
        {
//            WWLog(@"下载了的image=%@",image);
        }

        if (error)
        {
//            [Common showMessage:@"图片下载失败"];
             WWLog(@"图片失败error=%@",error);
        }

    }];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"======didFailLoadWithError=====%@",error);
    
    num += 1;
    [self requst:num];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    num += 1;
    [self requst:num];
    NSLog(@"======webViewDidFinishLoad==%@===",self.webUrlArr[num]);
}

#pragma mark - 加载网页
#pragma load subviews of the web view

- (void)startRequstWeb
{
    
    WWLog(@"self.webUrlArr = %@",self.webUrlArr);
   
    [YMWebCacheProtocol start];
    [YMWebCacheProtocol changeCacheCountLimit:NSUIntegerMax costLimit:NSUIntegerMax ageLimit:DBL_MAX freeDiskSpaceLimit:0];
    
    KWeakSelf;
    if (self.webUrlArr.count > 0)
    {
        [weakSelf loadWebViews];
    }
    else
    {
        WWLog(@"此处没有weburlArr");
        [self requestEnd];
    }
}

- (void)loadWebViews
{
    //------------web view 加载区域-----------
    if (self.webView == nil)
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
    }

    [self requst:0];
}

- (void)requst:(NSInteger)count
{
    if (count >= self.webUrlArr.count)
    {
        [self requestEnd];
        return;
    }
    
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrlArr[count]]];
    [self.webView loadRequest:requst];
}

- (void)requestEnd
{
    NSDictionary *me = [USERCENTERMANAGER getLoginUser];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:me];
    [mutableDic setValue:[Common getCurrentTime] forKey:KUpdateTime];
    [USERCENTERMANAGER saveLoginUser:mutableDic];
    
    [self dismissHud];
}
#pragma mark - hud的显示及隐藏
- (void)showHud
{
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [SVProgressHUD showWithStatus:@"加载中..."]; //设置需要显示的文字
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];//设置HUD的Style
    [SVProgressHUD setForegroundColor:colorWhite];//设置HUD和文本的颜色
    [SVProgressHUD setBackgroundColor:colotAlpha];//设置HUD的背景颜色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom]; //设置HUD背景图层的样式
}

- (void)dismissHud
{
    //取消设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    [SVProgressHUD dismiss];
    [Common showMessage:@"已刷新所有数据"];
}

//状态栏的颜色设置
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建segmentVC
- (LLSegmentBarVC *)segContentVC
{
    if (!_segContentVC)
    {
        LLSegmentBarVC *contentVC = [[LLSegmentBarVC alloc] init];
        _segContentVC = contentVC;
        [self addChildViewController:contentVC];
    }
    return _segContentVC;
}

#pragma mark - 旋转方向
// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (isiPad)
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (isiPad)
    {
        return UIInterfaceOrientationPortrait;
    }
    else
    {
        return UIInterfaceOrientationPortrait;
    }
}

// 开启自动转屏
- (BOOL)shouldAutorotate
{
    if (isiPad)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
