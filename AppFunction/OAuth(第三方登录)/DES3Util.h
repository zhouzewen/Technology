//
//  DES3Util.h
//  OAuth(第三方登录)
//
//  Created by 周泽文 on 2017/12/12.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject
+(NSString *)AES128Encrypt:(NSString *)text;
@end
