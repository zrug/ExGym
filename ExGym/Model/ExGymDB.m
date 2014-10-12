//
//  ExGymDB.m
//  ExGym
//
//  Created by zrug on 14-10-8.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "ExGymDB.h"
#import "FMDB.h"
#import "WorkoutModel.h"

@implementation ExGymDB

+(instancetype) instanceOfExGymDB {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"exgym.sqlite"];
    
    NSLog(@"ExGymDB instance spec: %@", writableDBPath);

    return [self databaseWithPath:writableDBPath];
}

- (void)dropAll {
    [self open];

    NSString* drop_table_user = @"DROP TABLE IF EXISTS \"user\" ";
    [self executeUpdate:drop_table_user];
    NSString* drop_table_workout = @"DROP TABLE IF EXISTS \"workout\" ";
    [self executeUpdate:drop_table_workout];
    NSString* drop_table_heartrate = @"DROP TABLE IF EXISTS \"heartrate\" ";
    [self executeUpdate:drop_table_heartrate];
    NSString* drop_table_coord = @"DROP TABLE IF EXISTS \"coord\" ";
    [self executeUpdate:drop_table_coord];
    
    [self close];
}

- (void)makeDatabase {
    [self open];
    
    NSString* create_table_user = @"CREATE TABLE IF NOT EXISTS \"user\" (\"guid\" VARCHAR(36), \"username\" VARCHAR(100), \"nickname\" VARCHAR(100), \"avatar\" VARCHAR(100), \"gender\" VARCHAR(2), \"birthday\" DATETIME, \"height\" REAL, \"weight\" REAL, \"bpmtop\" INTEGER, \"password\" VARCHAR(100) ) ";
    [self executeUpdate:create_table_user];
    
    NSString* create_table_workout = @"CREATE TABLE IF NOT EXISTS \"workout\" (\"guid\" VARCHAR(36) PRIMARY KEY  NOT NULL  UNIQUE , \"type\" TEXT NOT NULL , \"distance\" REAL NOT NULL  DEFAULT 0, \"duration\" REAL NOT NULL  DEFAULT 0, \"kcal\" REAL NOT NULL  DEFAULT 0, \"pace\" INTEGER NOT NULL  DEFAULT 0, \"avgspeed\" REAL NOT NULL  DEFAULT 0, \"topspeed\" REAL NOT NULL  DEFAULT 0, \"avgheartrate\" INTEGER NOT NULL  DEFAULT 0, \"topheartrate\" INTEGER NOT NULL  DEFAULT 0, \"mood\" TEXT, \"temperature\" INTEGER, \"weather\" TEXT, \"remarks\" TEXT, \"createdtime\" DATETIME DEFAULT (datetime(CURRENT_TIMESTAMP,'localtime')) )";
    [self executeUpdate:create_table_workout];
    
    NSString *create_table_heartrate = @"CREATE TABLE IF NOT EXISTS \"heartrate\" (\"workoutid\" VARCHAR(36) NOT NULL , \"rate\" INTEGER NOT NULL  DEFAULT 0, \"time\" DATETIME DEFAULT (datetime(CURRENT_TIMESTAMP,'localtime')) )";
    [self executeUpdate:create_table_heartrate];
    
    NSString *create_table_coord = @"CREATE TABLE IF NOT EXISTS \"coord\" (\"workoutid\" VARCHAR(36) NOT NULL , \"latitude\" REAL NOT NULL  DEFAULT 0, \"longitude\" REAL NOT NULL  DEFAULT 0, \"altitude\" REAL NOT NULL  DEFAULT 0, \"speed\" DATETIME NOT NULL  DEFAULT 0, \"time\" DATETIME DEFAULT (datetime(CURRENT_TIMESTAMP,'localtime')) )";
    [self executeUpdate:create_table_coord];
    
    [self close];
}

@end
