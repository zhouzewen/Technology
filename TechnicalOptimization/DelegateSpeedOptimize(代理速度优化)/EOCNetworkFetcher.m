//
//  EOCNetworkFetcher.m
//  DelegateSpeedOptimize
//
//  Created by 周泽文 on 2017/7/20.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "EOCNetworkFetcher.h"
@interface EOCNetworkFetcher(){
    struct{
        unsigned int didReceiveData      :1;
        unsigned int didFailWithError    :1;
        unsigned int didUpdateProgressTo :1;
    }_delegateFlag;
    
    float currentProgress;
}

@end

@implementation EOCNetworkFetcher
-(void)setDelegate:(id<EOCNetworkFetcherDelegate>)delegate{
    _delegate = delegate;
    _delegateFlag.didReceiveData = [delegate respondsToSelector:@selector(networkFetcher:didReceiveData:)];
    _delegateFlag.didFailWithError = [delegate respondsToSelector:@selector(networkFetcher:didFailWithError:)];
    _delegateFlag.didUpdateProgressTo = [delegate respondsToSelector:@selector(networkFetcher:didUpdateProgressTo:)];
}

-(void)callBackMethod{
    if (_delegateFlag.didUpdateProgressTo) {
        [_delegate networkFetcher:self didUpdateProgressTo:currentProgress];
    }
}
@end
