//
//  ViewController.m
//  富文本
//
//  Created by 周泽文 on 16/7/27.
//  Copyright © 2016年 zhouzewen. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CTFont.h>
#import <Coretext/CTStringAttributes.h>
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
    
    NSString * text = @"Lorem ipsum dolor sit amet , consectetur adipiscing jfoe jfoa mg mdg fmeg ejgoag, foaghojd " ;
    // create attributed string
    NSMutableAttributedString * string = nil ;
    string = [[NSMutableAttributedString alloc] initWithString:text] ;
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName ;
    CGFloat fontSize = font.pointSize ;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL) ;
    
    // 设置 字体黑色 和 黑色字体范围
    NSDictionary * attributes = @{(__bridge id) kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor , (__bridge id)kCTFontAttributeName:(__bridge id)fontRef} ;
    [string setAttributes:attributes range:NSMakeRange(0, [text length])] ;
    
    // 设置 字体红色  下划线  红色字体范围
    attributes = @{(__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor redColor].CGColor , (__bridge id)kCTUnderlineStyleAttributeName : @(kCTUnderlineStyleSingle) , (__bridge id)kCTFontAttributeName : (__bridge id)fontRef} ;
    [string setAttributes:attributes range:NSMakeRange(6, 5)] ;
    CFRelease(fontRef) ;
    textLayer.string = string ;
}



@end
