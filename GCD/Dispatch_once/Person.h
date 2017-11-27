//
//  Person.h
//  Dispatch_once
//
//  Created by 周泽文 on 2017/6/21.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
+(Person *)shareInstance;
@end
