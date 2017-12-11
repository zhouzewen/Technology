//
//  ViewController.m
//  平滑过渡
//
//  Created by fox/周泽文 on 16/8/10.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//


//  为什么会有过渡的概念
/*********************************************
 1.iOS应用，通过属性动画来对比较难做的动画布局进行一些改变。
 如交换一段文本和图片，或用一段网格视图来替换等等
 
 2.属性动画只对图层的可动画属性起作用，若要改变一个不能动画的属性(如图片)
 或者从层级关系中添加或者移除图层，属性动画不会起作用。
 
 3.因此，过渡就被提出来解决属性动画的不足了。
 和属性动画平滑在两个值之间做动画不同，过渡影响到整个图层的变化。
 过渡动画首先展示之前的图层外观，然后通过一个交换过渡到新值的外观。
 
 4.使用CATransition创建过渡动画，CATransition也是CAAnimation的子类
 但CATransition有type和subtype用来标识变换效果。
 type属性是NSString 有四个值可选，默认是kCATransitionFade
 kCATransitonFade   淡入淡出
 kCATransitonMoveIn 顶部滑动进入
 kCATransitionPush 新图层左侧进入，旧图层右侧推出
 kCATransitionReveal 旧图层推出，新图层在旧图层下面
目前只能选四者之一，但可以通过其他方法自定过渡效果，后续章节会提到。
 
 后面三种过渡类型都有默认的动画方向，可以通过subtype来控制他们的方向
 kCATransitionFromRight
 kCATransitionFromLeft
 kCATransitionFromTop
 kCATransitionFromBottom
 
 *********************************************/

//  隐式过渡
/*********************************************
 1.CATransiton 可以对图层任何变化平滑过渡，所以对图层不好做动画的属性一般都使用它。
 当设置CALayer的content属性的时候，CATransition是默认的行为。
 但和视图关联的图层，或者其他隐式动画，过渡是被禁用的。
 
 2.手动创建的图层，对图层的contents做改动都会自动附上淡入淡出的过渡动画。和改变图层
 属性自动提交事务做0.25秒动画被称为隐式动画一样，这个过渡被称为隐式过渡。
 *********************************************/
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) NSArray * imageArray ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData] ;
}

-(void)initializeData
{
    self.view.backgroundColor = [UIColor grayColor] ;
    self.containerView.backgroundColor = [UIColor grayColor] ;
    self.imageArray = @[[UIImage imageNamed:@"Anchor.png"],
                        [UIImage imageNamed:@"Cone.png"],
                        [UIImage imageNamed:@"Igloo.png"],
                        [UIImage imageNamed:@"Spaceship.png"]] ;
    
}
- (IBAction)SwitchImage:(id)sender
{
    // 方式一
    // 使用使用CATranstion来完成过渡的动画，作用在图层上
//    CATransition * transition = [CATransition animation] ;
////    transition.type = kCATransitionFade ;
//    transition.type = kCATransitionMoveIn ;
////    transition.subtype = kCATransitionFromTop ;
//    transition.subtype = kCATransitionFromBottom ;
//    [self.imageView.layer addAnimation:transition forKey:nil] ;
////    transition.duration = 1.5f ;
//    UIImage * currentImage = self.imageView.image ;
//    NSUInteger index = [self.imageArray indexOfObject:currentImage] ;
//    index = (index +1 )%[self.imageArray count] ;
//    self.imageView.image = self.imageArray[index] ;
    
    // 方式二
    // 使用  UIView的动画方法来实现过渡动画
    // options 的选择 要比 Transition的选择多，Transition只有四种动画的方式，但是options的选择更多。
    [UIView transitionWithView:self.imageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        UIImage * currentImage = self.imageView.image ;
        NSUInteger index = [self.imageArray indexOfObject:currentImage]  ;
        index = (index + 1)%[self.imageArray count] ;
        self.imageView.image = self.imageArray[index] ;
    } completion:nil] ;
    
    
}



@end
