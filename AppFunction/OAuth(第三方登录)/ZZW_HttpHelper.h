//
//  ZZW_HttpHelper.h
//  WineValidation
//
//  Created by 周泽文 on 2017/7/14.
//  Copyright © 2017年 Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZW_HttpHelper;
@protocol ZZW_HttpHelperDelegate<NSObject>
-(void)httpHelper:(ZZW_HttpHelper *)helper responseInfo:(NSDictionary*)infoDic;
@end
@interface ZZW_HttpHelper : NSObject

@property(nonatomic,weak)id<ZZW_HttpHelperDelegate>delegate;
-(void)postRequestWithUrl:(NSURL *)url andHttpBodyString:(NSString *)httpBody;
-(void)getRequestWith:(NSString *)str;

@end
