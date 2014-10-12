//
//  WorkoutModel.m
//  ExGym
//
//  Created by zrug on 14-10-3.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "WorkoutModel.h"
#import "ExGymDB.h"
#import "NSDate+Detector.h"
#import "Coords.h"

@implementation WorkoutModel

-(id)initWithId:(NSUUID *)guid {
    ExGymDB *db = [ExGymDB instanceOfExGymDB];
    [db open];
    FMResultSet *rs = [db executeQuery:@"select *, datetime(createdtime,'localtime') as time from workout where guid=? ", [guid UUIDString]];
    if ([rs next]) {
        self = [self initWithResultSet:rs];
    }
    return self;
}

-(id)initWithResultSet:(FMResultSet *)rs{
    self = [super init];
    if (self) {
        _guid = [[NSUUID UUID] initWithUUIDString:[rs stringForColumn:@"guid"]];
        _type = [rs stringForColumn:@"type"];
        _distance = [NSNumber numberWithDouble:[rs doubleForColumn:@"distance"]];
        _duration = [NSNumber numberWithDouble:[rs doubleForColumn:@"duration"]];
        _kcal = [NSNumber numberWithDouble:[rs doubleForColumn:@"kcal"]];
        _pace = [NSNumber numberWithInt:[rs intForColumn:@"pace"]];
        _avgspeed = [NSNumber numberWithDouble:[rs doubleForColumn:@"avgspeed"]];
        _topspeed = [NSNumber numberWithDouble:[rs doubleForColumn:@"topspeed"]];
        _avgHeartRate = [NSNumber numberWithInt:[rs intForColumn:@"avgheartrate"]];
        _topHeartRate = [NSNumber numberWithInt:[rs intForColumn:@"topheartrate"]];
        _mood = [rs stringForColumn:@"mood"];
        _temperature = [NSNumber numberWithInt:[rs intForColumn:@"temperature"]];
        _weather = [rs stringForColumn:@"weather"];
        _remarks = [rs stringForColumn:@"remarks"];
        _createdtime = [[NSDate alloc] detectFromString:[rs stringForColumn:@"time"]];

        _coords = [[Coords alloc] initWithUUID:[_guid UUIDString]];
    }
    return self;
}

-(NSDictionary *)toDict {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:_guid forKey:@"guid"];
    [dic setValue:_type forKey:@"type"];
    [dic setValue:_distance forKey:@"distance"];
    [dic setValue:_duration forKey:@"duration"];
    [dic setValue:_kcal forKey:@"kcal"];
    [dic setValue:_pace forKey:@"pace"];
    [dic setValue:_avgspeed forKey:@"avgspeed"];
    [dic setValue:_topspeed forKey:@"topspeed"];
    [dic setValue:_avgHeartRate forKey:@"avgheartrate"];
    [dic setValue:_topHeartRate forKey:@"topheartrate"];
    [dic setValue:_mood forKey:@"mood"];
    [dic setValue:_temperature forKey:@"temperature"];
    [dic setValue:_weather forKey:@"weather"];
    [dic setValue:_remarks forKey:@"remarks"];
    [dic setValue:_createdtime forKey:@"time"];
    return dic;
}

- (bool)save {
    ExGymDB *db = [ExGymDB instanceOfExGymDB];
    [db open];
    
    if (self.guid) {
        NSLog(@"is update");
    } else {
        NSLog(@"is insert");
        [db executeUpdate:@"insert into workout (guid, type, distance, duration, kcal, pace, avgspeed, topspeed, avgHeartRate, topHeartRate, mood, temperature, weather, remarks) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
             [[NSUUID UUID] UUIDString],
             _type,
             [_distance stringValue],
             [_duration stringValue],
             [_kcal stringValue],
             [_pace stringValue],
             [_avgspeed stringValue],
             [_topspeed stringValue],
             [_avgHeartRate stringValue],
             [_topHeartRate stringValue],
             _mood,
             [_temperature stringValue],
             _weather,
             _remarks ];
    }

    [db close];
    return YES;
}

@end
