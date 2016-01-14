//
//  NSString+WHAddtion.m
//  Shake-Food
//
//  Created by wuhao on 16/1/4.
//  Copyright © 2016年 wuhao. All rights reserved.
//

#import "NSString+WHAddtion.h"

@implementation NSString (WHAddtion)

+(BOOL)isStringEmpty:(NSString *)string {
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}


@end
