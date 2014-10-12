//
//  HeartRates.m
//  ExGym
//
//  Created by zrug on 14-10-11.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "HeartRates.h"
#import "ExGymDB.h"

@implementation HeartRate

-(id)initWithBpm:(int)bpm andTime:(NSDate *)time {
    self = [super init];
    if (self) {
        [self setBpm:bpm andTime:time];
    }
    return self;
}
-(void)setBpm:(int)bpm andTime:(NSDate *)time {
    _bpm = bpm;
    _time = time;
}

@end


@implementation HeartRates

- (id)init {
    self = [super init];
    if (self) {
        _content = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithUUID:(NSUUID *)uuid {
    self = [self init];
    if (self) {
        ExGymDB *db = [ExGymDB instanceOfExGymDB];
        [db open];
        
        FMResultSet *rs = [db executeQuery:@"select * from heartrate where workoutid=? order by time", [uuid UUIDString]];
        while ([rs next]) {
            int bpm = [rs intForColumn:@"rate"];
            NSDate* time = [rs dateForColumn:@"time"];
            HeartRate *hr = [[HeartRate alloc] initWithBpm:bpm andTime:time];
            [_content addObject:hr];
        }
        
        [db close];
    }
    return self;
}

- (BOOL)saveWithUUID:(NSUUID *)uuid {
    if ([_content count] > 0) {
        ExGymDB *db = [ExGymDB instanceOfExGymDB];
        [db open];
        for (HeartRate *hr in _content) {
            [db executeUpdate:@"insert into heartrate (workoutid, rate, time) values(?, ?, ?)",
             [uuid UUIDString],
             [NSNumber numberWithInt:hr.bpm].stringValue,
             hr.time];
        }
        [db close];
    }
    return YES;
}

- (NSString *)toString {
    NSString *result = @"";
    for (HeartRate *hr in _content) {
        result = [result stringByAppendingFormat:@"%d, ", hr.bpm];
    }
    return result;
}

@end
