//
//  myCollectionViewCell.m
//  test
//
//  Created by 史小峰 on 2018/5/30.
//  Copyright © 2018年 SXF. All rights reserved.
//

#import "sxf_tagCollectionViewCell.h"

@implementation sxf_tagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.titleLabel.textColor = [UIColor orangeColor];
}

@end
