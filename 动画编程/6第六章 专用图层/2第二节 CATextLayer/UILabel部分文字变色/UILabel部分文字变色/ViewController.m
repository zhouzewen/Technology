//
//  ViewController.m
//  UILabel部分文字变色
//
//  Created by 周泽文 on 16/7/27.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *labelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor] ;
    // create a text layer
    CATextLayer * textLayer = [CATextLayer layer] ;
    textLayer.frame = self.labelView.bounds ;
    [self.labelView.layer addSublayer:textLayer] ;
    
    // set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor ;
    textLayer.alignmentMode = kCAAlignmentJustified ;
    textLayer.wrapped = YES ;
    textLayer.contentsScale = [UIScreen mainScreen].scale ; // 设置文字的分辨率
    UIFont * font = [UIFont systemFontOfSize:15] ;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName ;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName) ;
    textLayer.font = fontRef ;
    textLayer.fontSize = font.pointSize ;
    CGFontRelease(fontRef) ;
    
    NSString * text = @"Lorem ipsum dolor sit amet , consectetur adipiscing jfoe jfoa mg mdg fmeg ejgoag, foaghojd " ;
     textLayer.string = text ;

   
}



@end
