//
//  ViewController.m
//  Encrypt&Decrypt(加密和解密)
//
//  Created by 周泽文 on 2017/12/26.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "ZZW_Model.h"
#import "ZZW_AES.h"
#import "ZZW_MD5.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *plainText = @"I Love You";
    NSString *encryptStr = [ZZW_AES AES_EncryptText:plainText WithKey:keyFor32 andIV:IV];
    NSString *decryptStr = [ZZW_AES AES_DecryptText:encryptStr WithKey:keyFor32 andIV:IV];
    NSLog(@"%@",decryptStr);
    
    NSString *md5Str1 = [ZZW_MD5 MD5_32ByteLowerCaseWithPlainText:plainText];
    NSString *md5Str2 = [ZZW_MD5 MD5_32ByteUpperCaseWithPlainText:plainText];
    NSLog(@"%@",md5Str2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
