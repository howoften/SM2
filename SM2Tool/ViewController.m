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
    NSString *plain_text = @"123456";
    NSString *user_id = @"abcd";
    
    NSString *signedStr = [SM2Tool sm2signWithPlainText:plain_text privateKey:private_key userId:user_id];
    BOOL verified = [SM2Tool sm2verifyWithPlainText:plain_text signText:signedStr publicKey:[public_key_x stringByAppendingString:public_key_y] userId:user_id];
    
    NSString *encrypt_str = [SM2Tool sm2EncryptWithPlainText:plain_text publicKeyX:public_key_x publicKeyY:public_key_y];
    NSString *decrypt_str = [SM2Tool sm2DecryptWithSecureText:encrypt_str privateKey:private_key];
    
    
    
    
}


@end
