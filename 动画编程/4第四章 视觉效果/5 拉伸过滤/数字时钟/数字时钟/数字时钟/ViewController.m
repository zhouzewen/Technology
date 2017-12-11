//
//  ViewController.m
//  数字时钟
//
//  Created by fox/周泽文 on 16/7/21.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

//  kCAFilterLinear 与 kCAFilterNearest
/*********************************************
 1.kCAFilterLinear 双线性滤波算法，放大倍数较大的时候较模糊，其他情况下得到的效果不错。
 2.kCAFilterNearest 最近过滤算法，图中很少斜线时，呈现的效果比较好。
 线性过滤保留了形状，最近过滤保留了像素的差异。
 所以当图片中极少斜线，需要放大很多倍的时候，采用最近过滤效果更好。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
// 从Storyboard往控制器连线的时候 connection 由Outlet改为 OutletCollection
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *digitViews; @property (nonatomic,strong) NSTimer *timer ;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData] ;
    
    [self drawCirclePoint] ; // 绘制 黑色小圆点 做冒号
}

-(void)initializeData
{
    UIImage *digits = [UIImage imageNamed:@"Digits"] ;
    for (UIView * view in self.digitViews)
    {
        view.layer.contents = (__bridge id)digits.CGImage ; // 图层添加 寄宿图
        // Digits 图片 是 0 1 2 3 4 5 6 7 8 9 这是个数字组成的图片，所以每个数字
        // 占图片的宽度都是0.1，因此contentsRect的宽度是0.1
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0) ; // 寄宿图可见范围,是Digits的第一个数字0,即初始化所有的view为0
        view.layer.contentsGravity = kCAGravityResizeAspect ; // 寄宿图等比例拉伸
        view.layer.magnificationFilter = kCAFilterNearest ; //最近过滤算法
//        view.layer.magnificationFilter = kCAFilterLinear ; //双线性滤波算法
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES] ;
    
    //  优化
    /*********************************************
     1.这样手动调用 timer方法 会使程序已进入画面的时候就能够显示 时分秒
     2.如果不这样手动调用，那么程序一进入画面 时分秒会先都显示00，
     然后突然变为系统时间，之后开始读秒，效果非常的不好。
     *********************************************/
    [self tick] ;
}

-(void)tick
{
    // 创建日历，根据系统的时间
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    
    // 创建 时分秒 格式
    NSUInteger units = NSCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond ;
    
    // 创建 日期组件
    NSDateComponents * components = [calendar components:units fromDate:[NSDate date]] ;
    
    // get hour
    [self setDigit:components.hour/10 forView:self.digitViews[0]] ;
    [self setDigit:components.hour%10 forView:self.digitViews[1]] ;
    
    // get minute
    [self setDigit:components.minute/10 forView:self.digitViews[2]] ;
    [self setDigit:components.minute%10 forView:self.digitViews[3]] ;
    
    // get second
    [self setDigit:components.second/10 forView:self.digitViews[4]] ;
    [self setDigit:components.second%10 forView:self.digitViews[5]] ;
    
}

-(void)setDigit:(NSInteger)digit forView:(UIView *)view
{
    view.layer.contentsRect = CGRectMake(digit*0.1, 0, 0.1, 1.0) ;
}

-(void)drawCirclePoint
{
    UIBezierPath * path = [[UIBezierPath alloc] init] ;
    
    // 画 小时和分钟之间的 :
    [path moveToPoint:CGPointMake(100, 90)] ;
    [path addArcWithCenter:CGPointMake(105, 90) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES] ;
    
    [path moveToPoint:CGPointMake(100, 110)] ;
    [path addArcWithCenter:CGPointMake(105, 110) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES] ;
    
    // 画 分钟和秒钟之间的 ：
    [path moveToPoint:CGPointMake(210, 90)] ;
    [path addArcWithCenter:CGPointMake(215, 90) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES] ;
    
    [path moveToPoint:CGPointMake(210, 110)] ;
    [path addArcWithCenter:CGPointMake(215, 110) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES] ;
    
    // 将 画的四个原点 用layer画出来
    CAShapeLayer * shapeLayer = [CAShapeLayer layer] ;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor ;
    shapeLayer.fillColor = [UIColor blackColor].CGColor ;
    shapeLayer.path = path.CGPath ;
    
    // 把layer画出来的四个点 添加到 父图层上
    [self.backgroundView.layer addSublayer:shapeLayer] ;
}
@end
