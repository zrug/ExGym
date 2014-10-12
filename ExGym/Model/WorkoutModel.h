//
//  WorkoutModel.h
//  ExGym
//
//  Created by zrug on 14-10-3.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class Coords;

@interface WorkoutModel : NSObject

@property (nonatomic, retain) NSUUID *guid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSNumber *distance;     // 公里
@property (nonatomic, retain) NSNumber *duration;     // 秒
@property (nonatomic, retain) NSNumber *kcal;         // 千卡
@property (nonatomic, retain) NSNumber *pace;         // 秒 / 公里
@property (nonatomic, retain) NSNumber *avgspeed;     // 公里 / 小时
@property (nonatomic, retain) NSNumber *topspeed;     // 公里 / 小时
@property (nonatomic, retain) NSNumber *avgHeartRate; // 跳 / 分钟
@property (nonatomic, retain) NSNumber *topHeartRate; // 跳 / 分钟
@property (nonatomic, copy) NSString *mood;
@property (nonatomic, retain) NSNumber *temperature;  // 摄氏度
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, retain) NSDate *createdtime;
@property (nonatomic, retain) Coords *coords;

-(id)initWithResultSet:(FMResultSet *)rs;

- (bool)save;
- (NSDictionary *)toDict;

@end
