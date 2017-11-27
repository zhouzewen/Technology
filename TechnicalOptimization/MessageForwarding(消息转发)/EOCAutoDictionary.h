//
//  EOCAutoDictionary.h
//  MessageForwarding
//
//  Created by 周泽文 on 2017/7/19.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOCAutoDictionary : NSObject
@property(nonatomic,strong)NSString *string;
@property(nonatomic,strong)NSNumber *number;
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)id opaqueObject;
@end
