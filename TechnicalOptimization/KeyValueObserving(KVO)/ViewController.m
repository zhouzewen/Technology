//
//  ViewController.m
//  KeyValueObserving(KVO)
//
//  Created by 周泽文 on 2017/11/4.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "LYPerson.h"
@interface ViewController ()
@property(nonatomic,strong)LYPerson *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LYPerson *person = [[LYPerson alloc]init];
    person.name = @"222";
    self.person = person;
    [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    person.name = @"111";
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"change:%@",change);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
