//
//  SM2Tool.m
//  EntranceControl
//
//  Created by 刘江 on 2019/7/4.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "SM2Tool.h"
#import "NSData+Hex.h"
#import "NSString+Convert.h"
#import"part4.h"
#import "part2.h"

@implementation SM2Tool

+ (NSString *)sm2signWithPlainText:(NSString *)plainText privateKey:(NSString *)privateKey userId:(NSString *)userId {
  
    NSAssert(([plainText isKindOfClass:[NSString class]] && [privateKey isKindOfClass:[NSString class]] && [userId isKindOfClass:[NSString class]]), @"[SM2Tool sm2signWithPlainText:privateKey:userId:], argu not support!");
    NSAssert(([plainText convertHex2Dec] != nil && [privateKey convertHex2Dec] != nil && [userId convertHex2Dec] != nil && privateKey.length == 64), @"[SM2Tool sm2signWithPlainText:privateKey:userId:], argu is invalid!");

    
    if ([privateKey hasPrefix:@"0"]) { //rmove invalid byte
        int index = 0;
        for (int i = 0; i < privateKey.length; i+=2) {
            char a = [privateKey characterAtIndex:i];
            char b = [privateKey characterAtIndex:i+1];
            if (a != 48 || b != 48) {
                index = i;
                break;
            }
        }
        privateKey = [privateKey substringFromIndex:index];
    }
    
    const char *pri_key =[NSData dataFromHexString:privateKey].bytes; //convert c character;
    char pub_key_x[100] = {'\0'};
    char pub_key_y[100] = {'\0'};
    sm2_gen_key([privateKey cStringUsingEncoding:NSUTF8StringEncoding], pub_key_x, pub_key_y);
    NSString *pub_x_str = [[NSString alloc]initWithData:[[NSData alloc]initWithBytes:pub_key_x length:64] encoding:NSUTF8StringEncoding];
    NSString *pub_y_str = [[NSString alloc]initWithData:[[NSData alloc]initWithBytes:pub_key_y length:64] encoding:NSUTF8StringEncoding];
    NSData *user_id = [NSData dataFromHexString:userId];
    NSData *plainData = [NSData dataFromHexString:plainText];

    char signR[1024];
    char signS[1024];
     sm2Sign(user_id.bytes, user_id.length, plainData.bytes, plainData.length, pri_key, (unsigned char *)[NSData dataFromHexString:pub_x_str].bytes, (unsigned char *)[NSData dataFromHexString:pub_y_str].bytes, signR, signS);
    
    NSString *signRString = [[NSString alloc]initWithData:[[NSData alloc]initWithBytes:signR length:64] encoding:NSUTF8StringEncoding];
    NSString *signSString = [[NSString alloc]initWithData:[[NSData alloc]initWithBytes:signS length:64] encoding:NSUTF8StringEncoding];
    
    return [signRString stringByAppendingString:signSString];
}

+ (BOOL)sm2verifyWithPlainText:(NSString *)plainText signText:(NSString *)signText publicKey:(NSString *)publicKey userId:(NSString *)userId {
    NSAssert(([plainText isKindOfClass:[NSString class]] && [signText isKindOfClass:[NSString class]] && [publicKey isKindOfClass:[NSString class]] && [userId isKindOfClass:[NSString class]]), @"[SM2Tool sm2verifyWithPlainText: signText:publicKey:userId:], argu not support!");
    NSAssert(([signText length] == 64*2 && [publicKey length] == 64*2), @"[SM2Tool sm2verifyWithPlainText: signText:publicKey:userId:], argu is invalid!");
    return [self sm2verifyWithPlainText:plainText signRText:[signText substringToIndex:64] signSText:[signText substringFromIndex:64] publicKeyX:[publicKey substringToIndex:64] publicKeyY:[publicKey substringFromIndex:64] userId:userId];
}

