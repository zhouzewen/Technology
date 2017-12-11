//
//  ViewController.m
//  CALayer触摸事件传递
//
//  Created by fox/周泽文 on 16/7/18.
//  Copyright © 2016年 fox/周泽文. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (nonatomic,weak) CALayer * blueLayer ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData] ;

}

-(void)initializeData
{
    self.title = @"CALayer触摸事件传递" ;
    self.blueLayer = [CALayer layer] ;
    self.blueLayer.frame = CGRectMake(0, 0, 150, 150) ;
    self.blueLayer.backgroundColor = [UIColor blueColor].CGColor ;
    [self.whiteView.layer addSublayer:self.blueLayer] ;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view] ;
    CALayer * layer = [self.whiteView.layer hitTest:point] ;
    if (layer == self.blueLayer)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Inside blueLayer" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil] ;
        [alert addAction:cancel] ;
        
        UIAlertAction * ensureButton = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"触点在blueLayer中") ;
        }] ;
        [alert addAction:ensureButton] ;
        
        [self presentViewController:alert animated:YES completion:nil] ;
    }
    else if (layer == self.whiteView.layer)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Inside whiteLayer" message:nil preferredStyle:UIAlertControllerStyleAlert] ;
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil] ;
        [alert addAction:cancel] ;
        
        UIAlertAction * ensureButton = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"触点在whiteLayer中") ;
        }] ;
        [alert addAction:ensureButton] ;
        
        [self presentViewController:alert animated:YES completion:nil] ;
    }
}
@end
