//
//  ViewController.m
//  SM2Tool
//
//  Created by 刘江 on 2019/7/24.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "ViewController.h"
#import "SM2Tool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSString *private_key = @"DECF275678689761800D1ED9CFE273399AEEC68615E714048497BBD54A1806EF";
    NSString *public_key_x = @"0DD07FEDF022941161F7CD3F44C19D85E72D7FC0BA7CAE2D9834DD5D91A82813";
    NSString *public_key_y = @"29A01651987B2E603051FE51CA13A4428153C6C6669E763DB9242DA856D85647";
    NSString *user_id = @"abcd";
    
    NSString *plain_text = @"Objective-C 是世界上最美好的语言";
    NSString *hex_text = @"F022941161";
    
    NSString *signed_plainStr = [SM2Tool sm2signWithPlainText:plain_text privateKey:private_key userId:user_id];
    BOOL verified1 = [SM2Tool sm2verifyWithPlainText:plain_text signText:signed_plainStr publicKey:[public_key_x stringByAppendingString:public_key_y] userId:user_id];
    BOOL verified2 = [SM2Tool sm2verifyWithPlainText:plain_text signRText:[signed_plainStr substringToIndex:64] signSText:[signed_plainStr substringFromIndex:64] publicKeyX:public_key_x publicKeyY:public_key_y userId:user_id];
    
    NSString *signed_hexStr = [SM2Tool sm2signWithHexText:hex_text privateKey:private_key userId:user_id];
    BOOL verify3 = [SM2Tool sm2verifyWithHexText:hex_text signText:signed_hexStr publicKey:[public_key_x stringByAppendingString:public_key_y] userId:user_id];
    BOOL verify4 = [SM2Tool sm2verifyWithHexText:hex_text signRText:[signed_hexStr substringToIndex:64] signSText:[signed_hexStr substringFromIndex:64] publicKeyX:public_key_x publicKeyY:public_key_y userId:user_id];
    
    NSString *encrypt_plainStr = [SM2Tool sm2EncryptWithPlainText:plain_text publicKey:[public_key_x stringByAppendingString:public_key_y]];
    NSString *decrypt_plainStr = [SM2Tool sm2DecryptPlainTextWithSecureText:encrypt_plainStr privateKey:private_key];
    
    NSString *encrypt_hexStr = [SM2Tool sm2EncryptWithHexText:hex_text publicKey:[public_key_x stringByAppendingString:public_key_y]];
    NSString *decrypt_hexStr = [SM2Tool sm2DecryptHexTextWithSecureText:encrypt_hexStr privateKey:private_key];
        
    
    
}


@end
