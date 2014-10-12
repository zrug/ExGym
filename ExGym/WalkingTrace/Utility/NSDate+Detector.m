//
//  NSDate+Detector.m
//  ExGym
//
//  Created by zrug on 14-10-8.
//  Copyright (c) 2014年 com.exgym. All rights reserved.
//

#import "NSDate+Detector.h"

@implementation NSDate(Detector)

- (NSDate *)detectFromString:(NSString *)string {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:nil];
    __block NSDate *detectedDate;
    [detector enumerateMatchesInString:string
                               options:kNilOptions
                                 range:NSMakeRange(0, string.length)
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                detectedDate = result.date;
                            }];
    return detectedDate;
}

@end
