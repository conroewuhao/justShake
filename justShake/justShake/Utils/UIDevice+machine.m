//
//  UIDevice+machine.m
//  justShake
//
//  Created by wuhao on 16/1/12.
//  Copyright © 2016年 houbu. All rights reserved.
//

#import "UIDevice+machine.h"
#import <sys/utsname.h>

@implementation UIDevice (machine)

-(NSString *)machineDetail{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}


-(BOOL)isIphoneOr4s
{

    NSString *st=[self machineDetail];
    
    
    if ([st hasPrefix:@"iPhone3"] || [st hasPrefix:@"iPhone4"]) {
        return YES;
    }
    return NO;


}



@end
