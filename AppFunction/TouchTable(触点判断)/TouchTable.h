//
//  TouchTable.h
//  DelegateTest
//
//  Created by 周泽文 on 2017/7/4.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TouchTableDelegate
-(void)fingerTouchPoint:(CGPoint)point;
@end
@interface TouchTable : UITableView
@property(nonatomic,assign)id<TouchTableDelegate>touchDelegate;
@end
