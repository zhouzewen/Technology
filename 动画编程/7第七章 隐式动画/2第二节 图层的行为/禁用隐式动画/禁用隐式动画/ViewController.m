//
//  ViewController.m
//  推进过渡
//
//  Created by fox/周泽文 on 16/8/4.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


/*********************************************
 1.对视图的图层做属性的改变的时候，动画会被禁用。这和改变单独图层的属性是不同的。
 UIView禁用了隐式动画。
 2.改变属性是，CALayer自动应用的动画，我们称之为行为。
 CALayer属性修改的时候，会有下面的操作
 
 首先，图层检测自己是否有委托，并且是否实现了CALayerDelegate协议指定的
 -actionForLayer:forKey方法。如果有，直接调用并返回结果。
 
 其次，在没有委托，或者有委托但没有实现-actionForLayer:forKey方法。
 图层接着检查包含属性名称对应行为映射的actions字典。
 
 再次，actions字典没有对应的属性，图层接着在自己的style字典搜索属性名。
 
 最后，style中也找不到对应的属性，图层会直接调用定义了每个属性标准行为的
 -defaultActionForKey:方法
 
 四步完成之后，-actionForKey：返回为空，会造成没有动画；其余的情况都会有动画。
 第二章寄宿图中，介绍CALayerDelegate的时候，提到过UIView在创建它的图层的时候
 会自动把图层的CALayerDelegate设置为自己。其实还提供了-actionForLayer:forKey的实现。
 
 如果没有在UIView自己的动画方法中实现，-actionForLayer:forKey返回的都是nil，
 在UIView自己的动画方法中实现，-actionForLayer:forKey返回就不是nil。
 
 这个方式不是禁用隐式动画的唯一方式
 CATransaction有一个方法+setDisableActins:可以用来对所有的属性，打开或者关闭隐式动画。
 [CATransaction setDisableActions:YES] ;
 
 *********************************************/

//  总结
/*********************************************
 1.UIView关联的图层禁用了隐式动画，对这种图层做动画的方式就是使用UIView的动画函数
或 继承UIView 然后覆盖-actionForLayer:forKey方法，或 直接创建一个显示动画。
 
 2.单独存在的图层，可以通过实现图层的-actionForLayer:forKey方法，或者提供一个actions字典
 来控制隐式动画。
 *********************************************/

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;
}

-(void)initializeData
{
    self.containerView.layer.backgroundColor = [UIColor blueColor].CGColor ;
    
    NSLog(@"UIView动画方法之外调用-actionForLayer:forKey方法，返回值是:%@",[self.containerView actionForLayer:self.containerView.layer forKey:@"backgroundColor"]) ;
    [UIView beginAnimations:nil context:nil] ;
    NSLog(@"UIView动画方法之内调用-actionForLayer:forKey方法，返回值是:%@",[self.containerView  actionForLayer:self.containerView.layer forKey:@"backgroundColor"]) ;
    [UIView commitAnimations] ;
    
}

- (IBAction)changeColor:(id)sender
{
    [CATransaction begin] ;
    
    // 虽然这里设置了事务的时间为2秒，但是颜色的改变还是瞬间就变化了，
    // 说明隐式动画被禁用了
    [CATransaction setAnimationDuration:2.0] ;
    
    CGFloat red = arc4random()/(CGFloat)INT_MAX ;
    CGFloat blue = arc4random()/(CGFloat)INT_MAX ;
    CGFloat green = arc4random()/(CGFloat)INT_MAX ;
    self.containerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor ;
    [CATransaction commit] ;
}
@end
