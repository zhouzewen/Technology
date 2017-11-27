//
//  ViewController.m
//  FPS_Caculate
//
//  Created by 周泽文 on 2017/7/7.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
//#import "YYFPSLabel.h"
#import "FPSCaculate_Label.h"
#import "FPS_Label.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) FPS_Label * label;
@property (nonatomic,retain) UILabel * testLabel;
@end

@implementation ViewController
-(void)setLabel:(FPS_Label *)label{
    if (_label != label) {
        [_label release];
        _label = [label retain];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView * table = [[UITableView alloc] initWithFrame:self.view.frame];
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    
//    __weak typeof(self) weakSelf = self;
//    YYFPSLabel * label = [[YYFPSLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    [self.view addSubview:label];
    
//    FPSCaculate_Label * label = [[FPSCaculate_Label alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    [self.view addSubview:label];
//    _label = [[FPS_Label alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    /**
     self.label =[[FPS_Label alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
     这种方式 会导致 alloc出来的对象引用计数器为2 内存泄漏
     
     MRC中 创建对象的两种正确方式
     */
    
    //1
//    FPS_Label * label = [[FPS_Label alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    self.label = label;
//    [label release];
    //2
    _label = [[FPS_Label alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:self.label];
    NSLog(@"%ld",self.label.retainCount);
    
    [self testRetainCount];
}
-(void)testRetainCount{
//    self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    _testLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    NSLog(@"%ld",_testLabel.retainCount);
    [self.view addSubview:_testLabel];
    NSLog(@"%ld",_testLabel.retainCount);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dribbble256_imageio" ofType:@"png"]];
//    cell.imageView.image = [UIImage imageNamed:@"cube"];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_label release];
    NSLog(@"%ld",_label.retainCount);
    [_testLabel release];
    NSLog(@"%ld",_testLabel.retainCount);
    [super dealloc];
}

@end
