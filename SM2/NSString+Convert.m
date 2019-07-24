//
//  NSString+Convert.m
//  BRTDemo
//
//  Created by 刘江 on 2018/12/28.
//  Copyright © 2018年 Liujiang. All rights reserved.
//

#import "NSString+Convert.h"

@implementation NSString (Convert)
// 讲16进制字符串 转 10进制
- (NSString *)convertHex2Dec {
    NSString *hexString = [self copy];
    NSString *regex = @"^[0-9a-fA-F]+$";
    NSRange range = [hexString rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return nil;
    }
    hexString = [hexString substringWithRange:range];
    hexString = [hexString uppercaseString];
    if (!hexString || hexString.length < 1) {
        return @"";
    }
    NSUInteger boundary = hexString.length-1;
    for (int i = 0; i < hexString.length; i++) {
        char c = [hexString characterAtIndex:i];
        if (c < 48 || c > 70 || (c > 57 && c < 65)) {
            break;
        }
        boundary = i;
    }
    unsigned long long sum = 0;
    for (int i = 0; i <= boundary; i++) {
        char c = [hexString characterAtIndex:i];
        //        NSString *cString
        if (c > 47 && c < 58) {
            sum += ((c-48)*powl(16, boundary-i));
        }else if (c > 64 && c < 71){
            sum += ((c-55)*powl(16, boundary-i));
        }else {
            break;
        }
    }
    return [NSString stringWithFormat:@"%llu", sum];
}

- (NSString *)convertDec2Hex {
    NSString *decString = [self copy];
    NSString *regex = @"^[0-9]+$";
    NSRange range = [decString rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return nil;
    }
    decString = [decString uppercaseString];
    if (!decString || decString.length < 1) {
        return @"";
    }
    NSUInteger boundary = decString.length-1;
    for (int i = 0; i < decString.length; i++) {
        char c = [decString characterAtIndex:i];
        if (c < 48 || c > 57) {
            break;
        }
        boundary = i;
    }
    unsigned long long decNum = [[decString substringToIndex:boundary+1] longLongValue];
    unsigned int yushu = 0;
    NSArray *cArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A", @"B", @"C", @"D", @"E", @"F"];
    NSMutableString *hexString = [NSMutableString string];
    //    int index = 0;
    while (decNum > 0) {
        yushu = decNum % 16;
        decNum = decNum / 16;
        [hexString insertString:[NSString stringWithFormat:@"%@", cArray[yushu]] atIndex:0];
        //        hexNum += (yushu * powl(16, index++));
    }
    return hexString;
}
@end
