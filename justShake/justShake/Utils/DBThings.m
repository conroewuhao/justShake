//
//  DBThings.m
//  Shake-Food
//
//  Created by wuhao on 15/12/28.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import "DBThings.h"
#import "NSObject+localDateString.h"


@implementation DBThings
/**
 *  创建单例
 *
 *  @return 返回单例
 */
+(DBThings *)shareInstance{
    static DBThings *dbthings=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbthings=[[DBThings alloc]init];
    });
    return dbthings;
}


/**
 *  随机从数据库读取元素
 *
 *  @return 食物字符串
 */
-(NSString * )loadDBWithKeyString:(NSString *)keyString{
    if (!_def) {
        _def=[NSUserDefaults standardUserDefaults];
    }
            
    NSMutableArray *arr=[_def objectForKey:keyString];
    if (arr && arr.count>0) {
        int i=arc4random()%(arr.count);
        NSString *str=arr[i];
        return str;
    }
    else return nil;
}

-(void)writeToDBWithContent:(NSString *)string{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSMutableArray *arr=[def objectForKey:@"foodArray"];
    if (!arr) {

    }
}
/**
 *  写入本地
 *
 *  @param string 食物字符串
 */
-(void)writeToDBWithContentAndDate:(NSString *)string{
    
    NSString *dateString=[self localDateStringWithDate:[NSDate date]];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSMutableArray *arr;
    arr=[def objectForKey:@"foodAndTimeArray"];
    if (!arr) {
        arr=[NSMutableArray new];
        [dic setObject:dateString forKey:@"dateString"];
        [dic setObject:string forKey:@"contentString"];
        [arr addObject:dic];
        [def setObject:arr forKey:@"foodAndTimeArray"];
        [def synchronize];
    }
    else if (arr && arr.count>0){
        NSMutableArray *contentArray=[NSMutableArray new];
        [contentArray removeAllObjects];
        contentArray=[NSMutableArray arrayWithArray:arr];
        [dic setObject:dateString forKey:@"dateString"];
        [dic setObject:string forKey:@"contentString"];
        [contentArray addObject:dic];
        [def setObject:contentArray forKey:@"foodAndTimeArray"];
        [def synchronize];

    }

}


@end
