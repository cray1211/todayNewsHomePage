
//
//  headerCollectionViewCell.m
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "headerCollectionViewCell.h"
#import <Masonry.h>
@implementation headerCollectionViewCell
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor grayColor];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}




- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
}



@end
