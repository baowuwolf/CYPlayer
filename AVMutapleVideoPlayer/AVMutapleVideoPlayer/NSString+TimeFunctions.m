//
//  NSString+TimeFunctions.m
//  AVMutapleVideoPlayer
//
//  Created by yu cao on 2017/8/25.
//  Copyright © 2017年 wolf. All rights reserved.
//

#import "NSString+TimeFunctions.h"

@implementation NSString (TimeFunctions)

+ (NSString*)stringFromSecond:(NSTimeInterval)aSecond {
    long int  second = lround(aSecond);
    long int  toHour = second / (60 * 60);
    
    long int  toMinute = (second / 60) - (toHour * 60);
    long int  toSecond = second % 60;
    NSString *retString;
    if (toHour) {
        retString = [NSString stringWithFormat:@"%01ld:%02ld:%02ld", toHour, toMinute, toSecond];
    } else {
        retString = [NSString stringWithFormat:@"%02ld:%02ld", toMinute, toSecond];
    }
    
    return retString;
}

@end
