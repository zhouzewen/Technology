//
//  DelegateTestClass.h
//  DelegateTest
//
//  Created by 周泽文 on 2017/7/3.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol delegate

@end
@interface DelegateTestClass : NSObject
@property(nonatomic,assign)id<delegate>delegate;
@end
