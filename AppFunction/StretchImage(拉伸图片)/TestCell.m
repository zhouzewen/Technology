//
//  TestCell.m
//  StretchImage
//
//  Created by 周泽文 on 2017/8/4.
//  Copyright © 2017年 zhouzewen. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 110)];
        
        /**
         图片必须放到2x 的位置才能正确的拉伸 保持其他位置不变形
         */
        UIImage * background = [UIImage imageNamed:@"img_优惠券_background"];
        background = [background stretchableImageWithLeftCapWidth:background.size.width*0.01 topCapHeight:10];
        _backImageView.image = background;
        [self.contentView addSubview:_backImageView];
        
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
