//
//  AppDelegate.m
//  justShake
//
//  Created by wuhao on 16/1/5.
//  Copyright © 2016年 houbu. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "WanpuTestViewController.h"
#import "SecurityUtil.h"
#import "WHTest.h"


@interface AppDelegate ()<UIAlertViewDelegate>
{

   // BOOL fromSafari;//是否是从Safari打开


}

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //defaultWorkspace,ZGVmYXVsdFdvcmtzcGFjZQ==
    //applicationIdentifier,YXBwbGljYXRpb25JZGVudGlmaWVy
    //applicationType,YXBwbGljYXRpb25UeXBl
    //localizedName,bG9jYWxpemVkTmFtZQ==
    //allApplications,YWxsQXBwbGljYXRpb25z
    //defaultWorkspace,ZGVmYXVsdFdvcmtzcGFjZQ==
    //openApplicationWithBundleID,b3BlbkFwcGxpY2F0aW9uV2l0aEJ1bmRsZUlE
    
//  NSArray *originArr=@[@"defaultWorkspace",@"applicationIdentifier",@"applicationType",@"localizedName",@"allApplications",@"defaultWorkspace",@"openApplicationWithBundleID"];
//    
//    
//    for (int i=0; i<originArr.count; i++) {
//        NSLog(@"-----%@",[SecurityUtil encodeBase64String:originArr[i]]);
//    }
//    
//    
//    NSArray *finalArr=@[@"ZGVmYXVsdFdvcmtzcGFjZQ==",@"YXBwbGljYXRpb25JZGVudGlmaWVy",@"YXBwbGljYXRpb25UeXBl",@"bG9jYWxpemVkTmFtZQ==",@"YWxsQXBwbGljYXRpb25z",@"ZGVmYXVsdFdvcmtzcGFjZQ==",@"b3BlbkFwcGxpY2F0aW9uV2l0aEJ1bmRsZUlE"];
//    
//    
//    for (int i=0; i<finalArr.count; i++) {
//        NSLog(@"++++%@",[SecurityUtil decodeBase64String:finalArr[i]]);
//    }
    
    
//    //利用加密方法对私有api进行测试
//    WHTest *test=[[WHTest alloc]init];
//   NSDictionary *dic=[test all];
//    NSLog(@"%@",dic);
//    
//    
    
    
    
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //整体颜色改变
    [[UINavigationBar appearance]setTintColor:rgba(250, 250, 250, 1)];
    
    
    //配置可以摇动
  //  [[UIApplication sharedApplication]setApplicationSupportsShakeToEdit:YES];


    
    
   // WanpuTestViewController *wanpuTest=[[WanpuTestViewController alloc]initWithNibName:@"WanpuTestViewController" bundle:nil];
    //self.window.rootViewController=wanpuTest;
    
    
    
        RootViewController *root=[RootViewController new];
        UINavigationController *navi=[[UINavigationController alloc]initWithRootViewController:root];
        self.window.rootViewController=navi;

    
    
    
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{

   // if ([[url absoluteString]isEqualToString:@"justShake://"]) {
        
        WanpuTestViewController *wanpuTest=[[WanpuTestViewController alloc]initWithNibName:@"WanpuTestViewController" bundle:nil];
        self.window.rootViewController=wanpuTest;
        
    
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

   
    
    
    
    
    return YES;

}



-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{

//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[url absoluteString] message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"adimit", nil];
//    alert.delegate=self;
//    [alert show];
    

    return YES;


}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
