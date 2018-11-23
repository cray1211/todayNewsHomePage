//
//  contentCollectionViewCell.h
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contentCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataModelArr;

//测试用
@property (nonatomic ,strong) UILabel *titleLabel;
@end
