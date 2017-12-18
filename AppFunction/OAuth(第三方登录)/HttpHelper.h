//
//  HttpHelper.h
//  WineValidation
//
//  Created by 周泽文 on 2017/7/14.
//  Copyright © 2017年 Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HttpHelperDelegate<NSObject>
-(void)serverResponseInfo:(NSDictionary*)dic;
@end
@interface HttpHelper : NSObject
typedef NS_ENUM(NSInteger, QRCodeType) {
    OutsideQRCode, // 扫描 瓶身二维码
    InsideQRCode, // 扫描 瓶盖二维码
} NS_ENUM_AVAILABLE(NSURLSESSION_AVAILABLE, 7_0);
@property(nonatomic,weak)id<HttpHelperDelegate>delegate;
-(void)postRequestWithUrl:(NSURL*)url
            response_type:(NSString *)response_type
                client_id:(NSString *)client_id
             redirect_uri:(NSString *)redirect_uri;
-(void)postRequestWithUrl:(NSURL*)url
                     code:(NSString *)code
                client_id:(NSString *)client_id
            client_secret:(NSString *)client_secret
               grant_type:(NSString *)grant_type;
-(void)postRequestWithUrl:(NSURL *)url
                       tk:(NSString *)tk
                partnerid:(NSString *)partnerid
                timestamp:(NSString *)timestamp
                 noncestr:(NSString *)noncestr;
-(void)postRequestWithUrl:(NSURL *)url andParameters:(NSString *)str;

-(void)postRequestToServerWithDic:(NSDictionary *)dic;
-(void)getRequestWith:(NSString *)str;
@end
