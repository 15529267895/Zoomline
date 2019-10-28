//
//  SolutionModel.h
//  Zoomlion
//
//  Created by 王li on 2017/11/17.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SolutionModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *actionUrl;

@end


@interface SolutionListsDicModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSDictionary *jjfa;

@end


@interface SolutionViewModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *actionUrl;

@end























//@interface SolutionPPPDetailModel : NSObject
//
//@property (nonatomic, copy) NSString *createDate;
//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *imageUrl;
//@property (nonatomic, copy) NSString *isNewRecord;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *updateDate;
//@property (nonatomic, copy) NSDictionary *cxhw;
//
//@end
//
//@interface SolutProjectDetailModel : NSObject
//
//@property (nonatomic, copy) NSString *createDate;
//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *imageUrl;
//@property (nonatomic, copy) NSString *isNewRecord;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *updateDate;
//@property (nonatomic, copy) NSDictionary *detail;
//
//@end
//
//@interface SolutionDetailModel : NSObject
//
//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *isNewRecord;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *parentId;
//
//@end

