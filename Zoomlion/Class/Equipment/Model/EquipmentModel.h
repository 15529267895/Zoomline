//
//  EquipmentModel.h
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentModel : NSObject

@property (nonatomic, copy) NSDictionary *hjzbfl;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;

@end


@interface EquipmentClassModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *flbq;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;

@end

































@interface EquipmentOverViewModel : NSObject

@property (nonatomic, copy) NSDictionary *hjzb;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;

@end

@interface EquipmentFeatureModel : NSObject

@property (nonatomic, copy) NSDictionary *hjzb;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;

@end

@interface EquipmentParamterModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *dpppDv;
@property (nonatomic, copy) NSString *dpppVal;
@property (nonatomic, copy) NSString *fdjDv;
@property (nonatomic, copy) NSString *fdjVal;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *ljxDv;
@property (nonatomic, copy) NSString *ljxVal;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *wxccDv;
@property (nonatomic, copy) NSString *wxccVal;
@property (nonatomic, copy) NSString *xlgzDv;
@property (nonatomic, copy) NSString *xlgzVal;
@property (nonatomic, copy) NSString *zdglDv;
@property (nonatomic, copy) NSString *zdglVal;
@property (nonatomic, copy) NSString *zdzzlDv;
@property (nonatomic, copy) NSString *zdzzlVal;

@property (nonatomic, copy) NSDictionary *hjzb;

@end

@interface EquipmentProcessModel : NSObject

@property (nonatomic, copy) NSDictionary *hjzb;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;

@end

@interface EquipmentViewModel : NSObject

@property (nonatomic, copy) NSDictionary *hjzbfl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *updateDate;

@end

@interface EquipmentViewSubClassifModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parentId;

@end
