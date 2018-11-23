
//
//  contentTableViewCell.m
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "contentTableViewCell.h"
#import <Masonry.h>
@interface  contentTableViewCell()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIImageView *contentImageView;
@end



@implementation contentTableViewCell

+ (instancetype) cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    NSString *identfier = NSStringFromClass([contentTableViewCell class]);
    contentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[contentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addChildrenViews];
    }
    
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addChildrenViews];
    }
    
    return self;
}


- (void) addChildrenViews{
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 100;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.text = @"很大速度哈速冻和导师的挥洒好低啊搜到哈搜滑动天时达偶的活塞的决赛的到四点就暗示你电话吉安市第三季度";
    self.titleLabel.backgroundColor = [UIColor redColor];
    
    
    
    
    self.contentImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.contentImageView];
    self.contentImageView.image = [UIImage imageNamed:@"tupian.jpg"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    //布局
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(40);
//        make.bottom.mas_equalTo(self.contentImageView.mas_top).offset(10);
    }];
    [self layoutIfNeeded];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 20) * 9 / 16);
    }];
}






- (void)awakeFromNib {
    [super awakeFromNib];
    
}













@end
