//
//  UserModel.m
//  ExGym
//
//  Created by zrug on 14-10-8.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "UserModel.h"
#import "ExGymDB.h"
#import "NSDate+Detector.h"
#import "NSString+MD5.h"

@implementation UserModel

-(id)init {
    self = [super init];
    
    if (self) {
        ExGymDB *db = [ExGymDB instanceOfExGymDB];
        [db open];
        FMResultSet *rs = [db executeQuery:@"select * from \"user\" "];
        [rs next];
        
        _guid = [[NSUUID UUID] initWithUUIDString:[rs stringForColumn:@"guid"]];
        _username = [rs stringForColumn:@"username"];
        _nickname = [rs stringForColumn:@"nickname"];
        _avatar = [rs stringForColumn:@"avatar"];
        _gender = [rs stringForColumn:@"gender"];
        _birthday = [rs dateForColumn:@"birthday"];
        _height = [NSNumber numberWithDouble:[rs doubleForColumn:@"height"]];
        _weight = [NSNumber numberWithDouble:[rs doubleForColumn:@"weight"]];
        _bpmtop = [NSNumber numberWithInt:[rs intForColumn:@"bpmtop"]];
        _password = [rs stringForColumn:@"password"];
        
        [rs close];
        [db close];
    }
    return self;
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (_guid)
        [dic setObject:_guid forKey:@"guid"];
    if (_username)
        [dic setObject:_username forKey:@"username"];
    if (_nickname)
        [dic setObject:_nickname forKey:@"nickname"];
    if (_avatar)
        [dic setObject:_avatar forKey:@"avatar"];
    if (_gender)
        [dic setObject:_gender forKey:@"gender"];
    if (_birthday)
        [dic setObject:_birthday forKey:@"birthday"];
    if (_height)
        [dic setObject:_height forKey:@"height"];
    if (_weight)
        [dic setObject:_weight forKey:@"weight"];
    if (_bpmtop)
        [dic setObject:_bpmtop forKey:@"bpmtop"];
    if (_password)
        [dic setObject:_password forKey:@"password"];
    
    return dic;
}

- (bool)save {
    ExGymDB *db = [ExGymDB instanceOfExGymDB];
    [db open];
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-M-d"];
    
    NSUInteger count = [db intForQuery:@"SELECT COUNT(*) FROM \"user\" "];
    if (count == 0) {
        [db executeUpdate:@"insert into \"user\" (guid, username, nickname, avatar, gender, birthday, height, weight, bpmtop) values(?, ?, ?, ?, ?, ?, ?, ?, ?) ", [[NSUUID UUID] UUIDString], _username, _nickname, _avatar, _gender, _birthday, [_height stringValue], [_weight stringValue], [_bpmtop stringValue] ];
    } else {
        [db executeUpdate:@"update \"user\" set username=?, nickname=?, avatar=?, gender=?, birthday=?, height==?, weight==?, bpmtop=? ", _username, _nickname, _avatar, _gender, _birthday, [_height stringValue], [_weight stringValue], [_bpmtop stringValue] ];
    }
    
    [db close];
    return YES;
}

@end
