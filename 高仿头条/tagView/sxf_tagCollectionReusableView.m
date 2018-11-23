//
//  CollectionReusableView.m
//  test
//
//  Created by sxf_pro on 2018/5/31.
//  Copyright © 2018年 SXF. All rights reserved.
//

#import "sxf_tagCollectionReusableView.h"


@interface sxf_tagCollectionReusableView ()
@end

@implementation sxf_tagCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addChidrenViews];
    }
    
    return self;
}

- (void) addChidrenViews{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, self.frame.size.height)];
    
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"分区";
    self.editeBtn.frame = CGRectMake(self.frame.size.width - 60, 0, 40, self.frame.size.height);
    [self addSubview:self.editeBtn];
}

- (UIButton *)editeBtn{
    if(_editeBtn){
        _editeBtn = [[UIButton alloc] init];
        [_editeBtn addTarget:self action:@selector(clickEditerBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_editeBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    return _editeBtn;
}

- (void) clickEditerBtn:(UIButton *)sender{
    if(self.editeBtnBlock){
        self.editeBtnBlock(sender);
    }
}


@end
