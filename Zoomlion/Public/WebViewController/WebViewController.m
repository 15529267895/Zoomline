//
//  WebViewController.m
//  Zoomlion
//
//  Created by 王li on 2017/12/1.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "WebViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "ZFDownloadManager.h"
#import "ZFDownloadViewController.h"
#import "YMWebCacheProtocol.h"
#import "AppDelegate.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    NSString *strUrl;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,assign)BOOL didWebViewLoadOK;

@end

@implementation WebViewController

- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _webView.scalesPageToFit = YES;
        _webView.multipleTouchEnabled = YES;
        _webView.userInteractionEnabled = YES;
        _webView.scrollView.scrollEnabled = YES;
        _webView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_webView mas_updateConstraints:^(MASConstraintMaker *make)
        {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(showBottomView)];
    [self loadWebViews];

    [YMWebCacheProtocol start];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(download) name:@"reDown" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
}


#pragma - mark  进入全屏
-(void)begainFullScreen
{
    if (isiPad)
    {
        return;
    }
    
    if(!self.didWebViewLoadOK)
    {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
    
    [[UIDevice currentDevice] setValue:@"UIInterfaceOrientationLandscapeLeft" forKey:@"orientation"];
    
    //强制zhuan'p：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeLeft;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma - mark 退出全屏
-(void)endFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (isiPhone)
    {
        appDelegate.allowRotation = NO;
        //强制归正：
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val =UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

- (void)download
{
    ZFDownloadViewController *vc = [ZFDownloadViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 加载网页
#pragma load subviews of the controllers view
- (void)loadWebViews
{
    if (_urlId.length > 0)
    {
        strUrl = [NSString stringWithFormat:@"%@%@?id=%@",developWebApi,_urlReq,_urlId];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@%@",developWebApi,_urlReq];
    }
    
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [self.webView loadRequest:requst];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = [[request URL] absoluteString];
    if ([[urlStr substringFromIndex:urlStr.length - 4] isEqual:@".mp4"])
    {
        // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
        NSString *name = [urlStr lastPathComponent];
        [[ZFDownloadManager sharedDownloadManager] downFileUrl:urlStr filename:name fileimage:nil];
        // 设置最多同时下载个数（默认是3）
        [ZFDownloadManager sharedDownloadManager].maxCount = 4;
        
        return NO;
    }

    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.didWebViewLoadOK = YES;
    
    NSString *jsMeta = [NSString stringWithFormat:@"var meta = document.createElement('meta');meta.content='width=device-width,initial-scale=1.0,minimum-scale=.5,maximum-scale=3';meta.name='viewport';document.getElementsByTagName('head')[0].appendChild(meta);"];
    
    [_webView stringByEvaluatingJavaScriptFromString:jsMeta];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.didWebViewLoadOK = NO;
}

#pragma mark - 分享链接
- (void)showBottomView
{
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //在回调里面获得点击的
        if (platformType == 0) {     //新浪
      
        }
        else if (platformType == 1)   //微信
        {
            
        }
        else if (platformType == 2)   //微信朋友圈
        {
            
        }
        else if (platformType == 4)    //QQ聊天页面
        {
            
        }
        else if (platformType == 5)   //qq空间
        {
            
        }
        else if (platformType == 6)   //支付宝聊天页面
        {
            
        }
        else if (platformType == 14)   //邮件
        {
            
        }
       
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject;
    if ([self.title isEqualToString:@"公司介绍"])
    {
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.title descr:@"详情" thumImage:[UIImage imageNamed:@"companyIntro"]];
    }
    else
    {
//        if (self.shareImage == nil)
//        {
////            self.shareImage = [UIImage imageNamed:@"companyIntro"];
//        }
        
        shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareName descr:self.shareNum thumImage: [UIImage imageNamed:@"companyIntro"]];
    }
    
    //设置网页地址
    shareObject.webpageUrl = strUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error)
     {
         if (error)
         {
             if (error.code!=2009 && error.code!=2008 && error.code!=2001)
             {
                 [Common showMessage:@"分享失败"];
             }else
                 
                 switch (error.code)
             {
                     case 2009:
                         [Common showMessage:@"取消分享"];
                         break;
                     case 2008:
                         if (platformType == UMSocialPlatformType_QQ || platformType == UMSocialPlatformType_Qzone)
                         {
                             [Common showMessage:@"请先安装QQ客户端"];
                         }
                         if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine)
                         {
                             [Common showMessage:@"请先安装微信客户端"];
                         }
                         break;
                     case 2001:
                         if (platformType == UMSocialPlatformType_QQ || platformType == UMSocialPlatformType_Qzone)
                         {
                             [Common showMessage:@"请先安装QQ客户端"];
                         }
                         if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_WechatTimeLine)
                         {
                             [Common showMessage:@"请先安装微信客户端"];
                         }
                         break;
                     default:
                         break;
                 }
         }
         else
         {
             if ([data isKindOfClass:[UMSocialShareResponse class]])
             {
                 UMSocialShareResponse *resp = data;
                 //分享结果消息
                 UMSocialLogInfo(@"response message is %@",resp.message);
                 //第三方原始返回的数据
                 UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
             }
             else
             {
                 UMSocialLogInfo(@"response data is %@",data);
             }
         }
         [Common showMessage:@"分享失败"];
     }];
}

// 取消监听
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
