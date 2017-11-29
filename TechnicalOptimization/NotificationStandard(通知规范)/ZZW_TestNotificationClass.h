//
//  ZZW_TestNotificationClass.h
//  NotificationStandard(通知规范)
//
//  Created by 周泽文 on 2017/11/29.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 1 导入UIKitDefines.h头文件才能找到 UIKIT_EXTERN宏
 2 NSNotificationName 代表了字符串类型
 3 通知的命名规范
     3.1 用类的前缀作为前缀 比如这里的ZZW_
     3.2 Notification 作为后缀
     3.3 中间加上时机的词 will  Did 等
     3.4 如果有版本的限制，就要在后面加上，比如 NS_AVAILABLE_IOS(4_0)
 4 然后在.m文件中去定义通知的内容，一般和通知名字相同
 
 详情可以参考苹果文档的命名规范来定义
 参考文章 http://www.cocoachina.com/ios/20171123/21298.html
 */
#import <UIKit/UIKitDefines.h>
UIKIT_EXTERN NSNotificationName const ZZW_textWillChangeNotification NS_AVAILABLE_IOS(4_0);
@interface ZZW_TestNotificationClass : NSObject

@end
