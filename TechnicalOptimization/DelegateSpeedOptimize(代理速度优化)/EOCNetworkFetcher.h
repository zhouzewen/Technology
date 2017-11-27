//
//  EOCNetworkFetcher.h
//  DelegateSpeedOptimize
//
//  Created by 周泽文 on 2017/7/20.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EOCNetworkFetcher;
@protocol EOCNetworkFetcherDelegate<NSObject>
@optional
-(void)networkFetcher:(EOCNetworkFetcher *)fetcher didReceiveData:(NSData *)data;
-(void)networkFetcher:(EOCNetworkFetcher *)fethcer didFailWithError:(NSError *)error;
-(void)networkFetcher:(EOCNetworkFetcher *)fetcher didUpdateProgressTo:(float)progress;
@end
@interface EOCNetworkFetcher : NSObject
@property(nonatomic,weak)id<EOCNetworkFetcherDelegate>delegate;
@end
