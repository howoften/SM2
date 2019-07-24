//
//  NSData+Hex.h
//  SM2Proj
//
//  Created by 刘江 on 2018/11/19.
//  Copyright © 2018年 Liujiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Hex)

+ (NSData *)dataFromHexString:(NSString *)hexString;

+ (NSString *)hexStringFromData:(NSData *)data;

@end
