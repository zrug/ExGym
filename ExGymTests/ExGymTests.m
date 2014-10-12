//
//  ExGymTests.m
//  ExGymTests
//
//  Created by zrug on 14-8-30.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ExGymDB.h"
#import "WorkoutModel.h"
#import "UserModel.h"
#import "Coord.h"
#import "Coords.h"
#import "HeartRates.h"

@interface ExGymTests : XCTestCase

@end

@implementation ExGymTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUser
{
    ExGymDB *db = [ExGymDB instanceOfExGymDB];
    [db makeDatabase];
    
    UserModel *loadUser = [[UserModel alloc] init];
    
    NSLog(@"%@", [loadUser toDict]);
    
    loadUser.nickname = @"name changed again";
    loadUser.height = [NSNumber numberWithDouble:179.6];
    loadUser.weight = [NSNumber numberWithDouble:82.4];
    loadUser.bpmtop = [NSNumber numberWithInt:198];
    [loadUser save];
    
    loadUser = nil;
    
    UserModel *loadagain = [[UserModel alloc] init];
    NSLog(@"%@", [loadagain toDict]);
}


- (void)testWorkOut {
    WorkoutModel *workout = [[WorkoutModel alloc] init];
    
    workout.type = @"干革命";
    workout.distance = [NSNumber numberWithDouble:6.53];
    workout.duration = [NSNumber numberWithDouble:2842.];
    workout.kcal = [NSNumber numberWithDouble:433];
    workout.pace = [NSNumber numberWithInt:(2842. / 6.53)];
    workout.avgspeed = [NSNumber numberWithDouble:(6.52 / 2842 * 3600)];
    workout.topspeed = [NSNumber numberWithDouble:9.62];
    workout.avgHeartRate = [NSNumber numberWithInt:189];
    workout.topHeartRate = [NSNumber numberWithInt:162];
    workout.mood = @"还不错";
    workout.temperature = [NSNumber numberWithDouble:27];
    workout.weather = @"晴天";
    workout.remarks = @"remark33";
    [workout save];
    
    workout = nil;
}

- (void)testDataCoord {
    ExGymDB *db = [ExGymDB instanceOfExGymDB];
//    [db dropAll];
    [db makeDatabase];

    Coord *coord1 = [[Coord alloc] initWithLat:31.292341 andLng:121.466856 andTime:[NSDate dateWithTimeIntervalSince1970:1412835860.735077]];
    Coord *coord2 = [[Coord alloc] initWithLat:31.291511 andLng:121.466390 andTime:[NSDate dateWithTimeIntervalSince1970:1412835868.551179]];
    Coord *coord3 = [[Coord alloc] initWithLat:31.291457 andLng:121.466383 andTime:[NSDate dateWithTimeIntervalSince1970:1412835872.615061]];
    
    Coords *coords = [[Coords alloc] init];
    [coords addCoord:coord1];
    [coords addCoord:coord2];
    
    NSLog(@"distance: %0.2f", coords.distanceM);
    NSLog(@"total sec: %0.2f", coords.totalSecond);
    NSLog(@"speed: %0.2f", [coords speed]);

    [coords addCoord:coord3];
    
    NSLog(@"distance: %0.2f", coords.distanceM);
    NSLog(@"total sec: %0.2f", coords.totalSecond);
    NSLog(@"speed: %0.2f", [coords speed]);

    NSUUID *uuid = [NSUUID UUID];

    [coords saveWithUUID:uuid];
    
    Coords *readAll = [[Coords alloc] initWithUUID:uuid];
    NSLog(@"distance: %0.2f", readAll.distanceM);
    NSLog(@"total sec: %0.2f", readAll.totalSecond);
    NSLog(@"speed: %0.2f", [readAll speed]);
    
}

- (void)testHeartRate {
    ExGymDB *db = [ExGymDB instanceOfExGymDB];
    [db makeDatabase];
    
    NSUUID *uuid = [NSUUID UUID];
    
    HeartRates *hrs = [[HeartRates alloc] init];
    HeartRate *hr1 = [[HeartRate alloc] initWithBpm:90 andTime:[NSDate dateWithTimeIntervalSince1970:1412835860.735077]];
    HeartRate *hr2 = [[HeartRate alloc] initWithBpm:92 andTime:[NSDate dateWithTimeIntervalSince1970:1412835860.735077]];
    HeartRate *hr3 = [[HeartRate alloc] initWithBpm:95 andTime:[NSDate dateWithTimeIntervalSince1970:1412835860.735077]];
    [hrs.content addObject:hr1];
    [hrs.content addObject:hr2];
    [hrs.content addObject:hr3];
    
    [hrs saveWithUUID:uuid];
    
    HeartRates *readAll = [[HeartRates alloc] initWithUUID:uuid];
    NSLog(@"heartRats: %@", [readAll toString]);
}

@end
