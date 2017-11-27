//
//  DelegateTestClass2.h
//  DelegateTest
//
//  Created by 周泽文 on 2017/7/3.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol delegate2

@end
@interface DelegateTestClass2 : NSObject
@property(nonatomic,assign)id<delegate2>delegate2;

@end
