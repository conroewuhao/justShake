//
//  DBThings.h
//  Shake-Food
//
//  Created by wuhao on 15/12/28.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBThings : NSObject
/**
 *  单例
 *
 *  @return 单例
 */
+(DBThings *)shareInstance;

/**
 *  读取食物字符串
 *
 *  @param keyString NSUserDefaults key
 *
 *  @return 食物字符串
 */
-(NSString *)loadDBWithKeyString:(NSString *)keyString;

/**
 *  写入字符串
 *
 *  @param string 字符串
 */
-(void)writeToDBWithContent:(NSString *)string;

/**
 *  写入字符串和当前时间
 *
 *  @param string 字符串
 */
-(void)writeToDBWithContentAndDate:(NSString *)string;

@property(nonatomic,strong)NSUserDefaults *def;


@end
