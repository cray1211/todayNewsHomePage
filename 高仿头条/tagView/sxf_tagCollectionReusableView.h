//
//  CollectionReusableView.h
//  test
//
//  Created by sxf_pro on 2018/5/31.
//  Copyright © 2018年 SXF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sxf_tagCollectionReusableView : UICollectionReusableView
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIButton *editeBtn;
@property (nonatomic ,strong) void(^editeBtnBlock)(UIButton *sender);
@end
