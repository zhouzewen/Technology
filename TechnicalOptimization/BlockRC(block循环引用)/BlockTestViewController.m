//
//  BlockTestViewController.m
//  Test
//
//  Created by 周泽文 on 2017/8/17.
//  Copyright © 2017年 CivetDev. All rights reserved.
//

#import "BlockTestViewController.h"
typedef void(^block_t2)(void);
@interface BlockTestViewController (){
//    block_t2 blk2;
}

@end

@implementation BlockTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    //    blk2 = ^{
    //        NSLog(@"self = %@",self);
    //    };
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc{
    NSLog(@"dealloc");
    [super dealloc];
}
@end
