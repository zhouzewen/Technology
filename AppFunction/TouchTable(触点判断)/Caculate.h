//
//  Caculate.h
//  DelegateTest
//
//  Created by 周泽文 on 2017/7/4.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,locationInCurrentView) {
    left,
    right
};
@interface Caculate : NSObject
+(locationInCurrentView)locationInView:(UIView*)view withPoint:(CGPoint)point;
@end
