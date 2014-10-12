//
//  HeartRates.h
//  ExGym
//
//  Created by zrug on 14-10-11.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartRate : NSObject

@property (nonatomic, assign) int bpm;
@property (nonatomic, retain) NSDate *time;

-(id)initWithBpm:(int)bpm andTime:(NSDate *)time;
-(void)setBpm:(int)bpm andTime:(NSDate *)time;

@end


@interface HeartRates : NSObject

@property (nonatomic, retain) NSMutableArray *content;

- (id)initWithUUID:(NSUUID *)uuid;
- (BOOL)saveWithUUID:(NSUUID *)uuid;

- (NSString *)toString;

@end
