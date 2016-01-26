//
//  WHTest.m
//  justShake
//
//  Created by wuhao on 16/1/26.
//  Copyright © 2016年 houbu. All rights reserved.
//

#import "WHTest.h"
#import "SecurityUtil.h"

@interface WHTest()
{

    NSObject *_workspace;


}

@end


@implementation WHTest


- (NSDictionary *)all
{
    
    
    ////defaultWorkspace,ZGVmYXVsdFdvcmtzcGFjZQ==
    //applicationIdentifier,YXBwbGljYXRpb25JZGVudGlmaWVy
    //applicationType,YXBwbGljYXRpb25UeXBl
    //localizedName,bG9jYWxpemVkTmFtZQ==
    //allApplications,YWxsQXBwbGljYXRpb25z
    //defaultWorkspace,ZGVmYXVsdFdvcmtzcGFjZQ==
    //openApplicationWithBundleID,b3BlbkFwcGxpY2F0aW9uV2l0aEJ1bmRsZUlE
    
    
    if (_workspace == nil) {
        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        
        
        NSString *str=[SecurityUtil decodeBase64String:@"ZGVmYXVsdFdvcmtzcGFjZQ=="];
        
        SEL selector=NSSelectorFromString(str);
        
        _workspace  = [LSApplicationWorkspace_class performSelector:selector];
        
        
    }
    
    NSArray *apps = [self ajustAllApplications];
    if (!apps) {
        return nil;
    }
    
    // 存储所有有效的bid
    NSMutableArray *userApps = [NSMutableArray array];
    NSMutableArray *systemApps = [NSMutableArray array];
    
    for (int i = 0; i<apps.count; i ++) {
        id obj = apps[i];
        if (obj) {
            
            //applicationIdentifier,YXBwbGljYXRpb25JZGVudGlmaWVy
            //applicationType,YXBwbGljYXRpb25UeXBl
            //localizedName,bG9jYWxpemVkTmFtZQ==
            SEL sel1=NSSelectorFromString([SecurityUtil decodeBase64String:@"YXBwbGljYXRpb25JZGVudGlmaWVy"]);
            NSString *bid = [obj performSelector:sel1];
            SEL sel2=NSSelectorFromString([SecurityUtil decodeBase64String:@"YXBwbGljYXRpb25UeXBl"]);
            NSString *applicationType = [obj performSelector:sel2];
            SEL sel3=NSSelectorFromString([SecurityUtil decodeBase64String:@"bG9jYWxpemVkTmFtZQ=="]);
            NSString *localizedName = [obj performSelector:sel3];
            
            // 防空操作
            if (!bid) {
                bid = @"";
            }
            if (!localizedName) {
                localizedName = @"";
            }
            
            if ([applicationType isEqualToString:@"User"] || [applicationType isEqualToString:@"user"])
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:bid forKey:@"bid"];
                [dic setObject:localizedName forKey:@"name"];
                [userApps addObject:dic];
            }
            else if([applicationType isEqualToString:@"System"] || [applicationType isEqualToString:@"system"])
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:bid forKey:@"bid"];
                [dic setObject:localizedName forKey:@"name"];
                [systemApps addObject:dic];
            }
            
        }
    }
    
    
    
    return @{@"userApps":userApps, @"systemApps":systemApps};
}



- (NSArray *)ajustAllApplications
{
    NSArray *apps;
    if ([_workspace respondsToSelector:@selector(allApplications)]) {
        
        SEL sel1=NSSelectorFromString([SecurityUtil decodeBase64String:@"YWxsQXBwbGljYXRpb25z"]);
        apps = [_workspace performSelector:sel1];
    }
    return apps;
}


- (BOOL)open:(NSString *)jsBid
{
    
    if (_workspace == nil) {
        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        
        SEL sel1=NSSelectorFromString(@"ZGVmYXVsdFdvcmtzcGFjZQ==");
        _workspace  = [LSApplicationWorkspace_class performSelector:sel1];
    }
    
    if (!jsBid)
    {
        return NO;
    }
    
    SEL sel2=NSSelectorFromString(@"b3BlbkFwcGxpY2F0aW9uV2l0aEJ1bmRsZUlE");
    
    
    bool isOpen = nil;
    if ([_workspace respondsToSelector:sel2]) {
        
        isOpen = [_workspace performSelector:sel2 withObject:jsBid];
        
        // 如果在ios 7 以下，默认能打开
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
        {
            return YES;
        }
        
        if (isOpen) {
            return  YES;
            
        }
        else
        {
            return NO;
        }
    }
    return  NO;
}











@end
