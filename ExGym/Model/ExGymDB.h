//
//  ExGymDB.h
//  ExGym
//
//  Created by zrug on 14-10-8.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface ExGymDB : FMDatabase

+(instancetype) instanceOfExGymDB;

- (void)dropAll;
- (void)makeDatabase;

@end
