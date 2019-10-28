//
//  WLAFNetwork.h
//  Zoomlion
//
//  Created by 王li on 2017/11/14.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^MyCallback)(id obj);

@interface WLAFNetwork : NSObject
+ (void)GET:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

+ (void)POSTNoToken:(NSString *)url param:(NSDictionary *)param success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
@end
