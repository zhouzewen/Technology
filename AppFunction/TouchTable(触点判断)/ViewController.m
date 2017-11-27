//
//  ViewController.m
//  DelegateTest
//
//  Created by 周泽文 on 2017/7/3.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import "DelegateTestClass.h"
#import "DelegateTestClass2.h"
#import "TouchTable.h"
#import "Caculate.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TouchTableDelegate,delegate,delegate2>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TouchTable * table = [[TouchTable alloc] initWithFrame:self.view.frame];
    table.delegate = self;
    table.dataSource = self;
    table.touchDelegate = self;
    [self.view addSubview:table];
    
    
    DelegateTestClass * class = [[DelegateTestClass alloc] init];
    class.delegate = self;
    
    DelegateTestClass2 * class2 = [[DelegateTestClass2 alloc] init];
    class2.delegate2 = self;
    
    [class isEqual:class2];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
}
-(void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
    NSLog(@"%s",__func__);
}
-(void)fingerTouchPoint:(CGPoint)point{
    NSLog(@"%s",__func__);
    NSLog(@"%@",NSStringFromCGPoint(point));
    
    locationInCurrentView position = [Caculate locationInView:self.view withPoint:point];
    switch (position) {
        case left:
            NSLog(@"左边");
            break;
            
        default:
            NSLog(@"右边");
            break;
    }}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
