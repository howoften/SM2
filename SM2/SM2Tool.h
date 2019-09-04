//
//  SM2Tool.h
//  EntranceControl
//
//  Created by 刘江 on 2019/7/4.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SM2Tool : NSObject
/**
以下方法中所有参数都为 字节数组中16进制数值 直接对应的字符串
 
 eg. Byte sample_c[] = {0x30, 0x5B, 0xF0, 0x71};
     对应参数应为 NSString *sample_str = @"305BF071";
 
 ps.SM2中公钥为 publicKeyX + publicKeyY, 签名结果为 SignR + SignS, 所以以下同功能会提供两种实现, 你可以拼接后当一个参数传入, 也可以分开传入. 对应以下(第二和第三方法),(第四和第五方法).
 */

+ (NSString *)sm2signWithHexText:(NSString *)hexText privateKey:(NSString *)privateKey userId:(NSString *)userId;
+ (NSString *)sm2signWithPlainText:(NSString *)plainText privateKey:(NSString *)privateKey userId:(NSString *)userId;

+ (BOOL)sm2verifyWithHexText:(NSString *)hexText signText:(NSString *)signText publicKey:(NSString *)publicKey userId:(NSString *)userId;
+ (BOOL)sm2verifyWithPlainText:(NSString *)plainText signText:(NSString *)signText publicKey:(NSString *)publicKey userId:(NSString *)userId;

+ (BOOL)sm2verifyWithHexText:(NSString *)hexText signRText:(NSString *)signR signSText:(NSString *)signS publicKeyX:(NSString *)keyX publicKeyY:(NSString *)keyY userId:(NSString *)userId;
+ (BOOL)sm2verifyWithPlainText:(NSString *)plainText signRText:(NSString *)signR signSText:(NSString *)signS publicKeyX:(NSString *)keyX publicKeyY:(NSString *)keyY userId:(NSString *)userId;

+ (NSString *)sm2EncryptWithHexText:(NSString *)hexText publicKey:(NSString *)publicKey;
+ (NSString *)sm2EncryptWithPlainText:(NSString *)plainText publicKey:(NSString *)publicKey;

+ (NSString *)sm2EncryptWithHexText:(NSString *)hexText publicKeyX:(NSString *)keyX publicKeyY:(NSString *)keyY;
+ (NSString *)sm2EncryptWithPlainText:(NSString *)plainText publicKeyX:(NSString *)keyX publicKeyY:(NSString *)keyY;

+ (NSString *)sm2DecryptHexTextWithSecureText:(NSString *)secureText privateKey:(NSString *)privateKey;
+ (NSString *)sm2DecryptPlainTextWithSecureText:(NSString *)secureText privateKey:(NSString *)privateKey;

@end

