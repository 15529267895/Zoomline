//
//  ProjectModel.h
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic, copy) NSArray *lists;
@property (nonatomic, copy) NSArray *view;

@end



@interface ProjectViewModel : NSObject

@property (nonatomic, copy) NSString *id, *isNewRecord, *createDate, *updateDate, *name, *imageUrl;

@end


@interface ProjectListModel : NSObject

@property (nonatomic, copy) NSDictionary *hjxm;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *name;

@end

@interface ProjectListInfosModel : NSObject

@property (nonatomic, copy) NSDictionary *detail;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *name;

@end

@interface ProjectListViewModel : NSObject

@property (nonatomic, copy) NSDictionary *hjxm;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *name;

@end
