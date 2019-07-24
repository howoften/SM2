//
//  NSData+Hex.m
//  SM2Proj
//
//  Created by 刘江 on 2018/11/19.
//  Copyright © 2018年 Liujiang. All rights reserved.
//

#import "NSData+Hex.h"

@implementation NSData (Hex)

+ (NSData *)dataFromHexString:(NSString *)input {
    const char *chars = [input UTF8String];
    int i = 0;
    NSUInteger len = input.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

static inline char itoh(int i) {
    if (i > 9) return 'A' + (i - 10);
    return '0' + i;
}

+ (NSString *) hexStringFromData:(NSData*) data
{
    NSMutableString *hexStr = [NSMutableString string];
    Byte *byte = (Byte *)data.bytes;
    for (int i = 0; i < data.length; i++) {
        [hexStr appendFormat:@"%02X", byte[i]];
    }
    return hexStr;
}


@end
