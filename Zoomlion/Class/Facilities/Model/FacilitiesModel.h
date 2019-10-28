//
//  FacilitiesModel.h
//  Zoomlion
//
//  Created by 王li on 2017/11/16.
//  Copyright © 2017年 wli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacilitiesModel : NSObject    //环卫车款

@property (nonatomic, copy) NSString *id, *name;
@property (nonatomic, copy) NSArray *items;  //--->FacilitiesMachineTypeModel
@end


@interface FacilitiesItemsModel : NSObject     //环卫车包含的环卫机

@property (nonatomic, copy) NSString *id, *name;
@property (nonatomic, copy) NSArray *lists;      //------>FacilitiesMachineDetailModel

@end

@interface FacilityListsModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isNewRecord;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSDictionary *hwsbfl;

@end




//#warning 可删除
//@interface FacilitiesMachineListModel : NSObject
//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *isNewRecord;
//@property (nonatomic, copy) NSString *createDate;
//@property (nonatomic, copy) NSString *updateDate;
//@property (nonatomic, copy) NSString *imageUrl;
//@property (nonatomic, copy) NSDictionary *hwsbfl;
//@end
//@interface FacilitiesMachineListClassifyDetailModel : NSObject
//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *videoName;
//@property (nonatomic, copy) NSString *isNewRecord;
//@property (nonatomic, copy) NSString *createDate;
//@property (nonatomic, copy) NSString *updateDate;
//@property (nonatomic, copy) NSString *imageUrl;
//@property (nonatomic, copy) NSString *videoUrl;
//@property (nonatomic, copy) NSDictionary *hwsb;
//@end

