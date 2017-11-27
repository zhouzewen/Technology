//
//  ViewController.m
//  Localizable(多语系)
//
//  Created by 周泽文 on 2017/9/22.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.label.text = NSLocalizedString(@"labelText", nil);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
