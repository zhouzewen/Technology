//
//  TestViewController.m
//  DistanceSensor
//
//  Created by 周泽文 on 2017/10/20.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "TestViewController.h"
#import "ViewController.h"
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}
- (IBAction)pushNextView:(UIButton *)sender {
    ViewController * vc = [[ViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
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

@end