+ (BOOL)sm2verifyWithPlainText:(NSString *)plainText signRText:(NSString *)signR signSText:(NSString *)signS publicKeyX:(NSString *)keyX publicKeyY:(NSString *)keyY userId:(NSString *)userId {
    NSAssert(([plainText isKindOfClass:[NSString class]] && [signR isKindOfClass:[NSString class]] && [signS isKindOfClass:[NSString class]] && [keyX isKindOfClass:[NSString class]] && [keyY isKindOfClass:[NSString class]] && [userId isKindOfClass:[NSString class]]), @"[SM2Tool sm2verifyWithPlainText:signRText:signSText:publicKeyX:publicKeyY:userId:], argu not support!");
    
    NSAssert(([plainText convertHex2Dec] != nil && [signS convertHex2Dec] != nil && [signR convertHex2Dec] != nil && [keyX convertHex2Dec] != nil && [keyY convertHex2Dec] != nil && [userId convertHex2Dec] != nil && signR.length ==64 && signS.length == 64 && keyX.length == 64 && keyY.length == 64), @"[SM2Tool sm2verifyWithPlainText:signRText:signSText:publicKeyX:publicKeyY:userId:], argu is invalid!");
    NSData *plain_data = [NSData dataFromHexString:plainText];
    NSData *signR_data = [NSData dataFromHexString:signR];
    NSData *signS_data = [NSData dataFromHexString:signS];
    NSData *px_data = [NSData dataFromHexString:keyX];
    NSData *py_data = [NSData dataFromHexString:keyY];
    NSData *userId_data = [NSData dataFromHexString:userId];
    
    int result = sm2CheckSign((char *)userId_data.bytes,userId_data.length,(char *)plain_data.bytes,plain_data.length,(unsigned char *)px_data.bytes,(unsigned char *)py_data.bytes,(char *)signR_data.bytes,(char *)signS_data.bytes);
    
    return result;
}

+ (NSString *)sm2EncryptWithPlainText:(NSString *)plainText publicKey:(NSString *)publicKey {
    
    NSAssert(([plainText isKindOfClass:[NSString class]] && [publicKey isKindOfClass:[NSString class]]), @"[SM2Tool sm2EncryptWithPlainText:publicKey:], argu not support!");
    NSAssert([publicKey length] == 64*2, @"[SM2Sign sm2EncryptWithPlainText:publicKey:], argu is invalid!");
    return [self sm2EncryptWithPlainText:plainText publicKeyX:[publicKey substringToIndex:64] publicKeyY:[publicKey substringFromIndex:64]];
}

+ (NSString *)sm2EncryptWithPlainText:(NSString *)plainText publicKeyX:(NSString *)keyX publicKeyY:(NSString *)keyY {
    NSAssert(([plainText isKindOfClass:[NSString class]] && [keyX isKindOfClass:[NSString class]] && [keyY isKindOfClass:[NSString class]]), @"[SM2Tool sm2EncryptWithPlainText:publicKeyX:publicKeyY:], argu not support!");
    
    NSAssert(([plainText convertHex2Dec] != nil && [keyX convertHex2Dec] != nil && [keyX convertHex2Dec] != nil && keyX.length == 64 && keyY.length == 64), @"[SM2Tool sm2EncryptWithPlainText:publicKeyX:publicKeyY:], argu is invalid!");
    
    char encrypt_c[1024] = {'\0'};
    if (plainText.length%2 != 0) {
        plainText = [@"0" stringByAppendingString:plainText];
    }
    NSData *plainText_data = [NSData dataFromHexString:plainText];
    NSData *px_data = [NSData dataFromHexString:keyX];
    NSData *py_data = [NSData dataFromHexString:keyY];
    
     sm2JiaMiWithPublicKey(sm2_param_recommand, TYPE_GFp, 256, (char *)plainText_data.bytes, plainText_data.length, encrypt_c, (unsigned char *)px_data.bytes, (unsigned char *)py_data.bytes);
    NSData *encrypt_data = [[NSData alloc]initWithBytes:encrypt_c length:96+plainText.length/2+plainText.length%2+1];
    
   
    NSString *encrypt_str = [NSData hexStringFromData:encrypt_data];
    
    
    return [encrypt_str substringFromIndex:2];
}

+ (NSString *)sm2DecryptWithSecureText:(NSString *)secureText privateKey:(NSString *)privateKey {
    NSAssert(([secureText isKindOfClass:[NSString class]] && [privateKey isKindOfClass:[NSString class]]), @"[SM2Tool sm2DecryptWithPlainText:publicKeyX:privateKey:], argu not support!");
    NSAssert(([secureText convertHex2Dec] != nil && [privateKey convertHex2Dec] != nil && privateKey.length == 64), @"[SM2Tool sm2EncryptWithPlainText:publicKeyX:publicKeyY:], argu is invalid!");
    
    char decrypt_c[1024] = {'\0'};
    NSData *secureText_data = [NSData dataFromHexString:[@"04" stringByAppendingString:secureText]];
    NSData *privateKey_data = [NSData dataFromHexString:privateKey];
   
    
    sm2JiemiWithPrivateKey(sm2_param_recommand, TYPE_GFp, 256, (char *)secureText_data.bytes, (char*)[privateKey UTF8String], decrypt_c, secureText.length/2+secureText.length%2-96);
    NSString *decrypt_str = [NSData hexStringFromData:[[NSData alloc]initWithBytes:decrypt_c length:secureText.length/2+secureText.length%2-96]];
    
    return decrypt_str;
}

@end
