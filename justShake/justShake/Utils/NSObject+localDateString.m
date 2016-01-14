//
//  NSObject+localDateString.m
//  Shake-Food
//
//  Created by wuhao on 15/12/29.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import "NSObject+localDateString.h"

@implementation NSObject (localDateString)

-(NSString *)localDateStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy年MM月dd日 aa HH:mm"];
    return   [formatter stringFromDate:date];
}
@end
