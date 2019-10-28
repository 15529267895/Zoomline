//
//  WLAFNetwork.m
//  Zoomlion
//
//  Created by 王li on 2017/11/14.
//  Copyright © 2017年 wli. All rights reserved.
//

#import "WLAFNetwork.h"
#import "LoginViewController.h"
#import "RequesURL.h"

@implementation WLAFNetwork

+ (void)GET:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",developAPi,url];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [paramDic setValue:tokenStr forKey:@"token"];
    
    [self http:@"GET" url:urlStr param:paramDic success:success failure:failure];
}

/**
 *  网络请求方法POST
 */
+ (void)POST:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",developAPi,url];
   
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [paramDic setValue:tokenStr forKey:@"token"];
    
    [self http:@"POST" url:urlStr param:paramDic success:success failure:failure];
}

+ (void)POSTNoToken:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",developAPi,url];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:param];

    [self http:@"POST" url:urlStr param:paramDic success:success failure:failure];
}

+ (void)http:(NSString *)method url:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if(param != nil)
    {
        for (NSString *key in [param allKeys])
        {
            if([key isEqualToString:@"service"])
            {
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            }
        }
    }
    else
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    NSMutableString *body = [[NSMutableString alloc]init];;
    for(NSString *key in [param allKeys]){
        NSString *value= [param objectForKey:key];
        [body appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    
    NSLog(@"\n\n\n[-------Send------]:%@?%@\n\n\n",url,body);
    
    manager.requestSerializer.timeoutInterval = 15.0f;
    if([method isEqualToString:@"POST"])
    {
        [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress)
         {
             
         }
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
            
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
             NSString *jsonStr = [responseObject mj_JSONString];
             NSLog(@"\n\n\n[-------Result------]:%@     --request.URL-->%@\n\n\n",jsonStr,httpResponse.URL);
             
             NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             if ([returnDic[@"code"] intValue] != 1) //失败
             {
                 
                 if([returnDic[@"code"] intValue] == 2)  //重新登录
                 {
                     [self logOutHome];
                 }
                 [Common showMessage:returnDic[@"msg"]];
                 return;
             }


             [self logicSuccess:returnDic callback:^(id obj)
               {
                   success(obj);
               }];
             
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSDate *date1 = [NSDate date];
             NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
             [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             NSLog(@"error相关数据 ===  %@",[NSString stringWithFormat:@"url = %@  errorDate = %@",url,[formatter1 stringFromDate:date1]]);
             if (error.code == -1009)
             {
                 [Common showMessage:@"网络已断开"];
             }
             NSLog(@"网络请求失败error========%@",error);
              [self logicError:error callback:^(id obj)
               {
                   failure(obj);
               }];
             
             [error localizedDescription];
//              [Common showMessage:@"%@",;
         }];
        
    }
    else if([method isEqualToString:@"GET"])
    {
        [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress)
         {
             
         }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
             NSString *jsonStr = [responseObject mj_JSONString];
             NSLog(@"\n\n\n[-------Result------]:%@     --request.URL-->%@\n\n\n",jsonStr,httpResponse.URL);
       
             NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             if ([returnDic[@"code"] intValue] != 1) //失败
             {

                 if([returnDic[@"code"] intValue] == 2)  //重新登录
                 {
                     [self logOutHome];
                 }
                 [Common showMessage:returnDic[@"msg"]];
                 return;
             }
             
             
             [self logicSuccess:returnDic callback:^(id obj)
              {
                  success(obj);
              }];
             
         }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSDate *date1 = [NSDate date];
             NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
             [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             NSLog(@"error相关数据 ===  %@",[NSString stringWithFormat:@"url = %@  errorDate = %@",url,[formatter1 stringFromDate:date1]]);
             
             if (error.code == -1009)
             {
                 [Common showMessage:@"网络已断开"];
             }
             
             NSLog(@"网络请求失败error========%@",error);
             [self logicError:error callback:^(id obj)
              {
                  failure(obj);
              }];
             
//             NSString *errorStr = [error localizedDescription];
//             [Common showMessage:@"%@",errorStr];
             
         }];
    }
}


+ (void)logOutHome
{
    //发送一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fail" object:nil];
    
//    LoginViewController *vc = [LoginViewController new];
//    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    [rootViewController presentViewController:vc animated:NO completion:nil];
    
//    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
//    [super.navigationController presentViewController:navi animated:YES completion:nil];
}

+(void)logicError:(NSError *)error callback:(MyCallback)callback
{
    callback(error);
}

+(void)logicSuccess:(id)responseObject callback:(MyCallback)callback
{
    callback(responseObject);
}

@end

